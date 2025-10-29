library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity chip_tb is
end chip_tb;

architecture behavior of chip_tb is

    ------------------------------------------------------------------------
    -- DUT Declaration
    ------------------------------------------------------------------------
    component chip
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            start       : in  std_logic;
            cpu_rd_wrn  : in  std_logic;
            cpu_add     : in  std_logic_vector(7 downto 0);
            cpu_data    : inout std_logic_vector(7 downto 0);
            mem_data    : in  std_logic_vector(7 downto 0);
            Vdd         : in  std_logic;
            Gnd         : in  std_logic;
            busy        : out std_logic;
            mem_en      : out std_logic;
            mem_add     : out std_logic_vector(7 downto 0);
            counter     : out integer range 0 to 31;
            MAIN_MEM_EN_f : out std_logic;
            O_EN_f        : out std_logic;
            WR_TAG_f      : out std_logic;
            ST_SEL_f      : out std_logic;
            DATA_SEL_f    : out std_logic;
            M_EN_f        : out std_logic;
            B_OFFSET_f    : out std_logic_vector(1 downto 0);
            CS_f          : out std_logic_vector(4 downto 0);
            s_reset_f     : out std_logic;
            Next_State_f  : out std_logic_vector(4 downto 0);
            CVT_f         : out std_logic
        );
    end component;

    ------------------------------------------------------------------------
    -- Signals
    ------------------------------------------------------------------------
    signal clk_tb         : std_logic := '0';
    signal reset_tb       : std_logic := '0';
    signal start_tb       : std_logic := '0';
    signal cpu_rd_wrn_tb  : std_logic := '0';
    signal cpu_add_tb     : std_logic_vector(7 downto 0) := (others => '0');
    signal cpu_data_tb    : std_logic_vector(7 downto 0) := (others => '0');
    signal mem_data_tb    : std_logic_vector(7 downto 0) := (others => '0');
    signal Vdd_tb         : std_logic := '1';
    signal Gnd_tb         : std_logic := '0';
    signal busy_tb        : std_logic;
    signal mem_en_tb      : std_logic;
    signal mem_add_tb     : std_logic_vector(7 downto 0);
    signal counter_tb     : integer range 0 to 31;
    signal MAIN_MEM_EN_tb : std_logic;
    signal O_EN_tb        : std_logic;
    signal WR_TAG_tb      : std_logic;
    signal ST_SEL_tb      : std_logic;
    signal DATA_SEL_tb    : std_logic;
    signal M_EN_tb        : std_logic;
    signal B_OFFSET_tb    : std_logic_vector(1 downto 0);
    signal CS_tb          : std_logic_vector(4 downto 0);
    signal s_reset_tb     : std_logic;
    signal Next_State_tb  : std_logic_vector(4 downto 0);
    signal CVT_tb         : std_logic;

    constant clk_period : time := 10 ns;

begin

    ------------------------------------------------------------------------
    -- DUT Instantiation
    ------------------------------------------------------------------------
    uut: chip
        port map (
            clk         => clk_tb,
            reset       => reset_tb,
            start       => start_tb,
            cpu_rd_wrn  => cpu_rd_wrn_tb,
            cpu_add     => cpu_add_tb,
            cpu_data    => cpu_data_tb,
            mem_data    => mem_data_tb,
            Vdd         => Vdd_tb,
            Gnd         => Gnd_tb,
            busy        => busy_tb,
            mem_en      => mem_en_tb,
            mem_add     => mem_add_tb,
            counter     => counter_tb,
            MAIN_MEM_EN_f => MAIN_MEM_EN_tb,
            O_EN_f        => O_EN_tb,
            WR_TAG_f      => WR_TAG_tb,
            ST_SEL_f      => ST_SEL_tb,
            DATA_SEL_f    => DATA_SEL_tb,
            M_EN_f        => M_EN_tb,
            B_OFFSET_f    => B_OFFSET_tb,
            CS_f          => CS_tb,
            s_reset_f     => s_reset_tb,
            Next_State_f  => Next_State_tb,
            CVT_f         => CVT_tb
        );

    ------------------------------------------------------------------------
    -- Clock Generation
    ------------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk_tb <= '1';
            wait for clk_period/2;
            clk_tb <= '0';
            wait for clk_period/2;
        end loop;
    end process;

    ------------------------------------------------------------------------
    -- Stimulus Process
    ------------------------------------------------------------------------
    stim_proc: process
    begin
        --------------------------------------------------------------------
        -- Reset
        --------------------------------------------------------------------
        reset_tb <= '0';
        wait for clk_period * 1;
        reset_tb <= '1';
        wait for clk_period * 3;
        reset_tb <= '0';
        wait for clk_period * 2;

        --------------------------------------------------------------------
        -- READ MISS
        --------------------------------------------------------------------
        start_tb <= '1';
        cpu_rd_wrn_tb <= '1';        -- Read
        cpu_add_tb <= x"0C";         -- Address
        cpu_data_tb <= (others => 'Z');
        mem_data_tb <= x"55";
        wait for clk_period;
        start_tb <= '0';
        wait until busy_tb = '1';
        wait for clk_period * 8;
        wait until busy_tb = '0';
        wait for clk_period * 2;

        --------------------------------------------------------------------
        -- READ HIT
        --------------------------------------------------------------------
        start_tb <= '1';
        cpu_rd_wrn_tb <= '1';
        cpu_add_tb <= x"0C";
        wait for clk_period;
        start_tb <= '0';
        wait until busy_tb = '1';
        wait for clk_period * 4;
        wait until busy_tb = '0';
        wait for clk_period * 2;

        --------------------------------------------------------------------
        -- WRITE HIT
        --------------------------------------------------------------------
        start_tb <= '1';
        cpu_rd_wrn_tb <= '0';        -- Write
        cpu_add_tb <= x"0C";
        cpu_data_tb <= x"F0";
        wait for clk_period;
        start_tb <= '0';
        wait until busy_tb = '1';
        wait for clk_period * 6;
        wait until busy_tb = '0';
        wait for clk_period * 2;

        --------------------------------------------------------------------
        -- End Simulation
        --------------------------------------------------------------------
        wait for clk_period * 10;
        wait;
    end process;

end behavior;
