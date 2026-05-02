`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2026 01:27:11 PM
// Design Name: 
// Module Name: clk_divider
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

module clk_divider(
    input clk,
    output reg slowEnable
);

    reg [25:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        slowEnable <= counter[0];
        //slowEnable <= 1'b1;
    end

endmodule
