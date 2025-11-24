library IEEE;
use IEEE.std_logic_1164.all;

entity tb_program_counter is
end tb_program_counter;

architecture test of tb_program_counter is

    --------------------------------------------------------------------
    -- DUT Component Declaration
    --------------------------------------------------------------------
    component program_counter
        port (
            clk   : in  std_logic;
            reset : in  std_logic;
            busy  : in  std_logic;
            q     : out std_logic_vector(4 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Testbench Signals
    --------------------------------------------------------------------
    signal clk   : std_logic := '0';
    signal reset : std_logic := '0';
    signal busy  : std_logic := '0';
    signal q     : std_logic_vector(4 downto 0);

begin
    --------------------------------------------------------------------
    -- Instantiate the DUT
    --------------------------------------------------------------------
    DUT : program_counter
        port map (
            clk   => clk,
            reset => reset,
            busy  => busy,
            q     => q
        );

    --------------------------------------------------------------------
    -- Clock Generation (20 ns period)
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk <= '0'; 
        wait for 10 ns;
        clk <= '1'; 
        wait for 10 ns;
    end process;

    --------------------------------------------------------------------
    -- Stimulus Process
    --------------------------------------------------------------------
    stim_proc : process
    begin
        ----------------------------------------------------------------
        -- Phase 1: Apply global reset
        ----------------------------------------------------------------
        reset <= '1';
        wait for 40 ns;           -- Hold reset for two cycles
        reset <= '0';
        wait for 20 ns;

        ----------------------------------------------------------------
        -- Phase 2: Busy high → start counting
        ----------------------------------------------------------------
        busy <= '1';
        wait for 200 ns;          -- Observe several increments

        ----------------------------------------------------------------
        -- Phase 3: Busy low → counter auto-resets
        ----------------------------------------------------------------
        busy <= '0';
        wait for 60 ns;           -- Counter forced to 0

        ----------------------------------------------------------------
        -- Phase 4: Busy high again → counting restarts from 0
        ----------------------------------------------------------------
        busy <= '1';
        wait for 160 ns;

        ----------------------------------------------------------------
        -- Phase 5: Apply reset again mid-count
        ----------------------------------------------------------------
        reset <= '1';
        wait for 40 ns;
        reset <= '0';
        wait for 120 ns;

        ----------------------------------------------------------------
        -- End Simulation
        ----------------------------------------------------------------
        wait;
    end process;

end test;
