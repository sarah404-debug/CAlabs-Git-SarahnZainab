`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 10:08:06 AM
// Design Name: 
// Module Name: countdown_fsm
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


module countdown_fsm(
    input clk,
    input rst,
    input [15:0] switch_in,
    output reg [15:0] led_out
);

    reg state;
    parameter IDLE = 1'b0;
    parameter RUN  = 1'b1;

    reg [15:0] count_reg;

    // State logic
    always @(posedge clk) begin
        if (rst)
            state <= IDLE;
        else begin
            case (state)

                IDLE: begin
                    if (switch_in != 0)
                        state <= RUN;
                end

                RUN: begin
                    if (count_reg == 0)
                        state <= IDLE;
                end

            endcase
        end
    end

    // Counter logic
    always @(posedge clk) begin
        if (rst)
            count_reg <= 16'd0;
        else begin
            if (state == IDLE && switch_in != 0)
                count_reg <= switch_in;   // load value
            else if (state == RUN && count_reg > 0)
                count_reg <= count_reg - 1; // decrement
        end
    end

    // Output logic
    always @(*) begin
        if (state == IDLE)
            led_out = 16'd0;
        else
            led_out = count_reg;
    end

endmodule