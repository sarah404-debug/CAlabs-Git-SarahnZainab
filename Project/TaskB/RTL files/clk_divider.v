`timescale 1ns / 1ps

module clk_divider(
    input clk,
    output reg slow_clk
);

    reg [25:0] counter = 0;

    always @(posedge clk) begin
        counter <= counter + 1;
        slow_clk <= counter[25];
    end

endmodule