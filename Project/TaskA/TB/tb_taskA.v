`timescale 1ns / 1ps

module tb_taskA;

    // ==========================================
    // 1. Inputs (Regs) and Outputs (Wires)
    // ==========================================
    reg clk;
    reg reset;
    reg [15:0] switches;

    wire [15:0] leds;
    wire [6:0] seg;
    wire [3:0] an;

    // ==========================================
    // 2. Instantiate Unit Under Test (UUT)
    // ==========================================
    TopLevelProcessor uut (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .leds(leds),
        .seg(seg),
        .an(an)
    );

    // ==========================================
    // 3. Clock Generation (100MHz -> 10ns Period)
    // ==========================================
    always #5 clk = ~clk;

    // ==========================================
    // 4. Stimulus Block
    // ==========================================
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        switches = 16'h0000;

        // Apply Reset for 2 cycles
        #20;
        reset = 0;
        
        // Provide initial switch input (e.g., decimal 5)
        switches = 16'h0005;

        // Run simulation long enough to observe the loop
        // Note: 50,000ns is usually enough to see initial setup instructions
        #50000;

        $display("Simulation Finished.");
        $finish;
    end

    // ==========================================
    // 5. Monitoring Logic (For Task A Verification)
    // ==========================================
    initial begin
        $display("------------------------------------------------------------");
        $display("Time\tPC\t\tInstruction\tLEDs (Hex)\tSwitch");
        $display("------------------------------------------------------------");
        
        // Monitor will print whenever these signals change
        $monitor("%0t\t%h\t%h\t%h\t\t%h", 
            $time, 
            uut.pc, 
            uut.instruction, 
            leds, 
            switches
        );
    end

endmodule