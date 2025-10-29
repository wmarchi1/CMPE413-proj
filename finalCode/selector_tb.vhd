-- exec xvhdl and2.vhd inv.vhd selector.vhd selector_tb.vhd
-- exec xelab selector_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;

entity selector_tb is
-- Testbench has no ports
end selector_tb;

architecture behavioral of selector_tb is

    -- Component declaration for the selector under test
    component selector
        port(
            in0  : in  std_logic;  -- Chip Enable
            in1  : in  std_logic;  -- RD/WR
            out0 : out std_logic;  -- Read Enable
            out1 : out std_logic   -- Write Enable
        );
    end component;

    -- Signals to connect to selector
    signal in0_sig  : std_logic := '0';
    signal in1_sig  : std_logic := '0';
    signal out0_sig : std_logic;
    signal out1_sig : std_logic;

begin

    -- Instantiate the selector
    uut: selector
        port map(
            in0  => in0_sig,
            in1  => in1_sig,
            out0 => out0_sig,
            out1 => out1_sig
        );

    -- Stimulus process
    stim_proc: process
    begin

      in0_sig <= '1';
      in1_sig <= '1';
      wait for 10 ns;

      in0_sig <= '1';
      in1_sig <= '0';
      wait for 10 ns;

      in0_sig <= '0';
      in1_sig <= '1';
      wait for 10 ns;

      in0_sig <= '0';
      in1_sig <= '0';
      wait for 10 ns;
      wait;
      end process;

end behavioral;
