library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dff8bit is
end tb_dff8bit;

architecture behavior of tb_dff8bit is

    -- Component under test
    component dff8bit
        port(
            d   : in  std_logic_vector(7 downto 0);
            clk : in  std_logic;
            q   : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals
    signal d   : std_logic_vector(7 downto 0) := (others => '0');
    signal clk : std_logic := '0';
    signal q   : std_logic_vector(7 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instantiate DUT
    uut: dff8bit
        port map (
            d   => d,
            clk => clk,
            q   => q
        );

    -- Clock generation
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc : process
    begin
        -- Initial value
        wait for 20 ns;

        -- Test 1
        d <= "00000001";
        wait for clk_period;  -- rising edge -> latch
        wait for clk_period;

        -- Test 2
        d <= "10101010";
        wait for clk_period;
        wait for clk_period;

        -- Test 3
        d <= "11111111";
        wait for clk_period;
        wait for clk_period;

        -- Test 4
        d <= "00001111";
        wait for clk_period;
        wait for clk_period;

        -- Test 5
        d <= "01010101";
        wait for clk_period;
        wait for clk_period;

        wait;
    end process;

end behavior;
