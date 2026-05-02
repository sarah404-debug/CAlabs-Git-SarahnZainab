`timescale 1ns/1ps

module addressDecoderTop(
    input clk,
    input rst,
    input [31:0] address,
    input readEnable,
    input writeEnable,
    input [31:0] writeData,
    input [15:0] switches,
    output reg [31:0] readData,
    output reg [15:0] leds
);

    // ================= RAM (for stack / memory) =================
    reg [31:0] ram [0:255];
    integer i;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            ram[i] = 32'b0;
    end

    // ================= WRITE =================
    always @(posedge clk) begin
        if (rst) begin
            leds <= 16'b0;
        end else if (writeEnable) begin

            // LED mapped at 0x100
            if (address == 32'h00000100)
                leds <= writeData[15:0];

            // RAM region: 0x000 - 0x0FF
            else if (address < 32'h00000100)
                ram[address[9:2]] <= writeData;
        end
    end

    // ================= READ (FIXED) =================
    always @(*) begin
        if (readEnable) begin

            // ? FIX: RANGE CHECK for switches (not exact match)
            if (address >= 32'h00000200 && address < 32'h00000300)
                readData = {16'b0, switches};

            // RAM read
            else if (address < 32'h00000100)
                readData = ram[address[9:2]];

            else
                readData = 32'b0;

        end else begin
            readData = 32'b0;
        end
    end

endmodule