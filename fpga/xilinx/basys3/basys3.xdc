## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]							
set_property IOSTANDARD LVCMOS33 [get_ports CLK]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]
 
##Buttons
set_property PACKAGE_PIN U18 [get_ports RESET]						
set_property IOSTANDARD LVCMOS33 [get_ports RESET]

 
##USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports RX]						
set_property IOSTANDARD LVCMOS33 [get_ports RX]

set_property PACKAGE_PIN A18 [get_ports TX]						
set_property IOSTANDARD LVCMOS33 [get_ports TX]


