//`timescale 1ns/1ps

//module memorySystemFPGA(

//    input clk,
//    input rst,
//    input [15:0] switches,

//    output [15:0] leds

//);

//reg [31:0] address;
//reg readEnable;
//reg writeEnable;
//reg [31:0] writeData;

//wire [31:0] readData;

///* Clock Divider */
//reg [25:0] counter = 0;

//always @(posedge clk)
//    counter <= counter + 1;

//wire slowClk = counter[25];


///* Use the system from Task 2 */

//addressDecoderTop system(

//    .clk(clk),
//    .rst(rst),

//    .address(address),
//    .readEnable(readEnable),
//    .writeEnable(writeEnable),

//    .writeData(writeData),
//    .switches(switches),

//    .readData(readData),
//    .leds(leds)

//);


///* FSM states */

//parameter IDLE = 0;
//parameter READ_SWITCHES = 1;
//parameter WRITE_DATAMEM = 2;
//parameter READ_DATAMEM = 3;
//parameter WRITE_LED = 4;

//reg [2:0] state;


///* FSM (runs on slow clock now) */

//always @(posedge slowClk)
//begin

//    if(rst)
//    begin
//        state <= IDLE;
//        readEnable <= 0;
//        writeEnable <= 0;
//    end

//    else
//    begin

//        case(state)

//        IDLE:
//        begin
//            state <= READ_SWITCHES;
//        end


//        READ_SWITCHES:
//        begin
//            address <= 32'd800;
//            readEnable <= 1;
//            writeEnable <= 0;

//            state <= WRITE_DATAMEM;
//        end


//        WRITE_DATAMEM:
//        begin
//            address <= 32'd10;
//            writeData <= readData;

//            writeEnable <= 1;
//            readEnable <= 0;

//            state <= READ_DATAMEM;
//        end


//        READ_DATAMEM:
//        begin
//            address <= 32'd10;
//            readEnable <= 1;
//            writeEnable <= 0;

//            state <= WRITE_LED;
//        end


//        WRITE_LED:
//        begin
//            address <= 32'd520;
//            writeData <= readData;

//            writeEnable <= 1;
//            readEnable <= 0;

//            state <= READ_SWITCHES;
//        end

//        endcase

//    end

//end

//endmodule



`timescale 1ns/1ps
module memorySystemFPGA(
    input         clk,
    input         rst,
    input  [15:0] switches,
    output [15:0] leds
);

reg [31:0] address;
reg        readEnable;
reg        writeEnable;
reg [31:0] writeData;
reg [31:0] capturedData;

wire [31:0] readData;

// Clock divider: single-cycle pulse every ~0.67s on 100 MHz
reg [25:0] counter = 0;
always @(posedge clk)
    counter <= counter + 1;
wire slowEnable = (counter == 26'h3FFFFFF);

// Memory system
addressDecoderTop system(
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

// FSM states
localparam IDLE          = 3'd0;
localparam READ_SWITCHES = 3'd1;
localparam WRITE_DATAMEM = 3'd2;
localparam READ_DATAMEM  = 3'd3;
localparam WRITE_LED     = 3'd4;

reg [2:0] state;

// KEY FIX: address is set ONE state BEFORE reading.
// Because address is a reg with nonblocking assignment (<=),
// it only takes effect on the NEXT clock edge.
// So readData based on that address is only valid the cycle AFTER.
//
// Flow:
//   IDLE          ? sets address=800, readEnable=1, goes to READ_SWITCHES
//   READ_SWITCHES ? readData is NOW valid (address=800 took effect), captures it
//                 ? sets address=10, writeData=captured, writeEnable=1, goes to WRITE_DATAMEM
//   WRITE_DATAMEM ? write to addr 10 happens on this clock edge
//                 ? sets address=10, readEnable=1, goes to READ_DATAMEM
//   READ_DATAMEM  ? readData is NOW valid (address=10 took effect), captures it
//                 ? sets address=520, writeData=captured, writeEnable=1, goes to WRITE_LED
//   WRITE_LED     ? write to LEDs happens on this clock edge
//                 ? sets address=800, readEnable=1, loops to READ_SWITCHES

always @(posedge clk) begin
    if (rst) begin
        state        <= IDLE;
        address      <= 0;
        readEnable   <= 0;
        writeEnable  <= 0;
        writeData    <= 0;
        capturedData <= 0;
    end
    else if (slowEnable) begin
        case (state)

            // Prepare: set switch address and readEnable
            IDLE: begin
                address     <= 32'd800;   // switch range (768-1023)
                readEnable  <= 1;
                writeEnable <= 0;
                state       <= READ_SWITCHES;
            end

            // readData is valid now (address=800 took effect last cycle)
            READ_SWITCHES: begin
                capturedData <= readData;              // capture switch value
                address      <= 32'd10;               // data memory location
                writeData    <= readData;              // write switch value to mem
                writeEnable  <= 1;
                readEnable   <= 0;
                state        <= WRITE_DATAMEM;
            end

            // Write to data memory happening now
            // Prepare: set address and readEnable for data memory read
            WRITE_DATAMEM: begin
                address     <= 32'd10;
                writeEnable <= 0;
                readEnable  <= 1;
                state       <= READ_DATAMEM;
            end

            // readData is valid now (address=10 took effect last cycle)
            READ_DATAMEM: begin
                capturedData <= readData;             // capture memory value
                address      <= 32'd520;              // LED range (512-767)
                writeData    <= readData;             // write mem value to LEDs
                writeEnable  <= 1;
                readEnable   <= 0;
                state        <= WRITE_LED;
            end

            // Write to LEDs happening now
            // Prepare for next iteration: set switch address and readEnable
            WRITE_LED: begin
                address     <= 32'd800;
                writeEnable <= 0;
                readEnable  <= 1;
                state       <= READ_SWITCHES;
            end

        endcase
    end
end

endmodule