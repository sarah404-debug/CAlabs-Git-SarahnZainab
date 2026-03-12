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

wire DataMemWrite;
wire DataMemRead;
wire LEDWrite;
wire SwitchRead;

wire [31:0] memReadData;
wire [31:0] switchReadData;

wire [8:0] localAddress;

assign localAddress = address[8:0];


// Address Decoder
addressDecoder decoder(

    .deviceSel(address[9:8]),
    .writeEnable(writeEnable),
    .readEnable(readEnable),

    .DataMemWrite(DataMemWrite),
    .DataMemRead(DataMemRead),

    .LEDWrite(LEDWrite),
    .SwitchRead(SwitchRead)

);


// Data Memory
dataMemory mem(

    .clk(clk),
    .MemWrite(DataMemWrite),
    .address(localAddress),
    .writeData(writeData),
    .readData(memReadData)

);


// LED module (Lab 5)
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


// Switch module (Lab 5)
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


// Read data mux
assign readData =
        (address[9:8] == 2'b00) ? memReadData :
        (address[9:8] == 2'b10) ? switchReadData :
        32'b0;

endmodule