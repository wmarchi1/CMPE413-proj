library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity chip_tb is
end chip_tb;

architecture behavior of chip_tb is
    -- DUT component
    component chip
        port (
            cpu_add    : in  std_logic_vector(7 downto 0);
            cpu_data   : inout  std_logic_vector(7 downto 0);
            cpu_rd_wrn : in  std_logic;
            start      : in  std_logic;
            clk        : in  std_logic;
            reset      : in  std_logic;
            mem_data   : in  std_logic_vector(7 downto 0);
            Vdd        : in  std_logic;
            Gnd        : in  std_logic;
            busy       : out std_logic;
            mem_en     : out std_logic;
            mem_add    : out std_logic_vector(7 downto 0);

            -- State Machine Signals
            counter_out : out integer range 0 to 31 := 0;
            output_enable : out std_logic;
            CS_out        : out std_logic_vector(4 downto 0);
            Next_State_out : out std_logic_vector(4 downto 0)
        );
    end component;

    -- Signals
    signal cpu_add_tb    : std_logic_vector(7 downto 0) := (others => '0');
    signal cpu_data_tb   : std_logic_vector(7 downto 0) := (others => 'Z');
    signal cpu_rd_wrn_tb : std_logic := '1';
    signal start_tb      : std_logic := '0';
    signal clk_tb        : std_logic := '0';
    signal reset_tb      : std_logic := '0';
    signal mem_data_tb   : std_logic_vector(7 downto 0) := (others => '0');
    signal busy_tb       : std_logic;
    signal mem_en_tb     : std_logic;
    signal mem_add_tb    : std_logic_vector(7 downto 0);
    signal Vdd_tb        : std_logic := '1';
    signal Gnd_tb        : std_logic := '0';

    constant clk_period : time := 10 ns;
    signal counter_out_tb : integer range 0 to 31 := 0;
    signal output_enable_tb : std_logic;
    signal CS_out_tb : std_logic_vector(4 downto 0);
    signal Next_State_out_tb : std_logic_vector(4 downto 0);

begin
    -- Instantiate DUT
    uut: chip
        port map (
            cpu_add => cpu_add_tb,
            cpu_data => cpu_data_tb,
            cpu_rd_wrn => cpu_rd_wrn_tb,
            start => start_tb,
            clk => clk_tb,
            reset => reset_tb,
            mem_data => mem_data_tb,
            Vdd => Vdd_tb,
            Gnd => Gnd_tb,
            busy => busy_tb,
            mem_en => mem_en_tb,
            mem_add => mem_add_tb,

            --FSM Signals
            counter_out => counter_out_tb,
            output_enable => output_enable_tb,
            CS_out  => CS_out_tb,
            Next_State_out => Next_State_out_tb
        );

    -- Clock process
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period / 2;
        clk_tb <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        ------------------------------------------------------
        -- Reset sequence (2 cycles)
        ------------------------------------------------------
        reset_tb <= '0';
        wait for 2 * clk_period;
        reset_tb <= '1';
        wait for 2 * clk_period;
        reset_tb <= '0';
        wait for clk_period;

        ------------------------------------------------------
        -- READ MISS: Address 0x00 (causes memory fetch)
        ------------------------------------------------------
        cpu_add_tb <= x"00";
        cpu_rd_wrn_tb <= '1';   -- read
        start_tb <= '1';
        wait for clk_period;
        start_tb <= '0';

        -- Simulate memory returning data after 8 cycles
        wait for 8 * clk_period;
        mem_data_tb <= x"AA";
        wait for 2 * clk_period;
        mem_data_tb <= x"BB";
        wait for 2 * clk_period;
        mem_data_tb <= x"CC";
        wait for 2 * clk_period;
        mem_data_tb <= x"DD";
        wait for 2 * clk_period;
        mem_data_tb <= (others => '0');
        wait for 4 * clk_period;

        ------------------------------------------------------
        -- WRITE HIT: Address 0x03, data = 0xFF
        ------------------------------------------------------
        cpu_add_tb <= x"03";
        cpu_data_tb <= x"FF";
        cpu_rd_wrn_tb <= '0';   -- write
        start_tb <= '1';
        wait for clk_period;
        start_tb <= '0';
        wait for 4 * clk_period; -- allow busy to clear

        ------------------------------------------------------
        -- READ HIT: Address 0x03
        ------------------------------------------------------
        cpu_add_tb <= x"03";
        cpu_rd_wrn_tb <= '1';   -- read
        start_tb <= '1';
        wait for clk_period;
        start_tb <= '0';
        wait for 4 * clk_period;

        ------------------------------------------------------
        -- WRITE MISS: Address 0xFF, data = 0xAA
        ------------------------------------------------------
        cpu_add_tb <= x"FF";
        cpu_data_tb <= x"AA";
        cpu_rd_wrn_tb <= '0';
        start_tb <= '1';
        wait for clk_period;
        start_tb <= '0';
        wait for 4 * clk_period;

        ------------------------------------------------------
        -- End of simulation
        ------------------------------------------------------
        wait for 20 * clk_period;
        assert false report "Simulation Finished Successfully" severity note;
        wait;
    end process;
end behavior;
