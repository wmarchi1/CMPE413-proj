library IEEE;
use IEEE.std_logic_1164.all;

entity mux218_tb is
end mux218_tb;

architecture behavior of mux218_tb is

    -- Component under test (C.U.T)
    component mux218
        port(
            input0   : in  std_logic_vector(7 downto 0);
            input1   : in  std_logic_vector(7 downto 0);
            sel_bit  : in  std_logic;
            y        : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Testbench signals
    signal input0_tb   : std_logic_vector(7 downto 0);
    signal input1_tb   : std_logic_vector(7 downto 0);
    signal sel_bit_tb  : std_logic;
    signal y_tb        : std_logic_vector(7 downto 0);

begin

    -- Instantiate the mux218
    uut: mux218
        port map(
            input0   => input0_tb,
            input1   => input1_tb,
            sel_bit  => sel_bit_tb,
            y        => y_tb
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize inputs
        input0_tb <= (others => '0');
        input1_tb <= (others => '0');
        sel_bit_tb <= '0';
        wait for 10 ns;

        -- Test 1: Select input0
        input0_tb <= "00001111";
        input1_tb <= "11110000";
        sel_bit_tb <= '0';
        wait for 20 ns;

        -- Test 2: Select input1
        sel_bit_tb <= '1';
        wait for 20 ns;

        -- Test 3: New patterns
        input0_tb <= "10101010";
        input1_tb <= "01010101";
        sel_bit_tb <= '0';
        wait for 20 ns;

        sel_bit_tb <= '1';
        wait for 20 ns;

        -- Test 4: All zeros and ones
        input0_tb <= (others => '0');
        input1_tb <= (others => '1');
        sel_bit_tb <= '0';
        wait for 20 ns;

        sel_bit_tb <= '1';
        wait for 20 ns;

        -- Test 5: Random mix
        input0_tb <= "11001100";
        input1_tb <= "00110011";
        sel_bit_tb <= '0';
        wait for 20 ns;

        sel_bit_tb <= '1';
        wait for 20 ns;

        -- End simulation
        wait;
    end process;

end behavior;
