set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {CLK125} -period 8.000 -waveform { 0.000 4.000 } [get_ports {CLK125}]
create_clock -name {GE_RXCLK} -period 8.000 -waveform { 0.000 4.000 } [get_ports {GE_RXCLK}]
create_clock -name {GE_TXCLK} -period 8.000 -waveform { 0.000 4.000 } [get_ports {GE_TXCLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks

#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock [get_clocks {GE_RXCLK}] -max 0.500 [get_ports RX.data*]
set_input_delay -clock [get_clocks {GE_RXCLK}] -min 0.500 [get_ports RX.dv]

#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.data[0]}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.data[0]}]
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.data[1]}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.data[1]}]
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.data[2]}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.data[2]}]
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.data[3]}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.data[3]}]
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.data[4]}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.data[4]}]
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.data[5]}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.data[5]}]
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.data[6]}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.data[6]}]
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.data[7]}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.data[7]}]
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX.dv}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX.dv}]