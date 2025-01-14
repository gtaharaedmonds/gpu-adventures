# Based on:
# https://github.com/Digilent/digilent-xdc/blob/master/Nexys-Video-Master.xdc

## LEDs
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS25 } [get_ports { led[0] }]; #IO_L15P_T2_DQS_13 Sch=led[0]

## Switches
set_property -dict { PACKAGE_PIN E22  IOSTANDARD LVCMOS12 } [get_ports { sw[0] }]; #IO_L22P_T3_16 Sch=sw[0]
set_property -dict { PACKAGE_PIN F21  IOSTANDARD LVCMOS12 } [get_ports { sw[1] }]; #IO_25_16 Sch=sw[1]
set_property -dict { PACKAGE_PIN G21  IOSTANDARD LVCMOS12 } [get_ports { sw[2] }]; #IO_L24P_T3_16 Sch=sw[2]
set_property -dict { PACKAGE_PIN G22  IOSTANDARD LVCMOS12 } [get_ports { sw[3] }]; #IO_L24N_T3_16 Sch=sw[3]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
