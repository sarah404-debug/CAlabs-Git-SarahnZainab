//`timescale 1ns / 1ps

//module MainControl(
//    input  [6:0] opcode,

//    output reg regWrite,
//    output reg memRead,
//    output reg memWrite,
//    output reg aluSrc,
//    output reg memToReg,
//    output reg branch,
//    output reg [1:0] aluOp
//);

//always @(*) begin
//    // ================= DEFAULTS =================
//    regWrite = 0;
//    memRead  = 0;
//    memWrite = 0;
//    aluSrc   = 0;
//    memToReg = 0;
//    branch   = 0;
//    aluOp    = 2'b00;

//    case(opcode)

//        // ================= R-TYPE =================
//        // add, sub, and, or
//        7'b0110011: begin
//            regWrite = 1;
//            aluSrc   = 0;
//            aluOp    = 2'b10;
//        end

//        // ================= I-TYPE =================
//        // addi
//        7'b0010011: begin
//            regWrite = 1;
//            aluSrc   = 1;
//            aluOp    = 2'b00;   // ADD
//        end

//        // ================= LOAD =================
//        // lw
//        7'b0000011: begin
//            regWrite = 1;
//            memRead  = 1;
//            aluSrc   = 1;
//            memToReg = 1;
//            aluOp    = 2'b00;
//        end

//        // ================= STORE =================
//        // sw
//        7'b0100011: begin
//            memWrite = 1;
//            aluSrc   = 1;
//            aluOp    = 2'b00;
//        end

//        // ================= BRANCH =================
//        // beq, bne
//        7'b1100011: begin
//            branch = 1;
//            aluOp  = 2'b01;   // SUB for comparison
//        end

//        // ================= LUI (OPTIONAL) =================
//        7'b0110111: begin
//            regWrite = 1;
//            aluSrc   = 1;
//            aluOp    = 2'b00;
//        end

//    endcase
//end

//endmodule

`timescale 1ns / 1ps

module MainControl(
    input  [6:0] opcode,
    output reg regWrite,
    output reg memRead,
    output reg memWrite,
    output reg aluSrc,
    output reg memToReg,
    output reg branch,
    output reg [1:0] aluOp
);

always @(*) begin
    // Defaults
    regWrite = 0;
    memRead  = 0;
    memWrite = 0;
    aluSrc   = 0;
    memToReg = 0;
    branch   = 0;
    aluOp    = 2'b00;

    case(opcode)

        // R-TYPE (add, sub, and, or, slt, etc.)
        7'b0110011: begin
            regWrite = 1;
            aluSrc   = 0;
            aluOp    = 2'b10; // Use funct3/funct7 to decide ALU op
        end

        // I-TYPE (addi, slli, etc.)
        7'b0010011: begin
            regWrite = 1;
            aluSrc   = 1;
            // FIX: Set to 2'b00 to force ADD, or use a new code if 
            // you plan to support I-type ORI/XORI/ANDI later.
            aluOp    = 2'b00; 
        end

        // LOAD (lw)
        7'b0000011: begin
            regWrite = 1;
            memRead  = 1;
            aluSrc   = 1;
            memToReg = 1;
            aluOp    = 2'b00; // Force ADD for address calculation
        end

        // STORE (sw)
        7'b0100011: begin
            memWrite = 1;
            aluSrc   = 1;
            aluOp    = 2'b00; // Force ADD for address calculation
        end

        // BRANCH (beq, bne, blt)
        7'b1100011: begin
            aluSrc   = 0;
            branch   = 1;
            aluOp    = 2'b01; // Force SUB for comparison
        end

        // JAL / JALR / LUI (Standard settings)
        7'b1101111: regWrite = 1; // JAL
        7'b1100111: begin         // JALR
            regWrite = 1;
            aluSrc   = 1;
        end
        7'b0110111: begin         // LUI
            regWrite = 1;
            aluSrc   = 1;
        end

        default: begin
            regWrite = 0;
            aluOp    = 2'b00;
        end
    endcase
end

endmodule
