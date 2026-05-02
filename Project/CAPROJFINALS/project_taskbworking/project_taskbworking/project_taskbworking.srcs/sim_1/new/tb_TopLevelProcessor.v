`timescale 1ns / 1ps

module tb_TopLevelProcessor();

    // Inputs
    reg clk;
    reg reset;
    reg [15:0] switches;

    // Outputs
    wire [15:0] leds;
    wire [6:0] seg;
    wire [3:0] an;

    // Instantiate the Top Level Processor
    TopLevelProcessor uut (
        .clk(clk),
        .reset(reset),
        .switches(switches),
        .leds(leds),
        .seg(seg),
        .an(an)
    );

    // Clock Generation (100MHz)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        switches = 16'b0;

        // Reset the system
        #20 reset = 0;
        
        $display("Starting Simulation...");
        $display("Time | PC       | Instr    | x1 | x2 | x3 (SLT) | x5 (LUI)");
        $display("----------------------------------------------------------");

        // Monitor internal register values for verification
        // Note: Using hierarchical paths to peek into the Register File
        forever begin
            @(posedge clk);
            #1; // Wait for logic to settle
            $display("%4t | %h | %h | %d  | %d  | %d        | %h", 
                     $time, uut.pc, uut.instruction, 
                     uut.RF.regs[1], uut.RF.regs[2], uut.RF.regs[3], uut.RF.regs[5]);
            
            // Stop after the program finishes or loops
            if (uut.pc >= 32'd20) begin
                #50;
                $display("----------------------------------------------------------");
                $display("Simulation finished. Check results above.");
                $stop;
            end
        end
    end

endmodule