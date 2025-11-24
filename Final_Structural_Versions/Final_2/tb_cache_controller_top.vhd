library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_cache_controller_top is
end tb_cache_controller_top;

architecture behavior of tb_cache_controller_top is

    -- DUT component declaration
    component cache_controller_top
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            start      : in  std_logic;
            rd_wr_not  : in  std_logic;
            CVT        : in  std_logic;
            counter_f    : out integer range 0 to 31;
            Busy       : out std_logic;
            MAIN_MEM_EN : out std_logic;
            O_EN       : out std_logic;
            WR_TAG     : out std_logic;
            ST_SEL     : out std_logic;
            DATA_SEL   : out std_logic;
            M_EN       : out std_logic;
            B_OFFSET   : out std_logic_vector(1 downto 0);
            CS         : out std_logic_vector(25 downto 0);
			s_reset : out std_logic
        );
    end component;

    -- Testbench signals
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal start      : std_logic := '0';
    signal rd_wr_not  : std_logic := '0';
    signal CVT        : std_logic := '0';
    signal counter    : integer range 0 to 31 := 0;
    signal Busy       : std_logic := '0';
    signal MAIN_MEM_EN : std_logic := '0';
    signal O_EN       : std_logic := '0';
    signal WR_TAG     : std_logic := '0';
    signal ST_SEL     : std_logic := '0';
    signal DATA_SEL   : std_logic := '0';
    signal M_EN       : std_logic := '0';
    signal B_OFFSET   : std_logic_vector(1 downto 0);
    signal CS: std_logic_vector(25 downto 0);
	signal s_reset : std_logic := '0';
	signal temp_eq_f : std_logic := '0';
    -- Clock period
    constant clk_period : time := 10 ns;

begin

    ------------------------------------------------------------------------
    -- Instantiate the DUT (cache_controller_top)
    ------------------------------------------------------------------------
    uut: cache_controller_top
        Port map (
            clk         => clk,
            reset       => reset,
            start       => start,
            rd_wr_not   => rd_wr_not,
            CVT         => CVT,
            counter_f     => counter,
            Busy        => Busy,
            MAIN_MEM_EN => MAIN_MEM_EN,
            O_EN        => O_EN,
            WR_TAG      => WR_TAG,
            ST_SEL      => ST_SEL,
            DATA_SEL    => DATA_SEL,
            M_EN        => M_EN, 
            B_OFFSET    => B_OFFSET,                       
            CS          => CS,
			s_reset     => s_reset
        );

    ------------------------------------------------------------------------
    -- Clock process
    ------------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '1';
            wait for clk_period/2;
            clk <= '0';
            wait for clk_period/2;
        end loop;
    end process;

    ------------------------------------------------------------------------
    -- Stimulus process
    ------------------------------------------------------------------------
    stim_proc: process
    begin
        -- Reset sequence
        reset <= '0';
        wait for 20 ns;
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 60 ns;

        --------------------------------------------------------------------
        -- Test 1: READ HIT
        --------------------------------------------------------------------
        start <= '1';
        rd_wr_not <= '1';   -- Read
        wait for clk_period;
        start <= '0';
        rd_wr_not <= '0';   -- Read
        CVT <= '1';         -- Hit
        
        for i in 1 to 4 loop
            wait for clk_period;
        end loop;
		--------
				 ------------------------------------------------------------
        -- Test 3: WRITE HIT
        --------------------------------------------------------------------
        start <= '1';
        rd_wr_not <= '0';   -- Write
        wait for clk_period;
        start <= '0';
        rd_wr_not <= '1';   -- Read
        CVT <= '1';         -- Hit
        for i in 1 to 5 loop
            wait for clk_period;
        end loop;
		 --------------------------------------------------------------------
        -- Test 4: WRITE MISS
        --------------------------------------------------------------------
        start <= '1';
        rd_wr_not <= '0';   -- Write
		CVT <= '0';
        wait for clk_period;
        start <= '0';
        rd_wr_not <= '1';   -- Read
        CVT <= '0';         -- Miss        
        for i in 1 to 5 loop
            wait for clk_period;
        end loop;
		

        --------------------------------------------------------------------
        -- Test 2: READ MISS
        --------------------------------------------------------------------
        start <= '1';
        rd_wr_not <= '1';   -- Read

        wait for clk_period;
       start <= '0';
        rd_wr_not <= '0';   -- Read
        CVT <= '0';         -- Miss	
        for i in 1 to 30 loop
            wait for clk_period;
        end loop;
        --------------------------------------------------------------------
        -- End Simulation
        -------------------------------------------------------------------- */
        start <= '0';
        rd_wr_not <= '0';   -- Write
        wait for clk_period;
        CVT <= '0';         -- Miss        
        for i in 1 to 30 loop
            wait for clk_period;
        end loop;
        wait for 20 ns;
    end process;

end behavior;
