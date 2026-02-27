`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2026 12:39:53 AM
// Design Name: 
// Module Name: sevenseg_basys3
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
module sevenseg_basys3 (
    input clk,
    input [15:0] value,
    output reg [6:0] seg,
    output reg [3:0] an
);
    reg [17:0] refresh_counter;
    always @(posedge clk) refresh_counter <= refresh_counter + 1;

    wire [1:0] active_digit = refresh_counter[17:16];
    reg [3:0] digit_val;

    always @(*) begin
        case(active_digit)
            2'b00: begin digit_val = value % 10; an = 4'b1110; end
            2'b01: begin digit_val = (value / 10) % 10; an = 4'b1101; end
            2'b10: begin digit_val = (value / 100) % 10; an = 4'b1011; end
            2'b11: begin digit_val = (value / 1000) % 10; an = 4'b0111; end
        endcase
    end

    always @(*) begin
        case(digit_val)
            0: seg=7'b1000000; 1: seg=7'b1111001; 2: seg=7'b0100100;
            3: seg=7'b0110000; 4: seg=7'b0011001; 5: seg=7'b0010010;
            6: seg=7'b0000010; 7: seg=7'b1111000; 8: seg=7'b0000000;
            9: seg=7'b0010000; default: seg=7'b1111111;
        endcase
    end
endmodule