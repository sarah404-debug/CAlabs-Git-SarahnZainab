//`timescale 1ns / 1ps
//module control_top(
//    input [6:0] opcode,
//    input [2:0] funct3,
//    input [6:0] funct7,
//    output RegWrite,
//    output MemRead,
//    output MemWrite,
//    output ALUSrc,
//    output MemtoReg,
//    output Branch,
//    output [3:0] ALUControl
//);
//wire [1:0] ALUOp;
//// Main Control
//MainControl mc(
//    .opcode(opcode),
//    .RegWrite(RegWrite),
//    .MemRead(MemRead),
//    .MemWrite(MemWrite),
//    .ALUSrc(ALUSrc),
//    .MemtoReg(MemtoReg),
//    .Branch(Branch),
//    .ALUOp(ALUOp)
//);
//// ALU Control
//ALUControl ac(
//    .ALUOp(ALUOp),
//    .funct3(funct3),
//    .funct7(funct7),
//    .ALUControl(ALUControl)
//);
//endmodule

`timescale 1ns / 1ps
// Top Control Module - Combines Main Control and ALU Control

module control_top (
    input  [6:0] opcode,
    input  [2:0] funct3,
    input  [6:0] funct7,

    output       regWrite,
    output       memRead,
    output       memWrite,
    output       aluSrc,
    output       memToReg,
    output       branch,
    output [3:0] aluControl
);

    wire [1:0] aluOp;

    MainControl mainCtrl (
        .opcode   (opcode),
        .regWrite (regWrite),
        .memRead  (memRead),
        .memWrite (memWrite),
        .aluSrc   (aluSrc),
        .memToReg (memToReg),
        .branch   (branch),
        .aluOp    (aluOp)
    );

    ALUControl aluCtrl (
        .aluOp          (aluOp),
        .funct3         (funct3),
        .funct7         (funct7),
        .aluControlSignal (aluControl)
    );

endmodule