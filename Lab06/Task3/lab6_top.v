`timescale 1ns/1ps
module lab6_top #(
    parameter DEBOUNCE_THRESH = 17'd100_000
)(
    input        clk,
    input        rst_btn,       // btnC on Basys3
    input  [15:0] sw_phys,      // sw[3:0] used for ALUControl
    output [15:0] led_phys,     // shows ALUResult[15:0]
    output [6:0]  seg,
    output [3:0]  an
);

    wire [31:0] A = 32'h10101010;  // 269488144 in decimal
    wire [31:0] B = 32'h01010101;  // 16843009 in decimal
    
    wire        clean_rst;
    wire [15:0] sw_to_fsm;
    wire [15:0] fsm_out;        // reused from Lab5 FSM 
    wire [3:0]  ALUControl;
    wire [31:0] ALUResult;
    wire        Zero;

    debouncer #(.THRESHOLD(DEBOUNCE_THRESH)) db (
        .clk   (clk),
        .pbin  (rst_btn),
        .pbout (clean_rst)
    );

    switches sw_inst (
        .clk        (clk),
        .rst        (clean_rst),
        .writeData  ({16'b0, sw_phys}),
        .writeEnable(1'b1),
        .readEnable (1'b0),
        .memAddress (30'b0),
        .leds       (sw_to_fsm),
        .readData   ()
    );

    assign ALUControl = sw_to_fsm[3:0];

    ALU alu_inst (
        .A          (A),
        .B          (B),
        .ALUControl (ALUControl),
        .ALUResult  (ALUResult),
        .Zero       (Zero)
    );

    fsm_counter #(.ONE_SEC(100_000_000)) fsm (
        .clk      (clk),
        .rst      (clean_rst),
        .sw_val   (ALUResult[15:0]),
        .count_reg(fsm_out)
    );

    leds led_inst (
        .clk        (clk),
        .rst        (clean_rst),
        .switches   (ALUResult[15:0]),
        .btns       (16'b0),
        .writeData  (32'b0),
        .writeEnable(1'b0),
        .readEnable (1'b0),
        .memAddress (30'b0),
        .readData   ()
    );


    sevenseg_basys3 display (
        .clk  (clk),
        .value(ALUResult[15:0]),
        .seg  (seg),
        .an   (an)
    );

    assign led_phys[14:0] = ALUResult[14:0];
    assign led_phys[15]   = Zero;

endmodule