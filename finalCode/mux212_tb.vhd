library IEEE;
use IEEE.std_logic_1164.all;

entity mux212_tb is
end mux212_tb;

architecture behavior of mux212_tb is

    -- Component under test
    component mux212
        port(
            input0   : in  std_logic_vector(1 downto 0);
            input1   : in  std_logic_vector(1 downto 0);
            sel_bit  : in  std_logic;
            y        : out std_logic_vector(1 downto 0)
        );
    end component;

    -- Testbench signals
    signal input0_tb  : std_logic_vector(1 downto 0) := (others => '0');
    signal input1_tb  : std_logic_vector(1 downto 0) := (others => '0');
    signal sel_bit_tb : std_logic := '0';
    signal y_tb       : std_logic_vector(1 downto 0);

begin

    -- Instantiate the mux212
    uut: mux212
        port map(
            input0  => input0_tb,
            input1  => input1_tb,
            sel_bit => sel_bit_tb,
            y       => y_tb
        );

    ---------------------------------------------------------------------
    -- Stimulus Process
    ---------------------------------------------------------------------
    stim_proc: process
    begin
        -- Test 1: sel = 0, choose input0
        input0_tb <= "00";
        input1_tb <= "11";
        sel_bit_tb <= '0';
        wait for 20 ns;

        -- Test 2: sel = 1, choose input1
        sel_bit_tb <= '1';
        wait for 20 ns;

        -- Test 3: new data, sel = 0
        input0_tb <= "10";
        input1_tb <= "01";
        sel_bit_tb <= '0';
        wait for 20 ns;

        -- Test 4: sel = 1
        sel_bit_tb <= '1';
        wait for 20 ns;

        -- Test 5: mix pattern
        input0_tb <= "01";
        input1_tb <= "10";
        sel_bit_tb <= '0';
        wait for 20 ns;

        sel_bit_tb <= '1';
        wait for 20 ns;

        -- End of simulation
        wait;
    end process;

end behavior;
