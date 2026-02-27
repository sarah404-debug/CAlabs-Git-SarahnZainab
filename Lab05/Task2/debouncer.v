`timescale 1ns/1ps
module debouncer #(parameter THRESHOLD = 17'd100_000)(
    input clk,
    input pbin,
    output reg pbout = 0
);
    reg [16:0] count = 0;  // ADD = 0 HERE
    always @(posedge clk) begin
        if (pbin == pbout) count <= 0;
        else begin
            count <= count + 1;
            if (count == THRESHOLD) pbout <= pbin;
        end
    end
endmodule










