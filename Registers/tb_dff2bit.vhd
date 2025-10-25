library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dff2bit is
end tb_dff2bit;

architecture behavior of tb_dff2bit is

    -- Component under test
    component dff2bit
        port(
            d   : in  std_logic_vector(1 downto 0);
            clk : in  std_logic;
            q   : out std_logic_vector(1 downto 0)
        );
    end component;

    -- Signals
    signal d   : std_logic_vector(1 downto 0) := (others => '0');
    signal clk : std_logic := '0';
    signal q   : std_logic_vector(1 downto 0);

    constant clk_period : time := 10 ns;

begin

    -- Instantiate DUT
    uut: dff2bit
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

    -- Test stimulus
    stim_proc : process
    begin
        wait for 20 ns;

        -- Test 1: 00
        d <= "00";
        wait for clk_period;
        wait for clk_period;

        -- Test 2: 01
        d <= "01";
        wait for clk_period;
        wait for clk_period;

        -- Test 3: 10
        d <= "10";
        wait for clk_period;
        wait for clk_period;

        -- Test 4: 11
        d <= "11";
        wait for clk_period;
        wait for clk_period;

        -- Test 5: Alternate pattern
        d <= "01";
        wait for clk_period;
        wait for clk_period;

        wait;
    end process;

end behavior;
