--exec xvhdl and2.vhd inv.vhd selector.vhd tx.vhd dff.vhd cacheCell.vhd cacheCell_tb.vhd
--exec xelab cacheCell_tb -debug typical -s sim_out
-- /umbc/software/scripts/launch_xilinx_vivado.sh -mode batch -source vivado_sim.tcl
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use STD.textio.all;

entity cacheCell_tb is
end cacheCell_tb;

architecture test of cacheCell_tb is

  component cacheCell
    port (
        chip_enable : in std_logic;
        rd_wr       : in std_logic;
        data_in     : in std_logic;
        data_out    : out std_logic
    );
  end component;

  signal writeDataSig  : std_logic := '0';
  signal chipEnableSig : std_logic := '0';
  signal rwSig         : std_logic := '0';
  signal readDataSig   : std_logic;

  procedure print_signals(test_name : string) is
    variable out_line : line;
  begin
    write(out_line, string'("Test: "));
    write(out_line, test_name);
    write(out_line, string'(" | CE=")); write(out_line, chipEnableSig);
    write(out_line, string'(" RW=")); write(out_line, rwSig);
    write(out_line, string'(" WD=")); write(out_line, writeDataSig);
    write(out_line, string'(" RD=")); write(out_line, readDataSig);
    writeline(output, out_line);
  end procedure;

begin

  -- Instantiate the cacheCell DUT
  DUT : cacheCell
    port map (
        data_in   => writeDataSig,
        chip_enable => chipEnableSig,
        rd_wr      => rwSig,
        data_out   => readDataSig
    );

  stim_proc : process
  begin

    -- CASE 1: Chip disabled (CE=0)
    chipEnableSig <= '0';
    rwSig <= '0';
    writeDataSig <= '0';
    wait for 3 ns;
    chipEnableSig <= '1';
    wait for 2 ns;
    chipEnableSig <= '0';

    print_signals("CE=0 (Disabled): Expect no read/write");

    -- CASE 2: CE=1, RW=1 (READ mode)
    rwSig <= '1';     -- read mode
    writeDataSig <= '1';  -- data written earlier may appear on read
    wait for 2 ns;
    chipEnableSig <= '1';
    wait for 3 ns;
    print_signals("CE=1, RW=1 (Read mode): Expect read enable active");

    -- CASE 1: Chip disabled (CE=0)
    chipEnableSig <= '0';
    rwSig <= '0';
    writeDataSig <= '1';
    wait for 3 ns;
    chipEnableSig <= '1';
    wait for 2 ns;
    chipEnableSig <= '0';

    print_signals("CE=0 (Disabled): Expect no read/write");

    -- CASE 2: CE=1, RW=1 (READ mode)
    rwSig <= '1';     -- read mode
    writeDataSig <= '0';  -- data written earlier may appear on read
    wait for 2 ns;
    chipEnableSig <= '1';
    wait for 3 ns;
    print_signals("CE=1, RW=1 (Read mode): Expect read enable active");

    wait;
  end process;

end test;