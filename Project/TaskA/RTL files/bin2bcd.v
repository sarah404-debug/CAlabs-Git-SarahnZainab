`timescale 1ns / 1ps

module bin2bcd(
    input  [15:0] bin,
    output reg [3:0] thousands,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    // Double-dabble algorithm - fully synthesizable
    integer i;
    reg [31:0] scratch;

    always @(*) begin
        scratch = {16'b0, bin};

        for (i = 0; i < 16; i = i + 1) begin
            // Add 3 to any BCD digit >= 5 before shifting
            if (scratch[19:16] >= 5) scratch[19:16] = scratch[19:16] + 3;
            if (scratch[23:20] >= 5) scratch[23:20] = scratch[23:20] + 3;
            if (scratch[27:24] >= 5) scratch[27:24] = scratch[27:24] + 3;
            if (scratch[31:28] >= 5) scratch[31:28] = scratch[31:28] + 3;
            scratch = scratch << 1;
        end

        ones      = scratch[19:16];
        tens      = scratch[23:20];
        hundreds  = scratch[27:24];
        thousands = scratch[31:28];
    end
endmodule