library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dff_pos is
end tb_dff_pos;

architecture behavior of tb_dff_pos is

    -- DUT component declaration
    component dff
        port(
            d   : in  std_logic;
            clk : in  std_logic;
            q   : out std_logic
        );
    end component;

    -- Test signals
    signal d_tb   : std_logic := '0';
    signal clk_tb : std_logic := '0';
    signal q_tb   : std_logic;

    -- Clock period constant
    constant CLK_PERIOD : time := 20 ns;

begin

    ----------------------------------------------------------------
    -- Instantiate the Device Under Test (DUT)
    ----------------------------------------------------------------
    uut : dff
        port map (
            d   => d_tb,
            clk => clk_tb,
            q   => q_tb
        );

    ----------------------------------------------------------------
    -- Clock generation process
    -- Clock starts at '0' and toggles every 10 ns (20 ns period)
    ----------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    ----------------------------------------------------------------
    -- Stimulus process
    ----------------------------------------------------------------
    stim_proc : process
    begin
        -- Initial values
        d_tb <= '0';
        wait for 15 ns;  -- wait before first rising edge

        -- Apply some input transitions
        d_tb <= '1';     -- D = 1 before rising edge → should latch on next rising edge
        wait for 40 ns;

        d_tb <= '0';     -- D = 0 before next rising edge
        wait for 40 ns;

        d_tb <= '1';
        wait for 40 ns;

        d_tb <= '0';
        wait for 40 ns;

        -- Finish simulation
        wait;
    end process;

end behavior;
