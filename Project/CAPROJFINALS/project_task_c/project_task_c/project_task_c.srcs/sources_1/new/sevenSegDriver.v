`timescale 1ns / 1ps

module sevenSegDriver(
    input         clk,
    input  [15:0] data,
    output reg [6:0] seg,
    output reg [3:0] an
);

    // ===== Clock divider for multiplexing =====
    // Divide 100MHz down to ~1kHz for flicker-free display
    reg [16:0] clkDiv;
    reg [1:0]  digit_sel;

    always @(posedge clk) begin
        clkDiv <= clkDiv + 1;
        if (clkDiv == 17'd99999) begin
            clkDiv    <= 0;
            digit_sel <= digit_sel + 1;
        end
    end

    // ===== BCD conversion =====
    wire [3:0] thousands, hundreds, tens, ones;

    bin2bcd BCD_CONV (
        .bin(data),
        .thousands(thousands),
        .hundreds(hundreds),
        .tens(tens),
        .ones(ones)
    );

    // ===== Digit selection =====
    reg [3:0] current_digit;

    always @(*) begin
        case (digit_sel)
            2'b00: begin an = 4'b1110; current_digit = ones;      end // rightmost
            2'b01: begin an = 4'b1101; current_digit = tens;      end
            2'b10: begin an = 4'b1011; current_digit = hundreds;  end
            2'b11: begin an = 4'b0111; current_digit = thousands; end // leftmost
            default: begin an = 4'b1111; current_digit = 4'd0;   end
        endcase
    end

    // ===== 7-segment decode (active LOW, decimal only) =====
    //        segments: gfedcba
    always @(*) begin
        case (current_digit)
            4'd0: seg = 7'b1000000; // 0
            4'd1: seg = 7'b1111001; // 1
            4'd2: seg = 7'b0100100; // 2
            4'd3: seg = 7'b0110000; // 3
            4'd4: seg = 7'b0011001; // 4
            4'd5: seg = 7'b0010010; // 5
            4'd6: seg = 7'b0000010; // 6
            4'd7: seg = 7'b1111000; // 7
            4'd8: seg = 7'b0000000; // 8
            4'd9: seg = 7'b0010000; // 9
            default: seg = 7'b1111111; // blank
        endcase
    end

endmodule