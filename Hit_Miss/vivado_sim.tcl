exec xvhdl and2.vhd or2.vhd inv.vhd xnor2.vhd hit_miss.vhd tb_hit_miss.vhd

exec xelab tb_hit_miss -debug typical -s sim_out

exec xsim sim_out -gui

