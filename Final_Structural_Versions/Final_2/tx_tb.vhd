-- exec xvhdl tx.vhd tx_tb.vhd
--exec xelab tx_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;

entity tx_tb is
end tx_tb;

architecture behavioral of tx_tb is

    -- Component declaration for the transmission gate
    component tx
        port(
            sel       : in  std_logic;
            selnot    : in  std_logic;
            tx_input  : in  std_logic;
            tx_output : out std_logic
        );
    end component;

    -- Signals to connect to tx
    signal sel_sig       : std_logic := '0';
    signal selnot_sig    : std_logic := '1';
    signal tx_input_sig  : std_logic := '0';
    signal tx_output_sig : std_logic;

begin

    -- Instantiate the transmission gate
    uut: tx
        port map(
            sel       => sel_sig,
            selnot    => selnot_sig,
            tx_input  => tx_input_sig,
            tx_output => tx_output_sig
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test 1: sel = 0, selnot = 1 => output should be Z
        sel_sig <= '0';
        selnot_sig <= '1';
        tx_input_sig <= '0';
        wait for 10 ns;
        
        -- Test 2: sel = 1, selnot = 0 => output should follow input
        sel_sig <= '1';
        selnot_sig <= '0';
        tx_input_sig <= '1';
        wait for 10 ns;
        
        -- Test 3: toggle input while enabled
        tx_input_sig <= '0';
        wait for 10 ns;
        
        tx_input_sig <= '1';
        wait for 10 ns;
        
        -- Test 4: disable the gate
        sel_sig <= '0';
        selnot_sig <= '1';
        tx_input_sig <= '0';
        wait for 10 ns;
        
        -- End simulation
        wait;
    end process stim_proc;

end behavioral;
