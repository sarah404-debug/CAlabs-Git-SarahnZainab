`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/26/2026 10:43:16 AM
// Design Name: 
// Module Name: control_top_tb
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


module control_top_tb;

reg [6:0] opcode;
reg [2:0] funct3;
reg [6:0] funct7;

wire RegWrite;
wire MemRead;
wire MemWrite;
wire ALUSrc;
wire MemtoReg;
wire Branch;
wire [3:0] ALUControl;

// Instantiate DUT
control_top uut (
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ALUControl(ALUControl)
);

initial begin

// ---------------------------
// R-TYPE TESTS
// ---------------------------

// ADD
opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0000000;
#10;

// SUB
opcode = 7'b0110011; funct3 = 3'b000; funct7 = 7'b0100000;
#10;

// AND
opcode = 7'b0110011; funct3 = 3'b111; funct7 = 7'b0000000;
#10;

// OR
opcode = 7'b0110011; funct3 = 3'b110; funct7 = 7'b0000000;
#10;

// XOR
opcode = 7'b0110011; funct3 = 3'b100; funct7 = 7'b0000000;
#10;

// SLL
opcode = 7'b0110011; funct3 = 3'b001; funct7 = 7'b0000000;
#10;

// SRL
opcode = 7'b0110011; funct3 = 3'b101; funct7 = 7'b0000000;
#10;


// ---------------------------
// I-TYPE (ADDI)
// ---------------------------
opcode = 7'b0010011; funct3 = 3'b000; funct7 = 7'b0000000;
#10;


// ---------------------------
// LOAD (LW)
// ---------------------------
opcode = 7'b0000011; funct3 = 3'b010; funct7 = 7'b0000000;
#10;


// ---------------------------
// STORE (SW)
// ---------------------------
opcode = 7'b0100011; funct3 = 3'b010; funct7 = 7'b0000000;
#10;


// ---------------------------
// BRANCH (BEQ)
// ---------------------------
opcode = 7'b1100011; funct3 = 3'b000; funct7 = 7'b0000000;
#10;


// Finish simulation
#10 $finish;

end

endmodule
