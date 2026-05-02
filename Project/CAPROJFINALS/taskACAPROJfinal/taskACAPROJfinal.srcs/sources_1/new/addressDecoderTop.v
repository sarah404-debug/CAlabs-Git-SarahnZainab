
//`timescale 1ns/1ps

//module addressDecoderTop(
//    input clk,
//    input rst,
//    input [31:0] address,
//    input readEnable,
//    input writeEnable,
//    input [31:0] writeData,
//    input [15:0] switches,
//    output reg [31:0] readData,
//    output reg [15:0] leds
//);

//    // ================= RAM (for stack / memory) =================
//    reg [31:0] ram [0:255];
//    integer i;

//    initial begin
//        for (i = 0; i < 256; i = i + 1)
//            ram[i] = 32'b0;
//    end

//    // ================= WRITE =================
//    always @(posedge clk) begin
//        if (rst) begin
//            leds <= 16'b0;
//        end else if (writeEnable) begin

//            // LED mapped at 0x100
//            if (address == 32'h00000100)
//                leds <= writeData[15:0];

//            // RAM region: 0x000 - 0x0FF
//            else if (address < 32'h00000100)
//                ram[address[9:2]] <= writeData;
//        end
//    end

//    // ================= READ (FIXED) =================
//    always @(*) begin
//        if (readEnable) begin

//            // ? FIX: RANGE CHECK for switches (not exact match)
//            if (address >= 32'h00000200 && address < 32'h00000300)
//                readData = {16'b0, switches};

//            // RAM read
//            else if (address < 32'h00000100)
//                readData = ram[address[9:2]];

//            else
//                readData = 32'b0;

//        end else begin
//            readData = 32'b0;
//        end
//    end

//endmodule




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

    // ================= INTERNAL WIRES =================
    wire [31:0] memReadData;
    wire DataMemWrite;
    
    // ================= MEMORY DECODING LOGIC =================
    // Enable RAM write only if address is in the range 0x000 - 0x0FF
    assign DataMemWrite = (writeEnable && (address < 32'h00000100));

    // ================= DATA MEMORY INSTANTIATION =================
    // Using the external module as requested by instructor
    dataMemory mem (
        .clk(clk),
        .MemWrite(DataMemWrite),
        .address(address[10:2]), // Word-aligned addressing for 512 entries
        .writeData(writeData),
        .readData(memReadData)
    );

    // ================= WRITE LOGIC (LEDs) =================
    always @(posedge clk) begin
        if (rst) begin
            leds <= 16'b0;
        end else if (writeEnable) begin
            // LED mapped specifically at 0x100
            if (address == 32'h00000100)
                leds <= writeData[15:0];
        end
    end

    // ================= READ LOGIC (MUX) =================
    always @(*) begin
        if (readEnable) begin
            // Switch read range: 0x200 - 0x2FF
            if (address >= 32'h00000200 && address < 32'h00000300)
                readData = {16'b0, switches};

            // RAM read range: 0x000 - 0x0FF
            else if (address < 32'h00000100)
                readData = memReadData;

            else
                readData = 32'b0;
        end else begin
            readData = 32'b0;
        end
    end

endmodule