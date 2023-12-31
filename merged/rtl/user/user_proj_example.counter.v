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

`default_nettype none
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
//--------------------------------------------------
    wire is_exmem, is_mm, is_fir;
    assign is_exmem = (wbs_adr_i[31:24]==8'h38);
    assign is_mm = (wbs_adr_i[31:20]==12'h301);
    assign is_fir = (wbs_adr_i[31:20]==12'h300);

// -----global -------
    assign clk = (~la_oenb[64]) ? la_data_in[64]: wb_clk_i;
    assign rst = (~la_oenb[65]) ? la_data_in[65]: wb_rst_i;	
    assign wbs_ack_o = ex_ack | wb_mm_ack | wb_fir_ack;
    assign wbs_dat_o = is_exmem ? ex_dat_o: 
                       is_mm ? wb_mm_dat_o: wb_fir_dat_o;
// ------ when adr=3800_0000 to exmemfir------
    wire ex_stb;
    wire ex_cyc;
    wire ex_we;
    wire [3:0] ex_sel;
    wire [31:0] ex_dat_o;
    wire ex_ack;
    assign ex_stb = wbs_stb_i & (wbs_adr_i[31:24]==8'h38);
    assign ex_cyc = wbs_cyc_i & (wbs_adr_i[31:24]==8'h38);
    assign ex_we = wbs_we_i & (wbs_adr_i[31:24]==8'h38);
    assign ex_sel = wbs_sel_i & {4{(wbs_adr_i[31:24]==8'h38)}};
  

    exmem_fir user_exmem_fir (
     .wb_clk_i(clk),
     .wb_rst_i(rst),
     .wbs_stb_i(ex_stb),
     .wbs_cyc_i(ex_cyc),
     .wbs_we_i(ex_we),
     .wbs_sel_i(ex_sel),
     .wbs_dat_i(wbs_dat_i),
     .wbs_adr_i(wbs_adr_i),
     .wbs_ack_o(ex_ack),
     .wbs_dat_o(ex_dat_o)
    );
// ------ when adr=3010_0000 to wb2axi_mm------
    wire wb_mm_stb;
    wire wb_mm_cyc;
    wire wb_mm_we;
    wire [3:0] wb_mm_sel;
    wire [31:0] wb_mm_dat_o;
    wire wb_mm_ack;
    assign wb_mm_stb = wbs_stb_i & (wbs_adr_i[31:20]==12'h301);
    assign wb_mm_cyc = wbs_cyc_i & (wbs_adr_i[31:20]==12'h301);
    assign wb_mm_we = wbs_we_i & (wbs_adr_i[31:20]==12'h301);
    assign wb_mm_sel = wbs_sel_i & {4{(wbs_adr_i[31:20]==12'h301)}};
    
    
    wb2axi user_wb2axi_mm (
     .wb_clk_i(clk),
     .wb_rst_i(rst),
     .wbs_stb_i(wb_mm_stb),
     .wbs_cyc_i(wb_mm_cyc),
     .wbs_we_i(wb_mm_we),
     .wbs_sel_i(wb_mm_sel),
     .wbs_dat_i(wbs_dat_i),
     .wbs_adr_i(wbs_adr_i),
     .wbs_ack_o(wb_mm_ack),
     .wbs_dat_o(wb_mm_dat_o)
    );
// ------ when adr=3000_0000 to wb2axi_fir------
    wire wb_fir_stb;
    wire wb_fir_cyc;
    wire wb_fir_we;
    wire [3:0] wb_fir_sel;
    wire [31:0] wb_fir_dat_o;
    wire wb_fir_ack;
    assign wb_fir_stb = wbs_stb_i & (wbs_adr_i[31:20]==12'h300);
    assign wb_fir_cyc = wbs_cyc_i & (wbs_adr_i[31:20]==12'h300);
    assign wb_fir_we = wbs_we_i & (wbs_adr_i[31:20]==12'h300);
    assign wb_fir_sel = wbs_sel_i & {4{(wbs_adr_i[31:20]==12'h300)}};
    
    
    wb2axi user_wb2axi_fir (
     .wb_clk_i(clk),
     .wb_rst_i(rst),
     .wbs_stb_i(wb_fir_stb),
     .wbs_cyc_i(wb_fir_cyc),
     .wbs_we_i(wb_fir_we),
     .wbs_sel_i(wb_fir_sel),
     .wbs_dat_i(wbs_dat_i),
     .wbs_adr_i(wbs_adr_i),
     .wbs_ack_o(wb_fir_ack),
     .wbs_dat_o(wb_fir_dat_o)
    );
    
// -----Unused------------
    assign io_out = wbs_dat_o;
    assign io_oeb = {(`MPRJ_IO_PADS-1){rst}};
    assign irq = 3'b000;
    assign la_data_out = 0;	
    
endmodule



`default_nettype wire
