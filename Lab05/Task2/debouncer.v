`timescale 1ns / 1ps

module debouncer(
    input clk,
    input pbin,
    output reg pbout
);

    reg [2:0] shift = 3'b000;

    always @(posedge clk) begin
        shift <= {shift[1:0], pbin};

        if (shift == 3'b111)
            pbout <= 1'b1;
        else if (shift == 3'b000)
            pbout <= 1'b0;
    end

endmodule