`timescale 1ns/1ps

module lab5_top #(
    parameter DEBOUNCE_THRESH = 17'd100_000,
    parameter ONE_SEC         = 100_000_000
)(
    input        clk,
    input        rst_btn,
    input  [15:0] sw_phys,
    output [15:0] led_phys,
    output [6:0]  seg,
    output [3:0]  an
);
    wire        clean_rst;
    wire [15:0] sw_to_fsm;
    wire [15:0] fsm_to_led;

    // 1. Debouncer - threshold overridable for simulation
    debouncer #(.THRESHOLD(DEBOUNCE_THRESH)) db (
        .clk   (clk),
        .pbin  (rst_btn),
        .pbout (clean_rst)
    );

    // 2. Switch Interface
    switches sw_inst (
        .clk        (clk),
        .rst        (clean_rst),
        .writeData  ({16'b0, sw_phys}),
        .writeEnable(1'b1),          // FIXED: was 1'b0
        .readEnable (1'b0),
        .memAddress (30'b0),
        .leds       (sw_to_fsm),
        .readData   ()
    );

    // 3. FSM Counter - ONE_SEC overridable for simulation
    fsm_counter #(.ONE_SEC(ONE_SEC)) fsm (
        .clk      (clk),
        .rst      (clean_rst),
        .sw_val   (sw_to_fsm),
        .count_reg(fsm_to_led)
    );

    // 4. LED Interface
    leds led_inst (
        .clk        (clk),
        .rst        (clean_rst),
        .switches   (fsm_to_led),
        .btns       (16'b0),
        .writeData  (32'b0),
        .writeEnable(1'b0),
        .readEnable (1'b0),
        .memAddress (30'b0),
        .readData   ()
    );

    // 5. Seven Segment Display
    sevenseg_basys3 display (
        .clk  (clk),
        .value(fsm_to_led),
        .seg  (seg),
        .an   (an)
    );

    // 6. Drive physical LEDs
    assign led_phys = fsm_to_led;

endmodule