`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2026 11:04:41 AM
// Design Name: 
// Module Name: topTask1
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



module topTask1(
    input clk,
    input reset,
    input branch_taken,
    input [31:0] instruction,
    output [31:0] pc
);

    wire [31:0] pc4, imm, branchAddr, nextPC;

    ProgramCounter PC_Reg (
        .clk(clk), 
        .reset(reset), 
        .nextPC(nextPC), 
        .pc(pc)
    );

    pcAdder Sequential_Adder (
        .pc(pc), 
        .pc4(pc4)
    );

    immGen Immediate_Unit (
        .instr(instruction), 
        .imm(imm)
    );

    branchAdder Target_Adder (
        .pc(pc), 
        .imm(imm), 
        .branchAddr(branchAddr)
    );

    mux2 PC_Selector (
        .in0(pc4), 
        .in1(branchAddr), 
        .sel(branch_taken), 
        .out(nextPC)
    );

endmodule