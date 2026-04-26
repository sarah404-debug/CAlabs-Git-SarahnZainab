//`timescale 1ns / 1ps

//module tb_task2;

//    reg clk;
//    reg reset;
//    reg [15:0] switches;
//    wire [15:0] leds;

//    // Instantiate UUT
//    TopLevelProcessor uut (
//        .clk(clk),
//        .reset(reset),
//        .switches(switches),
//        .leds(leds)
//    );

//    // Clock generation (10ns period)
//    always #5 clk = ~clk;

//    initial begin
//        clk = 0;
//        reset = 1;
//        #10;
//        switches = 16'h0005;
//        reset = 0;
//        #10;


////        $display("------------------------------------------------------------");
//        #200;
//        $finish;
//    end

//`timescale 1ns / 1ps

//module tb_task2;

//    reg clk;
//    reg reset;
//    reg [15:0] switches;
//    wire [15:0] leds;

//    // Instantiate Unit Under Test (UUT)
//    TopLevelProcessor uut (
//        .clk(clk),
//        .reset(reset),
//        .switches(switches),
//        .leds(leds)
//    );

//    // Clock generation (10ns period)
//    always #5 clk = ~clk;

//    initial begin
//        clk = 0;
//        reset = 1;
//        switches = 16'h0000;

//        // Apply reset
//        #10;
//        reset = 0;

//        // Header for output
//        $display("------------------------------------------------------------");
//        $display("Time\tPC\t\tx1\tx2\tx3\tx4\tx5");
//        $display("------------------------------------------------------------");

//        // Run simulation and print values
//        repeat (20) begin
//            #10;
//            $display("%0t\t%h\t%d\t%d\t%d\t%d\t%d",
//                $time,
//                uut.pc,
//                uut.RF.regs[1],  // x1
//                uut.RF.regs[2],  // x2
//                uut.RF.regs[3],  // x3
//                uut.RF.regs[4],  // x4
//                uut.RF.regs[5]   // x5
//            );
//        end

//        $display("------------------------------------------------------------");
//        $finish;
//    end

//endmodule

`timescale 1ns / 1ps

module tb_task2;

    reg clk;
    reg reset;
    reg [15:0] switches;

    wire [15:0] leds;
    wire [6:0] seg;
    wire [3:0] an;

    // DUT
    TopLevelProcessor uut (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .leds(leds),
        .seg(seg),
        .an(an)
    );

    // Clock (100MHz ? 10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        // Start value = 5
        switches = 16'h0005;

        // Release reset
        #20;
        reset = 0;

        // ? Run LONG enough to see behavior
        #50000;

        $finish;
    end

    // Monitor important signals
    initial begin
        $display("Time\tPC\t\tInstr\t\tLEDs\tSwitch");

        $monitor("%0t\t%h\t%h\t%h\t%h",
            $time,
            uut.pc,
            uut.instruction,
            leds,
            switches
        );
    end

endmodule

