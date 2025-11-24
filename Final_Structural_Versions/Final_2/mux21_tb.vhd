--exec xvhdl and2.vhd or2.vhd inv.vhd mux21.vhd mux21_tb.vhd
--exec xelab mux21_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;

entity mux21_tb is
end mux21_tb;

architecture behavior of mux21_tb is

    -- Component declaration
    component mux21
        port(
            a   : in  std_logic;
            b   : in  std_logic;
            sel : in  std_logic;
            y   : out std_logic
        );
    end component;

    -- Signals to connect to UUT
    signal a   : std_logic := '0';
    signal b   : std_logic := '0';
    signal sel : std_logic := '0';
    signal y   : std_logic;

begin

    -- Instantiate the UUT
    uut: mux21
        port map(
            a   => a,
            b   => b,
            sel => sel,
            y   => y
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test case 1: sel=0, a=0, b=0
        sel <= '0'; a <= '0'; b <= '0';
        wait for 10 ns;

        -- Test case 2: sel=0, a=0, b=1
        sel <= '0'; a <= '0'; b <= '1';
        wait for 10 ns;

        -- Test case 3: sel=0, a=1, b=0
        sel <= '0'; a <= '1'; b <= '0';
        wait for 10 ns;

        -- Test case 4: sel=0, a=1, b=1
        sel <= '0'; a <= '1'; b <= '1';
        wait for 10 ns;

        -- Test case 5: sel=1, a=0, b=0
        sel <= '1'; a <= '0'; b <= '0';
        wait for 10 ns;

        -- Test case 6: sel=1, a=0, b=1
        sel <= '1'; a <= '0'; b <= '1';
        wait for 10 ns;

        -- Test case 7: sel=1, a=1, b=0
        sel <= '1'; a <= '1'; b <= '0';
        wait for 10 ns;

        -- Test case 8: sel=1, a=1, b=1
        sel <= '1'; a <= '1'; b <= '1';
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end behavior;
