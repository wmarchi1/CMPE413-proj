exec xvhdl dff_neg.vhd xor2.vhd mux42.vhd program_counter.vhd cache_fsm.vhd peripheral_interface2.vhd cache_controller_top.vhd chip.vhd chip_tb.vhd
exec xelab chip_tb -debug typical -s sim_out
exec xsim sim_out -gui