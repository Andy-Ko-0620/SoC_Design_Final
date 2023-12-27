// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype wire
/*
 *-------------------------------------------------------------
 *
 * user_proj_example
 *
 * This is an example of a (trivially simple) user project,
 * showing how the user project can connect to the logic
 * analyzer, the wishbone bus, and the I/O pads.
 *
 * This project generates an integer count, which is output
 * on the user area GPIO pads (digital output only).  The
 * wishbone connection allows the project to be controlled
 * (start and stop) from the management SoC program.
 *
 * See the testbenches in directory "mprj_counter" for the
 * example programs that drive this user project.  The three
 * testbenches are "io_ports", "la_test1", and "la_test2".
 *
 *-------------------------------------------------------------
 */
`define MPRJ_IO_PADS_1 19	/* number of user GPIO pads on user1 side */
`define MPRJ_IO_PADS_2 19	/* number of user GPIO pads on user2 side */
`define MPRJ_IO_PADS (`MPRJ_IO_PADS_1 + `MPRJ_IO_PADS_2)
module user_proj_example #(
    parameter BITS = 32,
    parameter DELAYS=10
)(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V supply
    inout vssd1,	// User area 1 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // IRQ
    output [2:0] irq
);
    wire clk;
    wire rst;

    wire [`MPRJ_IO_PADS-1:0] io_in;
    wire [`MPRJ_IO_PADS-1:0] io_out;
    wire [`MPRJ_IO_PADS-1:0] io_oeb;

    wire [31:0] mem_rdata, fir_rdata; 
    // wire [31:0] wdata;
    wire [BITS-1:0] count;

    wire valid;
    wire [3:0] wstrb;
    wire [31:0] la_write;
    wire user_bram_path; //0x3800_0000
    wire fir_path = !user_bram_path;

    reg user_bram_ready;
    wire fir_ready;
    reg [BITS-17:0] delayed_count;
    
    //bram for tap and data
    wire [3:0]  tap_WE;
    wire        tap_EN;
    wire [31:0] tap_Di;
    wire [31:0] tap_Do;
    wire [11:0] tap_A; 

    wire [3:0]  data_WE;
    wire        data_EN;
    wire [31:0] data_Di;
    wire [31:0] data_Do;
    wire [11:0] data_A; 

    //AXI interface
    wire        awready;
    wire        wready;
    wire        awvalid;
    wire [11:0] awaddr;
    wire        wvalid;
    wire [31:0] wdata;
    wire        arready;
    wire        rready;
    wire        arvalid;
    wire [11:0] araddr;
    wire        rvalid;
    wire [31:0] rdata;    
    wire        ss_tvalid; 
    wire [31:0] ss_tdata; 
    wire        ss_tlast; 
    wire        ss_tready; 
    wire        sm_tready; 
    wire        sm_tvalid; 
    wire [31:0] sm_tdata; 
    wire        sm_tlast; 

    // WB MI A
    assign valid = wbs_cyc_i && wbs_stb_i; 
    assign wstrb = wbs_sel_i & {4{wbs_we_i}};
    assign wbs_dat_o = user_bram_ready ? mem_rdata : fir_rdata;
    // assign wdata = wbs_dat_i;
    assign wbs_ack_o = user_bram_ready | fir_ready;

    // IO
    assign io_out = count;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};

    // IRQ
    assign irq = 3'b000;	// Unused

    // LA
    assign la_data_out = {{(127-BITS){1'b0}}, count};
    // Assuming LA probes [63:32] are for controlling the count register  
    assign la_write = ~la_oenb[63:32] & ~{BITS{valid}};
    // Assuming LA probes [65:64] are for controlling the count clk & reset  
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;

    assign user_bram_path = wbs_adr_i[31:20] == 12'h380 ? 1'b1 : 1'b0;

    always @(posedge clk) begin
        if (rst) begin
            user_bram_ready <= 1'b0;
            delayed_count <= 16'b0;
        end else begin
            user_bram_ready <= 1'b0;
            if ( user_bram_valid && !user_bram_ready ) begin
                if ( delayed_count == DELAYS ) begin
                    delayed_count <= 16'b0;
                    user_bram_ready <= 1'b1;
                end else begin
                    delayed_count <= delayed_count + 1;
                end
            end
        end
    end

/*
    counter #(
        .BITS(BITS)
    ) counter(
        .clk(clk),
        .reset(rst),
        .ready(wbs_ack_o),
        .valid(valid),
        .rdata(rdata),
        .wdata(wbs_dat_i),
        .wstrb(wstrb),
        .la_write(la_write),
        .la_input(la_data_in[63:32]),
        .count(count)
    );
*/
    wire user_bram_valid = valid & user_bram_path;
    bram user_bram (
        .CLK(clk),
        .WE0(wstrb),
        .EN0(user_bram_valid),
        .Di0(wbs_dat_i),
        .Do0(mem_rdata),
        .A0(wbs_adr_i)
    );

    wire fir_valid = valid && fir_path;
    WB2AXI user_WB2AXI (
        //AXI interface
        .awready(awready),
        .wready(wready),
        .awvalid(awvalid),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wdata(wdata),
        .arready(arready),
        .rready(rready),
        .arvalid(arvalid),
        .araddr(araddr),
        .rvalid(rvalid),
        .rdata(rdata),    
        .ss_tvalid(ss_tvalid), 
        .ss_tdata(ss_tdata), 
        .ss_tlast(ss_tlast), 
        .ss_tready(ss_tready), 
        .sm_tready(sm_tready), 
        .sm_tvalid(sm_tvalid), 
        .sm_tdata(sm_tdata), 
        .sm_tlast(sm_tlast), 

        //WB interface
        .wb_wstrb(wstrb),
        .fir_path_valid(fir_valid),
        .wb_dat(wbs_dat_i),
        .wb_rdata(fir_rdata),
        .wb_adr(wbs_adr_i),

        .fir_ready(fir_ready),

        .clk(clk),
        .rst(rst)
    );

    fir user_fir (
        //AXI interface
        .awready(awready),
        .wready(wready),
        .awvalid(awvalid),
        .awaddr(awaddr),
        .wvalid(wvalid),
        .wdata(wdata),
        .arready(arready),
        .rready(rready),
        .arvalid(arvalid),
        .araddr(araddr),
        .rvalid(rvalid),
        .rdata(rdata),    
        .ss_tvalid(ss_tvalid), 
        .ss_tdata(ss_tdata), 
        .ss_tlast(ss_tlast), 
        .ss_tready(ss_tready), 
        .sm_tready(sm_tready), 
        .sm_tvalid(sm_tvalid), 
        .sm_tdata(sm_tdata), 
        .sm_tlast(sm_tlast), 
        
        // bram for tap RAM
        .tap_WE(tap_WE), //tap is placed at bram and corresponds to 0x20 address in axilite
        .tap_EN(tap_EN),
        .tap_Di(tap_Di),
        .tap_A(tap_A),
        .tap_Do(tap_Do),

        // bram for data RAM
        .data_WE(data_WE),
        .data_EN(data_EN),
        .data_Di(data_Di),
        .data_A(data_A),
        .data_Do(data_Do),

        .axis_clk(clk),
        .axis_rst_n(~rst)
    );
    
    bram11 user_bram11_tap
    (
        .CLK(clk),
        .WE(tap_WE),
        .EN(tap_EN),
        .Di(tap_Di),
        .Do(tap_Do),
        .A(tap_A)
    );

    bram11 user_bram11_data
    (
        .CLK(clk),
        .WE(data_WE),
        .EN(data_EN),
        .Di(data_Di),
        .Do(data_Do),
        .A(data_A)
    );

endmodule

module WB2AXI (
    //AXI interface
    input wire        awready,
    input wire        wready,
    output reg        awvalid,
    output reg [11:0] awaddr,
    output reg        wvalid,
    output reg [31:0] wdata,
    input wire        arready,
    output reg        rready,
    output reg        arvalid,
    output reg [11:0] araddr,
    input wire        rvalid,
    input wire [31:0] rdata,    
    output reg        ss_tvalid, 
    output reg [31:0] ss_tdata, 
    output reg        ss_tlast, 
    input wire        ss_tready, 
    output reg        sm_tready, 
    input wire        sm_tvalid, 
    input wire [31:0] sm_tdata, 
    input wire        sm_tlast, 

    //WB interface
    input wire [3:0]  wb_wstrb,
    input wire        fir_path_valid,
    input wire [31:0] wb_dat,
    output reg [31:0] wb_rdata,
    input wire [31:0] wb_adr,

    output reg        fir_ready,

    input wire        clk,
    input wire        rst
);
    
    reg [31:0] data_len, count;
    // reg data_len_ready;

    always @(*) begin
        awvalid = fir_path_valid & (~wb_adr[7]) & (|wb_wstrb);
        awaddr = wb_adr;
        wvalid = fir_path_valid & (~wb_adr[7]) & (|wb_wstrb);
        wdata = wb_dat;
        rready = rvalid;
        arvalid = fir_path_valid & (~wb_adr[7]) & (~(|wb_wstrb));
        araddr = wb_adr;
        ss_tvalid = fir_path_valid & wb_adr[7] & (~wb_adr[2]) & (|wb_wstrb);
        ss_tdata = wb_dat;
        ss_tlast = count == (data_len-1);
        sm_tready = fir_path_valid & sm_tvalid & wb_adr[7] & wb_adr[2] & (~(|wb_wstrb));
        wb_rdata = sm_tvalid ? sm_tdata : rdata;
        // fir_ready = ss_tready | arready | awready | wready | rvalid | sm_tvalid;
        fir_ready = ss_tready | wready | rvalid | sm_tvalid;
    end

    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
            data_len <= 0;
            // data_len_ready <= 0;
        end else begin
            // data_len_ready <= 0;
            if (fir_path_valid & (~wb_adr[7]) & (~wb_adr[6]) & wb_adr[4] & (|wb_wstrb)) begin
                data_len <= wb_dat;
                // data_len_ready <= 1;
            end
            if (ss_tvalid & ss_tready) begin
                count <= count + 1;
                if (ss_tlast & ss_tready) begin
                    count <= 0;
                end
            end
        end
    end
endmodule

// module counter #(
//     parameter BITS = 32
// )(
//     input clk,
//     input reset,
//     input valid,
//     input [3:0] wstrb,
//     input [BITS-1:0] wdata,
//     input [BITS-1:0] la_write,
//     input [BITS-1:0] la_input,
//     output ready,
//     output [BITS-1:0] rdata,
//     output [BITS-1:0] count
// );
//     reg ready;
//     reg [BITS-1:0] count;
//     reg [BITS-1:0] rdata;

//     always @(posedge clk) begin
//         if (reset) begin
//             count <= 0;
//             ready <= 0;
//         end else begin
//             ready <= 1'b0;
//             if (~|la_write) begin
//                 count <= count + 1;
//             end
//             if (valid && !ready) begin
//                 ready <= 1'b1;
//                 rdata <= count;
//                 if (wstrb[0]) count[7:0]   <= wdata[7:0];
//                 if (wstrb[1]) count[15:8]  <= wdata[15:8];
//                 if (wstrb[2]) count[23:16] <= wdata[23:16];
//                 if (wstrb[3]) count[31:24] <= wdata[31:24];
//             end else if (|la_write) begin
//                 count <= la_write & la_input;
//             end
//         end
//     end

// endmodule

`default_nettype wire
