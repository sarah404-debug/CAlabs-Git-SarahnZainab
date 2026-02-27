`timescale 1ns/1ps

module switches(
    input clk,
    input rst,
    input [31:0] writeData,
    input writeEnable,
    input readEnable,
    input [29:0] memAddress,
    output reg [31:0] readData = 0,
    output reg [15:0] leds // This is the signal for the FSM
);
    always @(posedge clk or posedge rst) begin
        if (rst) leds <= 16'b0;
        else leds <= writeData[15:0]; // Direct latch of switch state
    end
endmodule



