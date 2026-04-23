//`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////////
//// Company: 
//// Engineer: 
//// 
//// Create Date: 04/11/2026 11:05:26 AM
//// Design Name: 
//// Module Name: tb_task1
//// Project Name: 
//// Target Devices: 
//// Tool Versions: 
//// Description: 
//// 
//// Dependencies: 
//// 
//// Revision:
//// Revision 0.01 - File Created
//// Additional Comments:
//// 
////////////////////////////////////////////////////////////////////////////////////

//module tb_task1;

//    reg clk, reset, branch_taken;
//    reg [31:0] instruction;
//    wire [31:0] pc;

//    topTask1 uut (
//        .clk(clk), 
//        .reset(reset), 
//        .branch_taken(branch_taken), 
//        .instruction(instruction), 
//        .pc(pc)
//    );

//    // 100MHz Clock
//    always #5 clk = ~clk;

//    initial begin
//        // Initialize
//        clk = 0; reset = 1; branch_taken = 0; instruction = 32'b0;
        
//        // Reset Pulse
//        #10 reset = 0;

//        // 1. Observe Sequential Increments (0 -> 4 -> 8)
//        #20; 

//        // 2. Setup Branch Instruction
//        // Example: BEQ offset of +16 bytes (instruction[31:0] format)
//        instruction = 32'h01000863; 
//        branch_taken = 1;

//        // Hold for one clock cycle to ensure PC updates
//        #10; 

//        // 3. Return to sequential
//        branch_taken = 0;
        
//        #30;
//        $finish;
//    end

//endmodule



`timescale 1ns / 1ps

module tb_task1;

    reg clk, reset, branch_taken;
    reg [31:0] instruction;
    wire [31:0] pc;

    // Instantiate Unit Under Test
    topTask1 uut (
        .clk(clk), 
        .reset(reset), 
        .branch_taken(branch_taken), 
        .instruction(instruction), 
        .pc(pc)
    );

    // 100MHz Clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // --- STEP 1: Initialization & Reset ---
        clk = 0; 
        reset = 1;         // Start with RESET HIGH to clear PC
        branch_taken = 0; 
        instruction = 32'h00000000;
        
        #15 reset = 0;     // Release Reset after 1.5 clock cycles
        $display("Reset released. PC should now start incrementing.");

        // --- STEP 2: Observe Sequential Movement ---
        // PC should go 0 -> 4 -> 8
        #20; 

        // --- STEP 3: Test Branch Logic ---
        // Setup a BEQ instruction with a +16 (0x10) offset
        instruction = 32'h01000863; 
        branch_taken = 1;  // Simulate Branch condition met

        #10;               // Wait for clock edge
        $display("Branch taken. PC should jump to target.");

        // --- STEP 4: Return to Sequential ---
        branch_taken = 0;
        
        #40;
        $display("Test Complete.");
        $finish;
    end

endmodule