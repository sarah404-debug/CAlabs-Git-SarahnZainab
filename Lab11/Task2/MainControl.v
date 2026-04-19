//`timescale 1ns / 1ps
//// Main Control Unit - Generates control signals for the datapath

//module MainControl (
//    input  [6:0] opcode,
//    output reg       regWrite,
//    output reg       memRead,
//    output reg       memWrite,
//    output reg       aluSrc,
//    output reg       memToReg,
//    output reg       branch,
//    output reg [1:0] aluOp
//);

//    always @(*) begin
//        case (opcode)
//            // R-type instructions
//            7'b0110011: begin
//                regWrite = 1'b1;  memRead = 1'b0;  memWrite = 1'b0;
//                aluSrc   = 1'b0;  memToReg = 1'b0; branch   = 1'b0;
//                aluOp    = 2'b10;
//            end

//            // I-type (ADDI) and Load (LW)
//            7'b0010011, 7'b0000011: begin
//                regWrite = 1'b1;
//                memRead  = (opcode == 7'b0000011);
//                memWrite = 1'b0;
//                aluSrc   = 1'b1;
//                memToReg = (opcode == 7'b0000011);
//                branch   = 1'b0;
//                aluOp    = 2'b00;
//            end

//            // Store (SW)
//            7'b0100011: begin
//                regWrite = 1'b0;  memRead = 1'b0;  memWrite = 1'b1;
//                aluSrc   = 1'b1;  memToReg = 1'b0; branch   = 1'b0;
//                aluOp    = 2'b00;
//            end

//            // Branch (BEQ)
//            7'b1100011: begin
//                regWrite = 1'b0;  memRead = 1'b0;  memWrite = 1'b0;
//                aluSrc   = 1'b0;  memToReg = 1'b0; branch   = 1'b1;
//                aluOp    = 2'b01;
//            end

//            default: begin
//                regWrite = 1'b0; memRead = 1'b0; memWrite = 1'b0;
//                aluSrc   = 1'b0; memToReg= 1'b0; branch   = 1'b0;
//                aluOp    = 2'b00;
//            end
//        endcase
//    end

//endmodule





`timescale 1ns / 1ps

module MainControl(
    input [6:0] opcode,
    output reg regWrite,
    output reg memRead,
    output reg memWrite,
    output reg aluSrc,
    output reg memToReg,
    output reg branch,
    output reg [1:0] aluOp
);

    always @(*) begin
        // Defaults to prevent errors
        regWrite = 0; memRead = 0; memWrite = 0;
        aluSrc = 0; memToReg = 0; branch = 0; aluOp = 2'b00;

        case(opcode)
            7'b0110011: begin // R-Type
                regWrite = 1; aluOp = 2'b10;
            end
            7'b0010011: begin // I-Type
                regWrite = 1; aluSrc = 1; aluOp = 2'b11; 
            end
            7'b0000011: begin // LW
                regWrite = 1; aluSrc = 1; memRead = 1; memToReg = 1; aluOp = 2'b00;
            end
            7'b0100011: begin // SW
                aluSrc = 1; memWrite = 1; aluOp = 2'b00;
            end
            7'b1100011: begin // BEQ
                branch = 1; aluOp = 2'b01;
            end
            7'b0110111: begin // LUI (ADDED SUPPORT)
                regWrite = 1; aluSrc = 1; aluOp = 2'b00; // Tell ALU to just Add
            end
        endcase
    end
endmodule