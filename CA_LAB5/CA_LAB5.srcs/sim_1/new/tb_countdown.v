`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2026 11:25:55 AM
// Design Name: 
// Module Name: tb_countdown
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

module tb_countdown;

    // testbench signals
    reg clk;
    reg rst;
    reg [15:0] switch_in;
    wire [15:0] led_out;

    // instantiate the FSM
    countdown_fsm uut (
        .clk(clk),
        .rst(rst),
        .switch_in(switch_in),
        .led_out(led_out)
    );

    // clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // initialize
        clk = 0;
        rst = 1;
        switch_in = 0;

        // hold reset for a few cycles
        #20;
        rst = 0;

        // -------------------------
        // TEST 1: Load value 5
        // -------------------------
        #10;
        switch_in = 5;     // apply switch input
        #10;
        switch_in = 0;     // release switch

        // wait long enough to see full countdown
        #100;

        // -------------------------
        // TEST 2: Load value 3
        // -------------------------
        #10;
        switch_in = 3;
        #10;
        switch_in = 0;

        #60;

        // -------------------------
        // TEST 3: Reset during counting
        // -------------------------
        #10;
        switch_in = 6;
        #10;
        switch_in = 0;

        #20;               // let it count a little
        rst = 1;           // apply reset
        #10;
        rst = 0;

        #50;

        $stop;             // stop simulation
    end

endmodule
