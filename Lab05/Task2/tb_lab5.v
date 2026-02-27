//`timescale 1ns/1ps
//module tb_lab5;
//    reg clk;
//    reg rst_btn;
//    reg [15:0] sw_phys;
//    wire [15:0] led_phys;

//    lab5_top #(
//        .DEBOUNCE_THRESH(17'd1),
//        .ONE_SEC(10)
//    ) uut (
//        .clk     (clk),
//        .rst_btn (rst_btn),
//        .sw_phys (sw_phys),
//        .led_phys(led_phys)
//    );

//    always #5 clk = ~clk;

//    // Safety timeout to prevent Vivado crash
//    initial #10000 $finish;

//    initial begin
//        clk     = 0;
//        rst_btn = 1;
//        sw_phys = 0;        // switches OFF during reset
//        #30 rst_btn = 0;    // release reset
//        #20;                // let FSM settle into WAIT

//        // Load 10
//        sw_phys = 16'd10;
//        #1200;              // 10 x 100ns = 1000ns + margin

//        // Back to 0 briefly so FSM returns to WAIT
//        sw_phys = 16'd0;
//        #50;

//        // Load 5
//        sw_phys = 16'd5;
//        #700;               // 5 x 100ns = 500ns + margin

//        // Back to 0
//        sw_phys = 16'd0;
//        #50;

//        // Test reset mid-count
//        sw_phys = 16'd3;
//        #150;               // let it count a bit
//        rst_btn = 1;        // reset mid-count
//        sw_phys = 16'd0;
//        #30 rst_btn = 0;
//        #20;                // settle

//        // Load 3 after reset
//        sw_phys = 16'd3;
//        #500;               // 3 x 100ns = 300ns + margin

//        $finish;
//    end
//endmodule
`timescale 1ns/1ps
module tb_lab5;
    reg clk;
    reg rst_btn;
    reg [15:0] sw_phys;
    wire [15:0] led_phys;

    lab5_top #(
        .DEBOUNCE_THRESH(17'd1),
        .ONE_SEC(10)
    ) uut (
        .clk     (clk),
        .rst_btn (rst_btn),
        .sw_phys (sw_phys),
        .led_phys(led_phys)
    );

    always #5 clk = ~clk;

    initial #25000 $finish;

    initial begin
        clk     = 0;
        rst_btn = 1;
        sw_phys = 0;
        #30 rst_btn = 0;    // initial reset done by t=30ns
        #20;

        // === BEFORE RESET: load 5, let it repeat 3 times ===
        sw_phys = 16'd5;
        #700;               // 5,4,3,2,1,0
        sw_phys = 16'd0; #50;
        sw_phys = 16'd5;
        #700;               // 5,4,3,2,1,0
        sw_phys = 16'd0; #50;
        sw_phys = 16'd5;
        #700;               // 5,4,3,2,1,0
        sw_phys = 16'd0; #50;

        // === RESET IN THE MIDDLE (around t=2300ns) ===
        rst_btn = 1;
        sw_phys = 16'd0;
        #100;               // hold high long enough to be visible
        rst_btn = 0;
        #30;

        // === AFTER RESET: load 10 then 3 ===
        sw_phys = 16'd10;
        #1200;              // 10,9,8,7,6,5,4,3,2,1,0
        sw_phys = 16'd0; #50;

        sw_phys = 16'd3;
        #500;               // 3,2,1,0
        sw_phys = 16'd0; #50;

        sw_phys = 16'd3;
        #500;               // 3,2,1,0 again
        sw_phys = 16'd0;

        $finish;
    end
endmodule
