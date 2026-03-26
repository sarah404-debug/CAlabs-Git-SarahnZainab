`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2026 10:41:30 AM
// Design Name: 
// Module Name: control_top
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


module control_top(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output RegWrite,
    output MemRead,
    output MemWrite,
    output ALUSrc,
    output MemtoReg,
    output Branch,
    output [3:0] ALUControl
);

wire [1:0] ALUOp;

// Main Control
MainControl mc(
    .opcode(opcode),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ALUOp(ALUOp)
);

// ALU Control
ALUControl ac(
    .ALUOp(ALUOp),
    .funct3(funct3),
    .funct7(funct7),
    .ALUControl(ALUControl)
);

endmodule
