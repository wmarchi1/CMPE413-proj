library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_cache_fsm is
end tb_cache_fsm;

architecture behavior of tb_cache_fsm is

    -- DUT component declaration
    component cache_fsm
        Port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            start      : in  std_logic;
            rd_wr_not  : in  std_logic;
            CVT        : in  std_logic;
            counter    : in  integer range 0 to 31;
            Busy       : out std_logic;
            MAIN_MEM_EN       : out std_logic;
            O_EN       : out std_logic;
            ST_SEL       : out std_logic;
            DATA_SEL       : out std_logic;
            M_EN       : out std_logic;
	    B_OFFSET         : out std_logic_vector(1 downto 0);
            CS         : out std_logic_vector(4 downto 0);
            Next_State        : out std_logic_vector(4 downto 0)
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
    signal MAIN_MEM_EN       : std_logic := '0';
    signal O_EN       : std_logic := '0';
    signal ST_SEL       : std_logic := '0';
    signal DATA_SEL       : std_logic := '0';
    signal M_EN       : std_logic := '0';
    signal B_OFFSET         : std_logic_vector(1 downto 0);
    signal CS, Next_State     : std_logic_vector(4 downto 0);

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    ------------------------------------------------------------------------
    -- Instantiate the DUT
    ------------------------------------------------------------------------
    uut: cache_fsm
        Port map (
            clk       => clk,
            reset     => reset,
            start     => start,
            rd_wr_not => rd_wr_not,
            CVT       => CVT,
            counter   => counter,
            Busy      => Busy,
            MAIN_MEM_EN      => MAIN_MEM_EN,
            O_EN      => O_EN,
            ST_SEL      => ST_SEL,
            DATA_SEL      => DATA_SEL,
            M_EN      => M_EN, 
            B_OFFSET  => B_OFFSET,                       
            CS        => CS,
            Next_State        => Next_State
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
    -- Counter process (increment on falling edge)
    ------------------------------------------------------------------------
    counter_proc : process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
        elsif falling_edge(clk) then
            if Busy = '1' then
                counter <= counter + 1;
            else
                counter <= 0;
            end if;
        end if;
    end process;

    ------------------------------------------------------------------------
    -- Stimulus process
    ------------------------------------------------------------------------
    stim_proc: process
    begin
        -- Reset sequence
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;

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

        --------------------------------------------------------------------
        -- Test 2: READ MISS
        --------------------------------------------------------------------
        start <= '1';
        rd_wr_not <= '1';   -- Read

        wait for clk_period;
        start <= '0';
        rd_wr_not <= '0';   -- Read
        CVT <= '0';         -- Miss	
        for i in 1 to 20 loop
            wait for clk_period;
        end loop;

        --------------------------------------------------------------------
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
        wait for clk_period;
        start <= '0';
        rd_wr_not <= '1';   -- Read
        CVT <= '0';         -- Miss        
        for i in 1 to 5 loop
            wait for clk_period;
        end loop;

        --------------------------------------------------------------------
        -- End Simulation
        --------------------------------------------------------------------
        wait for 20 ns;
    end process;

end behavior;
