`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 11:18:16 AM
// Design Name: 
// Module Name: switches
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module switches(
    input clk,
    input rst,
    input [31:0] writeData,
    input writeEnable,
    input readEnable,
    input [29:0] memAddress,
    output reg [31:0] readData,
    output reg [15:0] leds
);

    always @(posedge clk) begin
        if (rst) begin
            leds <= 16'd0;
            readData <= 32'd0;
        end
        else begin
            if (writeEnable)
                leds <= writeData[15:0];

            if (readEnable)
                readData <= {16'd0, leds};
        end
    end

endmodule