library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_chip is
end tb_chip;

architecture behavior of tb_chip is

    -- DUT component declaration
    component chip
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            start      : in  std_logic;
            cpu_rd_wrn : in  std_logic;
            cpu_add    : in  std_logic_vector(7 downto 0);  -- 8-bit
            cpu_data   : inout std_logic_vector(7 downto 0);
            mem_data   : in  std_logic_vector(7 downto 0);
            busy       : out std_logic;
            mem_en     : out std_logic;
            mem_add    : out std_logic_vector(7 downto 0)   -- 8-bit
        );
    end component;

    -- Testbench signals
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal start      : std_logic := '0';
    signal cpu_rd_wrn : std_logic := '0';
    signal cpu_add    : std_logic_vector(7 downto 0) := (others => '0');  -- 8-bit
    signal cpu_data   : std_logic_vector(7 downto 0) := (others => '0');
    signal mem_data   : std_logic_vector(7 downto 0) := (others => '0');
    signal busy       : std_logic;
    signal mem_en     : std_logic;
    signal mem_add    : std_logic_vector(7 downto 0);  -- 8-bit

    constant clk_period : time := 10 ns;

begin

    ------------------------------------------------------------------------
    -- Instantiate DUT
    ------------------------------------------------------------------------
    uut: chip
        port map (
            clk        => clk,
            reset      => reset,
            start      => start,
            cpu_rd_wrn => cpu_rd_wrn,
            cpu_add    => cpu_add,
            cpu_data   => cpu_data,
            mem_data   => mem_data,
            busy       => busy,
            mem_en     => mem_en,
            mem_add    => mem_add
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
    -- Stimulus process: READ MISS -> READ HIT -> WRITE HIT
    ------------------------------------------------------------------------
    stim_proc: process
    begin
        -- Reset sequence
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';
        wait for clk_period * 2;

        -- Common address for all operations
        cpu_add <= x"0C";  -- 8-bit address (hex 0C = decimal 12)

        --------------------------------------------------------------------
        -- 1) READ MISS
        --------------------------------------------------------------------
        start <= '1';
        cpu_rd_wrn <= '1';   -- Read
        cpu_data <= (others => 'Z');
        wait for clk_period;
        start <= '0';
        -- Simulate memory providing data bytes sequentially
        wait until mem_en = '1';
        mem_add <= cpu_add;  -- Output memory address same as CPU address
        wait for clk_period * 8; mem_data <= x"01";
        wait for clk_period * 2; mem_data <= x"02";
        wait for clk_period * 2; mem_data <= x"03";
        wait for clk_period * 2; mem_data <= x"04";
        wait until busy = '0';
        wait for clk_period;

        for i in 1 to 4 loop
            wait for clk_period;
        end loop;

        --------------------------------------------------------------------
        -- 2) READ HIT
        --------------------------------------------------------------------
        start <= '1';
        cpu_rd_wrn <= '1';   -- Read
        cpu_data <= (others => 'Z');
        wait for clk_period;
        start <= '0';
        wait until busy = '0';
        wait for clk_period;

        for i in 1 to 4 loop
            wait for clk_period;
        end loop;

        --------------------------------------------------------------------
        -- 3) WRITE HIT
        --------------------------------------------------------------------
        start <= '1';
        cpu_rd_wrn <= '0';   -- Write
        cpu_data <= x"F0";   -- Data to write
        wait for clk_period;
        start <= '0';
        wait until busy = '0';
        wait for clk_period;

        for i in 1 to 4 loop
            wait for clk_period;
        end loop;

        --------------------------------------------------------------------
        -- End simulation
        --------------------------------------------------------------------
        wait for clk_period * 10;
        wait;
    end process;

end behavior;
