exec xvhdl inv.vhd and2.vhd and3.vhd and5.vhd or2.vhd xor2.vhd nand2.vhd mux21.vhd dlatch.vhd dff.vhd dff_neg.vhd program_counter.vhd cache_fsm.vhd cache_controller_top.vhd tb_cache_controller_top.vhd
exec xelab tb_cache_controller_top -debug typical -s sim_out
exec xsim sim_out -gui
