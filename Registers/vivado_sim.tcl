exec xvhdl inv.vhd nand2.vhd dlatch.vhd dff_neg.vhd tb_dff_neg.vhd

exec xelab tb_dff_neg -debug typical -s sim_out

exec xsim sim_out -gui

