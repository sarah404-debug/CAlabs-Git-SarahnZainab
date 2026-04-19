`timescale 1ns / 1ps

module riscv_processor(
    input clk,
    input rst,
    input [15:0] sw_phys,     // Physical switches (Basys3)
    output [15:0] led_phys,   // Physical LEDs (Basys3)
    output [6:0] seg,         // 7-segment display segments
    output [3:0] an           // 7-segment digit select
);

    // --- Internal Wires ---
    wire [31:0] pc, nextPC, pc4, branchAddr;
    wire [31:0] instruction;
    wire [31:0] readData1, readData2, writeData, imm, aluResult, memReadData;
    wire [3:0]  aluCtrl;
    wire [1:0]  aluOp;
    wire        zero, pcSrc;
    
    // Control Signals from your MainControl.v
    wire regWrite, memRead, memWrite, aluSrc, memToReg, branch;

    // --- 1. Instruction Fetch (From Lab 11 Task 1) ---
    ProgramCounter PC_Reg (
        .clk(clk), 
        .rst(rst), 
        .nextPC(nextPC), 
        .pc(pc)
    );

    pcAdder Add4 (
        .a(pc), 
        .b(pc4)
    );

    branchAdder AddImm (
        .pc(pc), 
        .imm(imm), 
        .branchAddr(branchAddr)
    );

    // Mux for PC Source: Selects pc+4 or branch address
    assign pcSrc = branch & zero;
    mux2 PCMux (
        .a(pc4), 
        .b(branchAddr), 
        .sel(pcSrc), 
        .y(nextPC)
    );

    // --- 2. Instruction Memory (From Lab 10) ---
    instructionMemory IMEM (
        .instAddress(pc), 
        .instruction(instruction)
    );

    // --- 3. Control Unit (From Lab 9/10) ---
    MainControl CU (
        .opcode(instruction[6:0]),
        .regWrite(regWrite), 
        .memRead(memRead), 
        .memWrite(memWrite),
        .aluSrc(aluSrc), 
        .memToReg(memToReg), 
        .branch(branch), 
        .aluOp(aluOp)
    );

    ALUControl ACU (
        .aluOp(aluOp),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .aluControlSignal(aluCtrl)
    );

    // --- 4. Register File & Imm Gen ---
    RegisterFile RF (
        .clk(clk), 
        .rst(rst), 
        .writeEnable(regWrite),
        .rs1(instruction[19:15]), 
        .rs2(instruction[24:20]), 
        .rd(instruction[11:7]),
        .writeData(writeData),
        .readData1(readData1), 
        .readData2(readData2)
    );
    
    // Ensure you have an immGen module to handle J, I, B, and S types
    immGen IG (
        .instr(instruction), 
        .imm(imm)
    );

    // --- 5. ALU & Execution (From Lab 6/7) ---
    wire [31:0] aluIn2 = aluSrc ? imm : readData2;
    
    ALU Execution_Unit (
        .A(readData1),
        .B(aluIn2),
        .ALUControl(aluCtrl),
        .ALUResult(aluResult),
        .Zero(zero)
    );

    // --- 6. Memory & I/O System (From Lab 8) ---
    addressDecoderTop IO_System (
        .clk(clk), 
        .rst(rst),
        .address(aluResult),
        .readEnable(memRead),
        .writeEnable(memWrite),
        .writeData(readData2),
        .switches(sw_phys),
        .readData(memReadData),
        .leds(led_phys)
    );

    // Final Mux: Write-back to Register File
    assign writeData = memToReg ? memReadData : aluResult;

    // --- 7. Debug Display (7-Segment) ---
    sevenseg_basys3 Display (
        .clk(clk),
        .value(aluResult[15:0]), // Displaying ALU Result for debugging
        .seg(seg),
        .an(an)
    );

endmodule