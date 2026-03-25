`timescale 1ns/1ps
module MemorySystem_tb;

// Inputs
reg         clk;
reg         rst;
reg  [31:0] address;
reg         readEnable;
reg         writeEnable;
reg  [31:0] writeData;
reg  [15:0] switches;

// Outputs
wire [31:0] readData;
wire [15:0] leds;

// DUT
addressDecoderTop dut(
    .clk        (clk),
    .rst        (rst),
    .address    (address),
    .readEnable (readEnable),
    .writeEnable(writeEnable),
    .writeData  (writeData),
    .switches   (switches),
    .readData   (readData),
    .leds       (leds)
);

// Clock: 10ns period
initial clk = 0;
always #5 clk = ~clk;

// Address map (bits[9:8]):
//   00 -> DataMem   (0   - 255)
//   01 -> LEDs      (256 - 511)
//   10 -> Switches  (512 - 767)
//   11 -> UNUSED    (768 - 1023)

// Write task - sets address and data on negedge, write happens on next posedge
task do_write;
    input [31:0] addr;
    input [31:0] data;
    begin
        @(negedge clk);
        address     = addr;
        writeData   = data;
        writeEnable = 1;
        readEnable  = 0;
        @(posedge clk); #1;
        writeEnable = 0;
    end
endtask

// Read task for DataMemory (combinational read - valid immediately after address set)
task do_read;
    input [31:0] addr;
    begin
        @(negedge clk);
        address     = addr;
        readEnable  = 1;
        writeEnable = 0;
        #1;
    end
endtask

// Read task for Switches (registered read - must wait one posedge for readData to update)
task do_read_reg;
    input [31:0] addr;
    begin
        @(negedge clk);
        address     = addr;
        readEnable  = 1;
        writeEnable = 0;
        @(posedge clk); #1;  // extra clock cycle for registered output to settle
    end
endtask

integer errors;

initial begin
    errors      = 0;
    rst         = 1;
    readEnable  = 0;
    writeEnable = 0;
    address     = 0;
    writeData   = 0;
    switches    = 16'h0000;
    repeat(4) @(posedge clk);
    rst = 0;
    @(posedge clk);

    $display("===== Lab 8: MemorySystem Testbench =====");
    $display("Address map: DataMem=0-255 | LEDs=256-511 | Switches=512-767");

    // ----------------------------------------
    // TEST 1: Write and Read Data Memory
    // addresses 0-255 -> bits[9:8]=00 -> DataMem
    // dataMemory has combinational read, valid immediately after address set
    // ----------------------------------------
    $display("\n-- TEST 1: Data Memory Write/Read --");

    do_write(32'd10,  32'hDEADBEEF);  // addr 10  -> bits[9:8]=00 -> DataMem
    do_write(32'd0,   32'hAAAAAAAA);  // addr 0   -> bits[9:8]=00 -> DataMem
    do_write(32'd200, 32'h12345678);  // addr 200 -> bits[9:8]=00 -> DataMem

    do_read(32'd10);
    if (readData === 32'hDEADBEEF)
        $display("PASS: mem[10]  = 0x%08X", readData);
    else begin
        $display("FAIL: mem[10]  expected 0xDEADBEEF, got 0x%08X", readData);
        errors = errors + 1;
    end

    do_read(32'd0);
    if (readData === 32'hAAAAAAAA)
        $display("PASS: mem[0]   = 0x%08X", readData);
    else begin
        $display("FAIL: mem[0]   expected 0xAAAAAAAA, got 0x%08X", readData);
        errors = errors + 1;
    end

    do_read(32'd200);
    if (readData === 32'h12345678)
        $display("PASS: mem[200] = 0x%08X", readData);
    else begin
        $display("FAIL: mem[200] expected 0x12345678, got 0x%08X", readData);
        errors = errors + 1;
    end

    // ----------------------------------------
    // TEST 2: Write to LEDs
    // addresses 256-511 -> bits[9:8]=01 -> LEDs
    // leds latches writeData[15:0] on posedge clk when writeEnable=1
    // ----------------------------------------
    $display("\n-- TEST 2: LED Write --");

    do_write(32'd256, 32'h0000F0F0);  // addr 256 -> bits[9:8]=01 -> LEDs
    @(posedge clk); #1;
    if (leds === 16'hF0F0)
        $display("PASS: leds = 0x%04X", leds);
    else begin
        $display("FAIL: leds expected 0xF0F0, got 0x%04X", leds);
        errors = errors + 1;
    end

    do_write(32'd300, 32'h0000FFFF);  // addr 300 -> bits[9:8]=01 -> LEDs
    @(posedge clk); #1;
    if (leds === 16'hFFFF)
        $display("PASS: leds = 0x%04X", leds);
    else begin
        $display("FAIL: leds expected 0xFFFF, got 0x%04X", leds);
        errors = errors + 1;
    end

    // ----------------------------------------
    // TEST 3: Read from Switches
    // addresses 512-767 -> bits[9:8]=10 -> Switches
    // switches has registered read - use do_read_reg to wait one posedge
    // ----------------------------------------
    $display("\n-- TEST 3: Switch Read --");

    switches = 16'hABCD;
    do_read_reg(32'd512);             // addr 512 -> bits[9:8]=10 -> Switches
    if (readData === 32'h0000ABCD)
        $display("PASS: switches = 0x%08X", readData);
    else begin
        $display("FAIL: switches expected 0x0000ABCD, got 0x%08X", readData);
        errors = errors + 1;
    end

    switches = 16'h1234;
    do_read_reg(32'd600);             // addr 600 -> bits[9:8]=10 -> Switches
    if (readData === 32'h00001234)
        $display("PASS: switches = 0x%08X", readData);
    else begin
        $display("FAIL: switches expected 0x00001234, got 0x%08X", readData);
        errors = errors + 1;
    end

    // ----------------------------------------
    // TEST 4: Address Decoder Isolation
    // verify only one device is enabled at a time
    // ----------------------------------------
    $display("\n-- TEST 4: Address Decoder Isolation --");

    // Write to DataMem then LEDs - DataMem must NOT be corrupted by LED write
    do_write(32'd10,  32'hCAFEBABE);  // DataMem addr 10
    do_write(32'd256, 32'h0000DEAD);  // LED addr 256
    do_read(32'd10);
    if (readData === 32'hCAFEBABE)
        $display("PASS: DataMem NOT corrupted by LED write");
    else begin
        $display("FAIL: DataMem corrupted! got 0x%08X", readData);
        errors = errors + 1;
    end

    // Write to DataMem - LEDs must NOT change
    do_write(32'd10, 32'h11111111);   // DataMem write only
    @(posedge clk); #1;
    if (leds === 16'hDEAD)
        $display("PASS: LEDs NOT affected by DataMem write");
    else begin
        $display("FAIL: LEDs changed! got 0x%04X", leds);
        errors = errors + 1;
    end

    // Result
    $display("\n=========================================");
    if (errors == 0)
        $display("ALL TESTS PASSED");
    else
        $display("%0d TEST(S) FAILED", errors);
    $display("=========================================\n");

    $finish;
end

endmodule