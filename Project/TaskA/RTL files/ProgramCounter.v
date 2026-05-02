//`timescale 1ns / 1ps
//module ProgramCounter(
//    input clk,
//    input reset,
//    input [31:0] nextPC,
//    output reg [31:0] pc
//);

//always @(posedge clk or posedge reset) begin
//    if (reset)
//        pc <= 32'h0000_0000;
//    else
//        pc <= nextPC;
//end

//endmodule

module ProgramCounter(
    input clk,
    input reset,
    input en,           // <--- Add this
    input [31:0] nextPC,
    output reg [31:0] pc
);
    always @(posedge clk) begin
        if (reset)
            pc <= 32'h00000000;
        else if (en)    // <--- Gate the PC update
            pc <= nextPC;
    end
endmodule