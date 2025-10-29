-- exec xvhdl inv.vhd mux21.vhd mux212.vhd mux218.vhd cache_interface.vhd vt_interface.vhd peripheral_interface2.vhd peripheral_interface2_tb.vhd

-- exec xelab peripheral_interface2_tb -debug typical -s sim_out


library IEEE;
use IEEE.std_logic_1164.all;

entity peripheral_interface2_tb is
end peripheral_interface2_tb;

architecture behavior of peripheral_interface2_tb is

    -- Component under test
    component peripheral_interface2
        port (
            -- chip io
            rd_wr : in std_logic;
            start : in std_logic;
            reset : in std_logic;
            cpu_address : in std_logic_vector(7 downto 0);
            main_mem_data_in : in std_logic_vector(7 downto 0);
            cpu_data_in : in std_logic_vector(7 downto 0);
            cpu_data_out : out std_logic_vector(7 downto 0);
            -- fsm io
            cache_mem_enable : in std_logic;
            byte_address    : in std_logic_vector(1 downto 0);
            byte_address_sel : in std_logic;
            vt_reset    : in std_logic;
            write_vt    : in std_logic;
            data_sel    : in std_logic;
            busy        : in std_logic;
            cvt         : out std_logic;

            -- testing outputs
            byte_off_mux_output : out std_logic_vector(1 downto 0);
            data_mux_output : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Testbench signals
    signal rd_wr_tb           : std_logic := '0';
    signal start_tb           : std_logic := '0';
    signal reset_tb           : std_logic := '0';
    signal cpu_address_tb     : std_logic_vector(7 downto 0) := (others => '0');
    signal main_mem_data_in_tb: std_logic_vector(7 downto 0) := (others => '0');
    signal cpu_data_in_tb     : std_logic_vector(7 downto 0) := (others => '0');
    signal cpu_data_out_tb    : std_logic_vector(7 downto 0);
    signal cache_mem_enable_tb: std_logic := '0';
    signal byte_address_tb    : std_logic_vector(1 downto 0) := (others => '0');
    signal byte_address_sel_tb: std_logic := '0';
    signal vt_reset_tb        : std_logic := '0';
    signal write_vt_tb        : std_logic := '0';
    signal data_sel_tb        : std_logic := '0';
    signal busy_tb            : std_logic := '0';
    signal cvt_tb             : std_logic;

    -- test output observation signals
    signal byte_off_mux_output_tb : std_logic_vector(1 downto 0);
    signal data_mux_output_tb     : std_logic_vector(7 downto 0);

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: peripheral_interface2
        port map(
            rd_wr => rd_wr_tb,
            start => start_tb,
            reset => reset_tb,
            cpu_address => cpu_address_tb,
            main_mem_data_in => main_mem_data_in_tb,
            cpu_data_in => cpu_data_in_tb,
            cpu_data_out => cpu_data_out_tb,
            cache_mem_enable => cache_mem_enable_tb,
            byte_address => byte_address_tb,
            byte_address_sel => byte_address_sel_tb,
            vt_reset => vt_reset_tb,
            write_vt => write_vt_tb,
            data_sel => data_sel_tb,
            busy => busy_tb,
            cvt => cvt_tb,
            byte_off_mux_output => byte_off_mux_output_tb,
            data_mux_output => data_mux_output_tb
        );

    ---------------------------------------------------------------------
    -- STIMULUS PROCESS
    ---------------------------------------------------------------------
    stim_proc: process
    begin
        -----------------------------------------------------------------
        -- Initial reset phase
        -----------------------------------------------------------------
        reset_tb <= '1';
        wait for 1 ns;
        vt_reset_tb <= '1';
        wait for 1 ns;
        reset_tb <= '0';
        vt_reset_tb <= '0';


        byte_address_tb <= "10";
        byte_address_sel_tb <= '0';
        data_sel_tb <= '0';
        -----------------------------------------------------------------
        -- Test 1: Select CPU data (data_sel = '0')
        -----------------------------------------------------------------
        cpu_data_in_tb <= "00000000";
        main_mem_data_in_tb <= "11111111";
        cpu_address_tb <= "00001100";  -- lower bits 00
        wait for 1 ns;
        write_vt_tb <= '1';
        wait for 1 ns;
        write_vt_tb <= '0';
        wait for 5 ns;

        -----------------------------------------------------------------
        -- Test 5: Drive cache interface signals
        -----------------------------------------------------------------
        rd_wr_tb <= '0';
        busy_tb <= '1';
        wait for 1 ns;
        cache_mem_enable_tb <= '1';
        wait for 1 ns;
        cache_mem_enable_tb <= '0';
        wait for 5 ns;

        rd_wr_tb <= '1';
        wait for 5 ns;
        cache_mem_enable_tb <= '1';
        wait for 1 ns;
        busy_tb <= '0';
        wait for 1 ns;
        cache_mem_enable_tb <= '1';
        wait for 5 ns;
-----------------------Now overwrite
        cpu_address_tb <= "00111100";
        data_sel_tb <= '1';
        wait for 1 ns;
        write_vt_tb <= '1';
        wait for 1 ns;
        write_vt_tb <= '0';
        wait for 5 ns;

        rd_wr_tb <= '0';
        busy_tb <= '1';
        wait for 1 ns;
        cache_mem_enable_tb <= '1';
        wait for 1 ns;
        cache_mem_enable_tb <= '0';
        wait for 5 ns;
-----------------------read again
        rd_wr_tb <= '1';
        wait for 5 ns;
        cache_mem_enable_tb <= '1';
        wait for 1 ns;
        busy_tb <= '0';
        wait for 1 ns;
        cache_mem_enable_tb <= '1';
        wait for 5 ns;

        cpu_address_tb <= "00001100";
        wait for 5 ns;
        -----------------------------------------------------------------
        -- Simulation End
        -----------------------------------------------------------------
        wait;
    end process;

end behavior;
