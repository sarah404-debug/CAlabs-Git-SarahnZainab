`timescale 1ns / 1ps

module ALU (
    input  [31:0] A,
    input  [31:0] B,
    input  [ 3:0] ALUControl,
    output reg [31:0] ALUResult,
    output            Zero
);

    // Zero flag: high when result is 0
    // In BEQ, if A == B, then A - B = 0, and Zero becomes 1
    assign Zero = (ALUResult == 32'b0);

    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = A + B;               // ADD
            4'b0001: ALUResult = A - B;               // SUB
            4'b0010: ALUResult = A & B;               // AND
            4'b0011: ALUResult = A | B;               // OR
            4'b0100: ALUResult = A ^ B;               // XOR
            4'b0101: ALUResult = A << B[4:0];         // SLL
            4'b0110: ALUResult = A >> B[4:0];         // SRL
            

            4'b0111: ALUResult = A - B;               // BEQ (via subtraction)
            
            default: ALUResult = 32'b0;               // undefined ? 0
        endcase
    end

endmodule