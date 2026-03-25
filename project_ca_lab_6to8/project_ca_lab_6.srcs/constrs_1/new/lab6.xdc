### lab6_basys3.xdc
### Basys3 Constraints for Lab 6 - ALU FPGA Implementation
### Only the pins used are uncommented

### Clock (100 MHz)
#set_property PACKAGE_PIN W5 [get_ports clk]
#set_property IOSTANDARD LVCMOS33 [get_ports clk]
#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

### Reset Button - btnC
#set_property PACKAGE_PIN U18 [get_ports rst_btn]
#set_property IOSTANDARD LVCMOS33 [get_ports rst_btn]

### Switches - sw[3:0] used for ALUControl[3:0]
#set_property PACKAGE_PIN V17 [get_ports {sw_phys[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[0]}]

#set_property PACKAGE_PIN V16 [get_ports {sw_phys[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[1]}]

#set_property PACKAGE_PIN W16 [get_ports {sw_phys[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[2]}]

#set_property PACKAGE_PIN W17 [get_ports {sw_phys[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[3]}]

#set_property PACKAGE_PIN W15 [get_ports {sw_phys[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[4]}]

#set_property PACKAGE_PIN V15 [get_ports {sw_phys[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[5]}]

#set_property PACKAGE_PIN W14 [get_ports {sw_phys[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[6]}]

#set_property PACKAGE_PIN W13 [get_ports {sw_phys[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[7]}]

#set_property PACKAGE_PIN V2  [get_ports {sw_phys[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[8]}]

#set_property PACKAGE_PIN T3  [get_ports {sw_phys[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[9]}]

#set_property PACKAGE_PIN T2  [get_ports {sw_phys[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[10]}]

#set_property PACKAGE_PIN R3  [get_ports {sw_phys[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[11]}]

#set_property PACKAGE_PIN W2  [get_ports {sw_phys[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[12]}]

#set_property PACKAGE_PIN U1  [get_ports {sw_phys[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[13]}]

#set_property PACKAGE_PIN T1  [get_ports {sw_phys[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[14]}]

#set_property PACKAGE_PIN R2  [get_ports {sw_phys[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {sw_phys[15]}]

### LEDs - led[15:0]
#set_property PACKAGE_PIN U16 [get_ports {led_phys[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[0]}]

#set_property PACKAGE_PIN E19 [get_ports {led_phys[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[1]}]

#set_property PACKAGE_PIN U19 [get_ports {led_phys[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[2]}]

#set_property PACKAGE_PIN V19 [get_ports {led_phys[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[3]}]

#set_property PACKAGE_PIN W18 [get_ports {led_phys[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[4]}]

#set_property PACKAGE_PIN U15 [get_ports {led_phys[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[5]}]

#set_property PACKAGE_PIN U14 [get_ports {led_phys[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[6]}]

#set_property PACKAGE_PIN V14 [get_ports {led_phys[7]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[7]}]

#set_property PACKAGE_PIN V13 [get_ports {led_phys[8]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[8]}]

#set_property PACKAGE_PIN V3  [get_ports {led_phys[9]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[9]}]

#set_property PACKAGE_PIN W3  [get_ports {led_phys[10]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[10]}]

#set_property PACKAGE_PIN U3  [get_ports {led_phys[11]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[11]}]

#set_property PACKAGE_PIN P3  [get_ports {led_phys[12]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[12]}]

#set_property PACKAGE_PIN N3  [get_ports {led_phys[13]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[13]}]

#set_property PACKAGE_PIN P1  [get_ports {led_phys[14]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[14]}]

#set_property PACKAGE_PIN L1  [get_ports {led_phys[15]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {led_phys[15]}]

### 7-Segment Display - Segments
#set_property PACKAGE_PIN W7  [get_ports {seg[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

#set_property PACKAGE_PIN W6  [get_ports {seg[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]

#set_property PACKAGE_PIN U8  [get_ports {seg[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]

#set_property PACKAGE_PIN V8  [get_ports {seg[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]

#set_property PACKAGE_PIN U5  [get_ports {seg[4]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]

#set_property PACKAGE_PIN V5  [get_ports {seg[5]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]

#set_property PACKAGE_PIN U7  [get_ports {seg[6]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]

### 7-Segment Anodes
#set_property PACKAGE_PIN U2  [get_ports {an[0]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]

#set_property PACKAGE_PIN U4  [get_ports {an[1]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]

#set_property PACKAGE_PIN V4  [get_ports {an[2]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]

#set_property PACKAGE_PIN W4  [get_ports {an[3]}]
#set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]
