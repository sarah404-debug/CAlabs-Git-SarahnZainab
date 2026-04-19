`timescale 1ns / 1ps

module instructionMemory#(
    parameter OPERAND_LENGTH = 31
)(
    input  [OPERAND_LENGTH:0] instAddress,
    output reg [31:0] instruction
);

    // Byte-addressable memory (256 bytes)
    reg [7:0] memory [0:255];

    // Load machine code from file
    initial begin
        $readmemh("prog.mem", memory);
    end

    // Output instruction based on PC (Little Endian)
    always @(*) begin
        instruction = {
            memory[instAddress + 3],
            memory[instAddress + 2],
            memory[instAddress + 1],
            memory[instAddress]
        };
    end

endmodule