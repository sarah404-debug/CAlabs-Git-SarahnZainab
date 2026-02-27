`timescale 1ns/1ps
module fsm_counter #(parameter ONE_SEC = 100_000_000) (
    input clk, rst,
    input [15:0] sw_val,
    output reg [15:0] count_reg
);
    localparam WAIT = 1'b0, COUNT = 1'b1;
    reg state;
    reg [26:0] sec_counter;
    wire one_sec = (sec_counter == ONE_SEC - 1);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= WAIT;
            count_reg   <= 0;
            sec_counter <= 0;
        end else case (state)
            WAIT: if (sw_val != 0) begin
                count_reg   <= sw_val;
                sec_counter <= 0;
                state       <= COUNT;
            end
            COUNT: if (one_sec) begin
                sec_counter <= 0;
                if (count_reg > 0) count_reg <= count_reg - 1;
                else state <= WAIT;
            end else
                sec_counter <= sec_counter + 1;
        endcase
    end
endmodule



















