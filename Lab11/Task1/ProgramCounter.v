`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 11:01:44 AM
// Design Name: 
// Module Name: ProgramCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//module ProgramCounter(
//    input clk,
//    input reset,
//    input [31:0] nextPC,
//    output reg [31:0] pc
//);

//always @(posedge clk or posedge reset) begin
//    if (reset)
//        pc <= 32'b0;
//    else
//        pc <= nextPC;
//end

//endmodule


module ProgramCounter(
    input clk,
    input reset,
    input [31:0] nextPC,
    output reg [31:0] pc
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'h0000_0000;
    else
        pc <= nextPC;
end

endmodule