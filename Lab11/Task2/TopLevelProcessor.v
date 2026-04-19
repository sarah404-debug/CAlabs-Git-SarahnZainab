//`timescale 1ns / 1ps

//module TopLevelProcessor(
//    input clk,
//    input reset
//);

//    // --- Internal Wires ---
//    wire [31:0] pc, nextPC, pc4, branchAddr;
//    wire [31:0] instruction;
//    wire [31:0] readData1, readData2, writeData, imm;
//    wire [31:0] aluResult, memReadData;
//    wire [3:0]  aluControlSignal;
//    wire        zero;
    
//    // Control Signals
//    wire regWrite, aluSrc, memWrite, memRead, memToReg, branch;

//    // --- 1. Instruction Fetch & PC Logic ---
//    ProgramCounter PC_Unit (
//        .clk(clk), 
//        .reset(reset), 
//        .nextPC(nextPC), 
//        .pc(pc)
//    );

//    pcAdder Add4 (
//        .pc(pc), 
//        .pc4(pc4)
//    );

//    branchAdder AddImm (
//        .pc(pc), 
//        .imm(imm), 
//        .branchAddr(branchAddr)
//    );

//    // Mux for PC Source: Select between PC+4 and Branch Target
//    wire PCSrc = branch & zero;
//    mux2 PCMux (
//        .in0(pc4), 
//        .in1(branchAddr), 
//        .sel(PCSrc), 
//        .out(nextPC)
//    );

//    // --- 2. Instruction Memory ---
//    instructionMemory InstMem (
//        .instAddress(pc), 
//        .instruction(instruction)
//    );

//    // --- 3. Control Unit & Immediate Generator ---
//    control_top CU (
//        .opcode(instruction[6:0]), 
//        .funct3(instruction[14:12]),
//        .funct7(instruction[31:25]),
//        .regWrite(regWrite), 
//        .aluSrc(aluSrc), 
//        .memWrite(memWrite), 
//        .memRead(memRead), 
//        .memToReg(memToReg), 
//        .branch(branch),
//        .aluControlSignal(aluControlSignal)
//    );
    
//    immGen IG (
//        .instr(instruction), 
//        .imm(imm)
//    );

//    // --- 4. Register File ---
//    // FIXED: Matching your RegisterFile.v port names (rs1, rs2, rd, writeEnable)
//    RegisterFile RF (
//        .clk(clk), 
//        .rst(reset), 
//        .writeEnable(regWrite),
//        .rs1(instruction[19:15]), 
//        .rs2(instruction[24:20]), 
//        .rd(instruction[11:7]), 
//        .writeData(writeData),
//        .readData1(readData1), 
//        .readData2(readData2)
//    );

//    // --- 5. ALU & Execution ---
//    wire [31:0] aluInput2;
//    mux2 ALUMux (
//        .in0(readData2), 
//        .in1(imm), 
//        .sel(aluSrc), 
//        .out(aluInput2)
//    );
    
//    ALU MainALU (
//        .A(readData1), 
//        .B(aluInput2), 
//        .ALUControl(aluControlSignal), 
//        .ALUResult(aluResult), 
//        .Zero(zero)
//    );

//    // --- 6. Data Memory System ---
//    // Write-Back Mux: Select between ALU result and Memory data
//    mux2 WriteBackMux (
//        .in0(aluResult), 
//        .in1(memReadData), 
//        .sel(memToReg), 
//        .out(writeData)
//    );

//    dataMemory Data_Mem (
//        .clk(clk),
//        .MemWrite(memWrite),
//        .address(aluResult[8:0]), // Using 9-bit address as per your dataMemory.v
//        .writeData(readData2),
//        .readData(memReadData)
//    );

//endmodule




`timescale 1ns / 1ps

module TopLevelProcessor(
    input clk,
    input reset,
    input [15:0] switches,
    output [15:0] leds
);

    wire [31:0] pc, nextPC, pc4, branchAddr;
    wire [31:0] instruction;
    wire [31:0] readData1, readData2, writeData, imm;
    wire [31:0] aluResult, memReadData;
    wire [3:0]  aluControlSignal;
    wire        zero;
    
    wire regWrite, aluSrc, memWrite, memRead, memToReg, branch;

    ProgramCounter PC_Unit (.clk(clk), .reset(reset), .nextPC(nextPC), .pc(pc));
    pcAdder Add4 (.pc(pc), .pc4(pc4));
    branchAdder AddImm (.pc(pc), .imm(imm), .branchAddr(branchAddr));

    wire PCSrc = branch & zero;
    mux2 PCMux (.in0(pc4), .in1(branchAddr), .sel(PCSrc), .out(nextPC));

    instructionMemory InstMem (.instAddress(pc), .instruction(instruction));

    control_top CU (
        .opcode(instruction[6:0]), 
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .regWrite(regWrite), .memRead(memRead), .memWrite(memWrite), 
        .aluSrc(aluSrc), .memToReg(memToReg), .branch(branch),
        .aluControl(aluControlSignal) 
    );
    
    immGen IG (.instr(instruction), .imm(imm));

    RegisterFile RF (
        .clk(clk), .rst(reset), .writeEnable(regWrite),
        .rs1(instruction[19:15]), .rs2(instruction[24:20]), .rd(instruction[11:7]), 
        .writeData(writeData), .readData1(readData1), .readData2(readData2)
    );

    wire [31:0] aluInput2;
    mux2 ALUMux (.in0(readData2), .in1(imm), .sel(aluSrc), .out(aluInput2));
    
    ALU MainALU (
        .A(readData1), 
        .B(aluInput2), 
        .ALUControl(aluControlSignal), 
        .ALUResult(aluResult), 
        .Zero(zero)
    );

    mux2 WriteBackMux (.in0(aluResult), .in1(memReadData), .sel(memToReg), .out(writeData));

    wire [31:0] internal_read_data;
    
    addressDecoderTop IO_System (
        .clk(clk),
        .rst(reset),
        .address(aluResult),
        .readEnable(memRead),
        .writeEnable(memWrite),
        .writeData(readData2),
        .switches(switches),
        .readData(internal_read_data), // Connects to the wire, not directly to memReadData
        .leds(leds)
    );

    // If the ALU asks for the switches (0x200), force the testbench value in. 
    // Otherwise, let the IO_System handle it natively.
    assign memReadData = (aluResult == 32'h00000200) ? {16'b0, switches} : internal_read_data;

endmodule