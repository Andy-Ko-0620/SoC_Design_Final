// module bram11 (clk, we, re, waddr, raddr, wdi, rdo);
//     parameter ADDR_WIDTH = 12;
//     parameter SIZE = 11;
//     parameter BIT_WIDTH = 32;
//     input                          clk;
//     input                          we, re;
//     input [ADDR_WIDTH-1:0]         waddr, raddr;
//     input [BIT_WIDTH-1:0]          wdi;
//     output reg [BIT_WIDTH-1:0]     rdo;
//     reg [BIT_WIDTH-1:0] RAM [SIZE-1:0];
    
//     always @(posedge clk)begin
//         if(re) rdo <= RAM[raddr];
//     end
    
//     always @(posedge clk)begin
//         if(we) RAM[waddr] <= wdi;
//     end
    
// endmodule

module bram11 
(
    CLK,
    WE,
    EN,
    Di,
    Do,
    A
);

    input   wire            CLK;
    input   wire    [3:0]   WE;
    input   wire            EN;
    input   wire    [31:0]  Di;
    output  wire     [31:0]  Do;
    input   wire    [11:0]   A; 

    //  11 words
	reg [31:0] RAM[0:10];
    reg [11:0] r_A;

    always @(posedge CLK) begin
        r_A <= A;
    end

    assign Do = {32{EN}} & RAM[r_A>>2];    // read

    reg [31:0] Temp_D;
    always @(posedge CLK) begin
        if(EN) begin
	    if(WE[0]) RAM[A>>2][7:0] <= Di[7:0];
            if(WE[1]) RAM[A>>2][15:8] <= Di[15:8];
            if(WE[2]) RAM[A>>2][23:16] <= Di[23:16];
            if(WE[3]) RAM[A>>2][31:24] <= Di[31:24];
        end
    end

endmodule