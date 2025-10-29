exec xvhdl inv.vhd and2.vhd or2.vhd xor2.vhd mux21.vhd dlatch.vhd dff_neg.vhd program_counter.vhd cache_fsm.vhd cache_controller_top.vhd tb_cache_controller_top.vhd
exec xelab tb_cache_controller_top -debug typical -s sim_out
exec xsim sim_out -gui
