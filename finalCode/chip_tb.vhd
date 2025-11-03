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
            cpu_data_in   : inout  std_logic_vector(7 downto 0);---******
            --cpu_data_out   : out  std_logic_vector(7 downto 0);---******
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
        );
    end component;

    -- Signals
    signal clk_tb        : std_logic := '0';
    signal cpu_add_tb    : std_logic_vector(7 downto 0) := (others => 'Z');
    signal cpu_data_tb   : std_logic_vector(7 downto 0) := (others => 'Z'); -- '0' was Z
    --signal cpu_data_out_tb: std_logic_vector(7 downto 0);-----********
    signal cpu_rd_wrn_tb : std_logic := 'Z';
    signal start_tb      : std_logic := '0';
    signal reset_tb      : std_logic := '0';
    signal mem_data_tb   : std_logic_vector(7 downto 0) := (others => '0');
    signal busy_tb       : std_logic;
    signal mem_en_tb     : std_logic;
    signal mem_add_tb    : std_logic_vector(7 downto 0);
    signal Vdd_tb        : std_logic := '1';
    signal Gnd_tb        : std_logic := '0';

    constant clk_period : time := 10 ns;

begin
    -- Instantiate DUT
    uut: chip
        port map (
            cpu_add => cpu_add_tb,
            cpu_data_in => cpu_data_tb,
            --cpu_data_out => cpu_data_out_tb,-----************
            cpu_rd_wrn => cpu_rd_wrn_tb,
            start => start_tb,
            clk => clk_tb,
            reset => reset_tb,
            mem_data => mem_data_tb,
            Vdd => Vdd_tb,
            Gnd => Gnd_tb,
            busy => busy_tb,
            mem_en => mem_en_tb,
            mem_add => mem_add_tb
        );

    -- Clock process
    clk_process : process
    begin
        clk_tb <= '1';
        wait for clk_period / 2;
        clk_tb <= '0';
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
        --wait for clk_period;

        ------------------------------------------------------
        -- READ MISS: Address 0x00 (causes memory fetch)
        ------------------------------------------------------
        --wait for clk_period;
        cpu_rd_wrn_tb <= '1';
        cpu_add_tb <= x"01";
        cpu_data_tb <= x"11";
        start_tb <= '1';
        wait for clk_period;
        cpu_data_tb <= "ZZZZZZZZ";
        cpu_add_tb <= "ZZZZZZZZ";
        cpu_rd_wrn_tb <= 'Z'; --
        start_tb <= '0';

        -- Simulate memory returning data after 8 cycles
        wait for 10 * clk_period;
        force_write_tb <= '0';------------
        mem_data_tb <= x"AA";
        wait for 2 * clk_period;
        mem_data_tb <= x"BB";
        wait for 2 * clk_period;
        mem_data_tb <= x"CC";
        wait for 2 * clk_period;
        mem_data_tb <= x"DD";
        wait for 2 * clk_period;
        force_write_tb <= '1';-------------
        mem_data_tb <= (others => '0');
        wait for 8 * clk_period;

        ------------------------------------------------------
        -- WRITE HIT: Address 0x00, data = 0xFF
        ------------------------------------------------------
        --cpu_data_tb <= x"FF";
        wait for clk_period;
        cpu_rd_wrn_tb <= '0';
        cpu_data_tb <= x"FF";
        cpu_add_tb <= x"01";
        start_tb <= '1';
        wait for clk_period;
        --cpu_data_tb <= x"FF";
        cpu_rd_wrn_tb <= 'Z'; --
        cpu_data_tb <= "ZZZZZZZZ";
        cpu_add_tb <= "ZZZZZZZZ";
        start_tb <= '0';

        wait for 5 * clk_period;

        ------------------------------------------------------
        -- READ HIT: Address 0x03
        ------------------------------------------------------
        wait for clk_period;
        cpu_rd_wrn_tb <= '1';
        cpu_add_tb <= x"01";
        cpu_data_tb <= x"AA";
        start_tb <= '1';
        wait for clk_period;
        cpu_data_tb <= "ZZZZZZZZ";
        cpu_add_tb <= "ZZZZZZZZ";
        cpu_rd_wrn_tb <= 'Z'; --
        start_tb <= '0';

        wait for 5 * clk_period;

        ------------------------------------------------------
        -- WRITE MISS: Address 0xFF, data = 0xAA
        ------------------------------------------------------
        cpu_rd_wrn_tb <= '0';
        cpu_add_tb <= x"FA";
        cpu_data_tb <= x"55";
        start_tb <= '1';
        wait for clk_period;
        cpu_data_tb <= "ZZZZZZZZ";
        cpu_add_tb <= "ZZZZZZZZ";
        cpu_rd_wrn_tb <= 'Z'; --
        start_tb <= '0';

        wait for 5 * clk_period;

        -- READ HIT

        cpu_rd_wrn_tb <= '1';
        cpu_add_tb <= x"02";
        cpu_data_tb <= x"55";
        start_tb <= '1';
        wait for clk_period;
        cpu_data_tb <= "ZZZZZZZZ";
        cpu_add_tb <= "ZZZZZZZZ";
        cpu_rd_wrn_tb <= 'Z'; --
        start_tb <= '0';

        wait for 5 * clk_period;

        cpu_rd_wrn_tb <= '0';
        cpu_add_tb <= x"02";
        cpu_data_tb <= x"77";
        start_tb <= '1';
        wait for clk_period;
        cpu_data_tb <= "ZZZZZZZZ";
        cpu_add_tb <= "ZZZZZZZZ";
        cpu_rd_wrn_tb <= 'Z'; --
        start_tb <= '0';

        wait for 5 * clk_period;

        cpu_rd_wrn_tb <= '1';
        cpu_add_tb <= x"02";
        cpu_data_tb <= x"00";
        start_tb <= '1';
        wait for clk_period;
        cpu_data_tb <= "ZZZZZZZZ";
        cpu_add_tb <= "ZZZZZZZZ";
        cpu_rd_wrn_tb <= 'Z'; --
        start_tb <= '0';

        wait for 5 * clk_period;

        --wait for clk_period;
        cpu_rd_wrn_tb <= '1';
        cpu_add_tb <= x"AA";
        cpu_data_tb <= x"00";
        start_tb <= '1';
        wait for clk_period;
        cpu_data_tb <= "ZZZZZZZZ";
        cpu_add_tb <= "ZZZZZZZZ";
        cpu_rd_wrn_tb <= 'Z'; --
        start_tb <= '0';

        -- Simulate memory returning data after 8 cycles
        wait for 10 * clk_period;
        force_write_tb <= '0';------------
        mem_data_tb <= x"11";
        wait for 2 * clk_period;
        mem_data_tb <= x"22";
        wait for 2 * clk_period;
        mem_data_tb <= x"33";
        wait for 2 * clk_period;
        mem_data_tb <= x"44";
        wait for 2 * clk_period;
        force_write_tb <= '1';-------------
        mem_data_tb <= (others => '0');
        wait for 8 * clk_period;
        ------------------------------------------------------
        -- End of simulation
        ------------------------------------------------------
        wait for 5 * clk_period;
        assert false report "Simulation Finished Successfully" severity failure;
        --assert false report "Simulation Finished Successfully" severity note;
        wait;
    end process;
end behavior;