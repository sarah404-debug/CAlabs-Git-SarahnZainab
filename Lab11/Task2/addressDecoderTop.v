`timescale 1ns/1ps

module addressDecoderTop(
    input clk,
    input rst,
    input [31:0] address,
    input readEnable,
    input writeEnable,
    input [31:0] writeData,
    input [15:0] switches,
    output [31:0] readData,
    output [15:0] leds
);

wire DataMemWrite, DataMemRead, LEDWrite, SwitchRead;
wire [31:0] memReadData, switchReadData;
wire [8:0] localAddress;

assign localAddress = address[8:0];


// ================= DECODER =================
addressDecoder decoder(
    .deviceSel(address[9:8]),
    .writeEnable(writeEnable),
    .readEnable(readEnable),
    .DataMemWrite(DataMemWrite),
    .DataMemRead(DataMemRead),
    .LEDWrite(LEDWrite),
    .SwitchRead(SwitchRead)
);


// ================= DATA MEMORY =================
dataMemory mem(
    .clk(clk),
    .MemWrite(DataMemWrite),
    .address(localAddress),
    .writeData(writeData),
    .readData(memReadData)
);


// ================= LED =================
leds ledModule(
    .clk(clk),
    .rst(rst),
    .writeData(writeData),
    .writeEnable(LEDWrite),
    .readEnable(1'b0),
    .memAddress(30'b0),
    .readData(),
    .leds(leds)
);


// ================= SWITCH =================
switches switchModule(
    .clk(clk),
    .rst(rst),
    .btns(16'b0),
    .writeData(32'b0),
    .writeEnable(1'b0),
    .readEnable(SwitchRead),
    .memAddress(30'b0),
    .switches(switches),
    .readData(switchReadData)
);


// ================= ? FINAL FIX =================
// IMPORTANT: guard EVERYTHING with readEnable

assign readData =
    (readEnable && (address[9:8] == 2'b00)) ? memReadData :
    (readEnable && (address[9:8] == 2'b10)) ? switchReadData :
    32'b0;

endmodule








