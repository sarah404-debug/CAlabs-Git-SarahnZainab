`timescale 1ns / 1ps

module tb_TopLevel();

    // Inputs to the Processor
    reg clk;
    reg reset;
    reg [15:0] switches;

    // Outputs from the Processor
    wire [15:0] leds;
    wire [6:0] seg;
    wire [3:0] an;

    // 1. Instantiate your TopLevelProcessor exactly as it was
    TopLevelProcessor uut (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .leds(leds),
        .seg(seg),
        .an(an)
    );

    // 2. Generate the 100MHz Master Clock
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period = 100MHz

    // 3. Simulation Sequence
    initial begin
        // Start with Reset Active [cite: 101, 105, 143]
        reset = 1;
        switches = 16'h0000;
        
        // Hold reset for 100ns to clear PC and Registers [cite: 187, 196]
        #100;
        reset = 0;
        
        // Let the program (prog.mem) run for a while [cite: 71, 99]
        #5000;
        
        // Example: Test your Switch mapping (Task C requirement) [cite: 15, 142-144]
        switches = 16'h0042; 
        
        #5000;
        
        $display("Simulation complete. Check the Tcl Console for execution flow.");
        $stop;
    end

    // 4. THE MONITOR: This is the most important part for your Viva.
    // It prints internal signals so you can prove the code is working.
    initial begin
        $display("Time | PC | Instruction | ALU Result | WriteData | LEDs");
        $monitor("%0t | %h | %h | %h | %h | %h", 
                 $time, uut.pc, uut.instruction, uut.aluResult, uut.writeData, leds);
    end

endmodule