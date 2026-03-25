`timescale 1ns / 1ps

module ALU_tb;
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire Zero;

    // Instantiate the ALU module
    ALU alu(
        .A(A), 
        .B(B), 
        .ALUControl(ALUControl), 
        .ALUResult(ALUResult), 
        .Zero(Zero)
    );

    initial begin
        $display("Starting ALU Verification...");
        $display("---------------------------------------");

        // ADD: 10 + 5 = 15
        A = 10; B = 5; ALUControl = 4'b0000;
        #10;
        $display("ADD:  %0d + %0d = %0d (Zero=%b)", A, B, ALUResult, Zero);

        // SUB: 10 - 5 = 5
        A = 10; B = 5; ALUControl = 4'b0001;
        #10;
        $display("SUB:  %0d - %0d = %0d (Zero=%b)", A, B, ALUResult, Zero);

        // AND: 10 & 5 = 0
        A = 10; B = 5; ALUControl = 4'b0010;
        #10;
        $display("AND:  %0d & %0d = %0d (Zero=%b)", A, B, ALUResult, Zero);

        // OR: 10 | 5 = 15
        A = 10; B = 5; ALUControl = 4'b0011;
        #10;
        $display("OR:   %0d | %0d = %0d (Zero=%b)", A, B, ALUResult, Zero);

        // XOR: 10 ^ 5 = 15
        A = 10; B = 5; ALUControl = 4'b0100;
        #10;
        $display("XOR:  %0d ^ %0d = %0d (Zero=%b)", A, B, ALUResult, Zero);

        // SLL: 10 << 2 = 40
        A = 10; B = 2; ALUControl = 4'b0101;
        #10;
        $display("SLL:  %0d << %0d = %0d", A, B, ALUResult);

        // SRL: 10 >> 2 = 2
        A = 10; B = 2; ALUControl = 4'b0110;
        #10;
        $display("SRL:  %0d >> %0d = %0d", A, B, ALUResult);

        // BEQ - Equal Case: 7 == 7
        // Result should be 0, Zero flag should be 1
        A = 7; B = 7; ALUControl = 4'b0111;
        #10;
        $display("BEQ (Equal): %0d == %0d -> Result=%0d, Zero=%b", A, B, ALUResult, Zero);

        // BEQ - Not Equal Case: 7 == 3
        // Result should be 4 (7-3), Zero flag should be 0
        A = 7; B = 3; ALUControl = 4'b0111;
        #10;
        $display("BEQ (Not Equal): %0d == %0d -> Result=%0d, Zero=%b", A, B, ALUResult, Zero);

        $display("---------------------------------------");
        $display("Verification Complete.");
        $finish;
    end
endmodule
