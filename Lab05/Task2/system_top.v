`timescale 1ns / 1ps

module system_top(
    input clk,        // 100 MHz clock (W5)
    input btnC        // center button (reset)
);

    wire rst_clean;
    wire [15:0] switch_value;
    wire [15:0] led_value;

    // Debounce reset button
    debouncer db(
        .clk(clk),
        .pbin(btnC),
        .pbout(rst_clean)
    );

    // Switch interface
    switches sw(
        .clk(clk),
        .rst(rst_clean),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(1'b0),
        .memAddress(30'b0),
        .readData(),
        .leds(switch_value)
    );

    // FSM + Counter
    fsm_controller fsm(
        .clk(clk),
        .rst(rst_clean),
        .switch_in(switch_value),
        .led_out(led_value)
    );

    // LED interface
    leds ledmod(
        .clk(clk),
        .rst(rst_clean),
        .btns(16'b0),
        .writeData(32'b0),
        .writeEnable(1'b0),
        .readEnable(1'b0),
        .memAddress(30'b0),
        .switches(led_value),
        .readData()
    );

endmodule