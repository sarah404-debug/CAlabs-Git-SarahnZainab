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
    input rst,
    output reg slowEnable
);
    // 26 bits allows for a very slow count
    reg [25:0] counter = 0;

    always @(posedge clk) begin
        if (rst) begin
            counter <= 0;
            slowEnable <= 0;
        end else begin
            // 100MHz / 2^24 is approx 6Hz
            counter <= counter + 1;
            
            // This generates a pulse for exactly one 100MHz cycle
            if (counter == 26'd16777215) begin 
                slowEnable <= 1'b1;
                counter <= 0;
            end else begin
                slowEnable <= 1'b0;
            end
        end
    end
endmodule
