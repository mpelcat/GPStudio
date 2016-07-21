#This file adds delays to inputs/outputs ports for the ethernet block / marvell communication

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {clk_125M_i} -period 8.000 -waveform { 0.000 4.000 } [get_ports {clk_125M_i}]
create_clock -name {clk_50M_i} -period 20.000 -waveform { 0.000 10.000 } [get_ports {clk_50M_i}]
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
set_input_delay -add_delay -max -clock [get_clocks {GE_RXCLK}]  0.500 [get_ports {RX_data*}]
set_input_delay -add_delay -min -clock [get_clocks {GE_RXCLK}]  -0.500 [get_ports {RX_data*}]

set_input_delay -add_delay -max -clock [get_clocks {GE_RXCLK}]  0.500 [get_ports {RX_dv}]
set_input_delay -add_delay -min -clock [get_clocks {GE_RXCLK}]  -0.500 [get_ports {RX_dv}]
#**************************************************************
# Set Output Delay
#**************************************************************
set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX_data*}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX_data*}]

set_output_delay -add_delay -max -clock [get_clocks {GE_TXCLK}]  1.000 [get_ports {TX_dv}]
set_output_delay -add_delay -min -clock [get_clocks {GE_TXCLK}]  -0.800 [get_ports {TX_dv}]
