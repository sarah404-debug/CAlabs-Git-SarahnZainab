`timescale 1ns/1ps
module dataMemory(
    input         clk,
    input         MemWrite,
    input  [8:0]  address,
    input  [31:0] writeData,
    output [31:0] readData     // combinational read - always fresh
);

reg [31:0] memory [0:511];

// Write on rising clock edge
always @(posedge clk) begin
    if (MemWrite)
        memory[address] <= writeData;
end

// Combinational read - no pipeline delay, FSM safe
assign readData = memory[address];

endmodule