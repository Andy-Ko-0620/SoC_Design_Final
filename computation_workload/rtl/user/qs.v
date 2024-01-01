module qs 
#(  parameter pADDR_WIDTH = 12,
    parameter pDATA_WIDTH = 32,
    parameter Tape_Num    = 11
)
(
    output  reg                     awready,
    output  reg                     wready,
    input   wire                     awvalid,
    input   wire [(pADDR_WIDTH-1):0] awaddr,
    input   wire                     wvalid,
    input   wire [(pDATA_WIDTH-1):0] wdata,
    output  reg                     arready,
    input   wire                     rready,
    input   wire                     arvalid,
    input   wire [(pADDR_WIDTH-1):0] araddr,
    output  reg                     rvalid,
    output  reg [(pDATA_WIDTH-1):0] rdata,    
    
    input   wire                     ss_tvalid, 
    input   wire [(pDATA_WIDTH-1):0] ss_tdata, 
    input   wire                     ss_tlast, 
    output  reg                     ss_tready, 
    input   wire                     sm_tready, 
    output  reg                     sm_tvalid, 
    output  reg [(pDATA_WIDTH-1):0] sm_tdata, 
    output  reg                     sm_tlast, 
    
    // bram for tap RAM
    output  reg [3:0]               tap_WE, //tap is placed at bram and corresponds to 0x40 address in axilite
    output  reg                     tap_EN,
    output  reg [(pDATA_WIDTH-1):0] tap_Di,
    output  reg [(pADDR_WIDTH-1):0] tap_A,
    input   wire [(pDATA_WIDTH-1):0] tap_Do,

    // bram for data RAM
    output  reg [3:0]               data_WE,
    output  reg                     data_EN,
    output  reg [(pDATA_WIDTH-1):0] data_Di,
    output  reg [(pADDR_WIDTH-1):0] data_A,
    input   wire [(pDATA_WIDTH-1):0] data_Do,

    input   wire                     axis_clk,
    input   wire                     axis_rst_n
);

    localparam STATE_RECEIVE_PARAMETERS = 0;
    localparam STATE_EXECUTE = 1;
    localparam STATE_CLEAN_DATA_IN_BRAM = 2;
    reg [2-1:0] state_r;
    reg [2-1:0] state_w;
    reg         pending_sm_tready_r;
    reg         pending_sm_tready_w;
    reg         pending_rready_r;
    reg         pending_rready_w;
    reg         last_r;
    reg         last_w;

    ////////////////////////////////////////
    reg [31:0] qs_input_storage_r [0:9];
    reg [31:0] qs_input_storage_w [0:9];
    reg [31:0] qs_output_storage_r [0:9];
    reg [4:0] qs_input_counter_w, qs_input_counter_r, qs_output_counter_w, qs_output_counter_r;
    localparam QS_LEN = 10;
 
    integer q;
    always@(*) begin
        state_w = state_r;
        wready = 0;
        awready = 0;
        ss_tready = 0;
        sm_tvalid = 0;
        sm_tdata = 0;
        sm_tlast = 0;
        last_w = last_r;
        pending_sm_tready_w = pending_sm_tready_r;
        pending_rready_w = pending_rready_r;
        rvalid = 0;
        rdata = 0;
        arready = 0;

        ////////////////////////////////
        qs_input_counter_w = qs_input_counter_r;
        qs_output_counter_w = qs_output_counter_r;
        for(q=0; q<QS_LEN; q=q+1) begin
            qs_input_storage_w[q] = qs_input_storage_r[q];
        end

        case (state_r)
            STATE_RECEIVE_PARAMETERS: begin
                if (pending_rready_r == 1'b0) begin //prevent bram from being read and written at the same time
                    if ((awvalid == 1'b1) & (wvalid == 1'b1)) begin
                        if ((awaddr >> 4) == 0) begin //address = 0x00
                            if (wdata[0] == 1'b1) begin //ap_start = 1
                                state_w = STATE_EXECUTE;
                            end
                        end
                        else begin //address = 0x40, direct communicate with BRAM
                            ///////////////////////////////////
                            qs_input_storage_w[qs_input_counter_r] = wdata;
                            qs_input_counter_w = qs_input_counter_r + 1;
                        end
                        awready = 1;
                        wready = 1;
                    end
                end
            end
            STATE_EXECUTE: begin
                if ((ss_tvalid == 1'b1) & (pending_sm_tready_r != 1'b1)) begin //second condition prevents fir result from being changed
                    pending_sm_tready_w = 1;
                    ss_tready = 1;
                end
            end
        endcase
        if (pending_sm_tready_r == 1'b1) begin
            sm_tvalid = 1'b1;
            sm_tdata = qs_output_storage_r[qs_output_counter_r];
            if (last_r == 1) begin
                sm_tlast = 1;
            end
            if (sm_tready == 1'b1) begin
                qs_output_counter_w = qs_output_counter_r + 1;
                if (last_r == 1'b1) begin
                    state_w = STATE_CLEAN_DATA_IN_BRAM;
                    last_w = 0;
                end
                pending_sm_tready_w = 0;
            end
        end
        if (arvalid == 1'b1) begin
            pending_rready_w = 1;
            arready = 1;
            if (((araddr >> 4) != 0) & ((araddr >> 4) != 1)) begin
                tap_EN = 1;
                tap_A = araddr[5:0];
            end
        end
        if (pending_rready_r == 1'b1) begin
            rvalid = 1;
            if (rready == 1'b1) begin
                pending_rready_w = 0;
            end
        end
    end
    
    integer k;
    always@(posedge axis_clk) begin
        if (axis_rst_n == 1'b0) begin
            state_r <= STATE_RECEIVE_PARAMETERS;
            pending_rready_r <= 0;
            last_r <= 0;
            pending_sm_tready_r <= 0;
            /////////////////////////////
            qs_input_counter_r <= 0;
            qs_output_counter_r <= 0;
            for(k=0; k<QS_LEN; k=k+1) begin
                qs_input_storage_r[k] <= 0;
            end
        end
        else begin
            state_r <= state_w;
            pending_rready_r <= pending_rready_w;
            last_r <= last_w;
            pending_sm_tready_r <= pending_sm_tready_w;
            ////////////////////////////
            qs_input_counter_r <= qs_input_counter_w;
            qs_output_counter_r <= qs_output_counter_w;
            for(k=0; k<QS_LEN; k=k+1) begin
                qs_input_storage_r[k] <= qs_input_storage_w[k];
            end
        end
    end

    /////////////////////////////////////////////////////////
    integer i, j;
    reg [31:0] temp;
    always @(posedge axis_clk) begin
        for (i = 0; i < QS_LEN; i = i + 1) begin
            qs_output_storage_r[i] = qs_input_storage_r[i];
        end
        for (i = 0; i < QS_LEN; i = i + 1) begin
            for (j = 0; j < QS_LEN -1 - i; j = j + 1) begin
                if (qs_output_storage_r[j] > qs_output_storage_r[j+1]) begin
                    temp = qs_output_storage_r[j];
                    qs_output_storage_r[j] = qs_output_storage_r[j+1];
                    qs_output_storage_r[j+1] = temp;
                end
            end
        end
    end

endmodule
