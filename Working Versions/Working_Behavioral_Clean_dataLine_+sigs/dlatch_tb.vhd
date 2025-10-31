-- exec xvhdl Dlatch.vhd dlatch_tb.vhd
-- exec xelab dlatch_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;

entity Dlatch_tb is
-- Testbench has no ports
end Dlatch_tb;

architecture behavioral of Dlatch_tb is

    -- Component declaration for the Dlatch under test
    component Dlatch
        port(
            d   : in  std_logic;
            clk : in  std_logic;
            q   : out std_logic
        );
    end component;

    -- Signals to connect to the Dlatch
    signal d_sig   : std_logic := '0';
    signal clk_sig : std_logic := '0';
    signal q_sig   : std_logic;

begin

    -- Instantiate the Dlatch
    uut: Dlatch
        port map(
            d   => d_sig,
            clk => clk_sig,
            q   => q_sig
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Initial values
        d_sig   <= '0';
        clk_sig <= '0';
        wait for 10 ns;

        -- Apply some test vectors
        -- 1. Clock low, D changes (should not update Q)
        d_sig <= '1';
        wait for 10 ns;

        -- 2. Clock high, D = 1 (Q should follow D)
        clk_sig <= '1';
        wait for 10 ns;

        -- 3. Clock high, D = 0 (Q should follow D)
        d_sig <= '0';
        wait for 10 ns;

        -- 4. Clock low, D = 1 (Q should hold previous value)
        clk_sig <= '0';
        d_sig   <= '1';
        wait for 10 ns;

        -- 5. Clock high, D = 1 (Q updates to D)
        clk_sig <= '1';
        wait for 10 ns;

        -- End simulation
        wait;
    end process stim_proc;

end behavioral;


