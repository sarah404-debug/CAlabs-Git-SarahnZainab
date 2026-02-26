`timescale 1ns / 1ps

module seven_segment_driver (
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] value,
    output reg  [3:0]  an,
    output reg  [6:0]  seg,
    output wire        dp
);

    // refresh counter for multiplexing
    reg [17:0] scan_counter;

    always @(posedge clk or posedge rst) begin
        if (rst)
            scan_counter <= 18'd0;
        else
            scan_counter <= scan_counter + 1'b1;
    end

    // select active digit
    wire [1:0] digit_sel = scan_counter[17:16];

    reg [3:0] current_nibble;

    // ==============================
    // Digit selection & nibble pick
    // ==============================
    always @(*) begin
        // default values
        an = 4'b1111;
        current_nibble = 4'h0;

        case (digit_sel)
            2'd0: begin
                an = 4'b1110;
                current_nibble = value[3:0];
            end
            2'd1: begin
                an = 4'b1101;
                current_nibble = value[7:4];
            end
            2'd2: begin
                an = 4'b1011;
                current_nibble = value[11:8];
            end
            2'd3: begin
                an = 4'b0111;
                current_nibble = value[15:12];
            end
        endcase
    end

    // ==============================
    // Hex to 7-segment decoder
    // ==============================
    always @(*) begin
        case (current_nibble)
            4'h0: seg = 7'b0000001;
            4'h1: seg = 7'b1001111;
            4'h2: seg = 7'b0010010;
            4'h3: seg = 7'b0000110;
            4'h4: seg = 7'b1001100;
            4'h5: seg = 7'b0100100;
            4'h6: seg = 7'b0100000;
            4'h7: seg = 7'b0001111;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0000100;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b1100000;
            4'hC: seg = 7'b0110001;
            4'hD: seg = 7'b1000010;
            4'hE: seg = 7'b0110000;
            4'hF: seg = 7'b0111000;
            default: seg = 7'b1111111;
        endcase
    end

    // decimal point always disabled
    assign dp = 1'b1;

endmodule