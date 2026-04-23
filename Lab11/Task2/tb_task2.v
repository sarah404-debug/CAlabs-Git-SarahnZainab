//`timescale 1ns / 1ps

//module tb_task2;
//    reg clk;
//    reg reset;
//    reg [15:0] switches;
//    wire [15:0] leds;

//    // Instantiate Unit Under Test
//    TopLevelProcessor uut (
//        .clk(clk),
//        .reset(reset),
//        .switches(switches),
//        .leds(leds)
//    );

//    always #5 clk = ~clk;

//    initial begin
//        clk = 0;
//        reset = 1;
//        switches = 16'h0005; // Flip the switch to '5' so the countdown starts!
        
//        #15 reset = 0;

//        // Run long enough to see the whole countdown loop happen
//        #2000;
//        $finish;
//    end
//always

`timescale 1ns / 1ps

module tb_task2;

    reg clk;
    reg reset;
    reg [15:0] switches;
    wire [15:0] leds;

    // Instantiate UUT
    TopLevelProcessor uut (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .leds(leds)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #10;
        switches = 16'h0005;
        reset = 0;
        #10;

//        // ? Proper reset (aligned with clock)
//        repeat (2) @(posedge clk);  // hold reset for 2 full cycles
//        reset = 0;

//        // ? wait 1 cycle after reset
//        @(posedge clk);

//        $display("------------------------------------------------------------");
//        $display("Time\tPC\tInstr\t\tALU\tZero\tRegWrite\tx2\tx3\tx4");
//        $display("------------------------------------------------------------");

//        // Run and monitor
//        repeat (30) begin
//            @(posedge clk);
//            $display("%0t\t%h\t%h\t%h\t%b\t%b\t%h\t%h\t%h",
//                $time,
//                uut.pc,
//                uut.instruction,
//                uut.aluResult,
//                uut.zero,
//                uut.regWrite,
//                uut.RF.regs[2],   // x2
//                uut.RF.regs[3],   // x3
//                uut.RF.regs[4]    // x4
//            );
//        end

//        $display("------------------------------------------------------------");
        #200;
        $finish;
    end

endmodule