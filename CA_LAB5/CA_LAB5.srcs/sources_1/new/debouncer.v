`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 11:24:45 AM
// Design Name: 
// Module Name: debouncer
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

module debouncer(
    input clk,
    input pbin,
    output reg pbout
);

    reg [2:0] history;

    always @(posedge clk) begin
        history <= {history[1:0], pbin};

        // output changes only when input stable for 3 cycles
        if (&history)          // all 1s
            pbout <= 1'b1;
        else if (~|history)    // all 0s
            pbout <= 1'b0;
    end

endmodule
