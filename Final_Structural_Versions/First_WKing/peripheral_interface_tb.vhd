--exec xvhdl cache_interface.vhd vt_interface.vhd tx8bit.vhd tx.vhd dff8bit_pos.vhd inv.vhd dff.vhd mux218.vhd mux212.vhd mux21.vhd peripheral_interface2.vhd peripheral_interface_tb.vhd

--exec xelab peripheral_interface_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;

entity peripheral_interface_tb is
end entity;

architecture sim of peripheral_interface_tb is

    -- DUT component declaration
    component peripheral_interface
        port (
            rd_wr            : in  std_logic;
            start            : in  std_logic;
            reset            : in  std_logic;
            cpu_address      : in  std_logic_vector(7 downto 0);
            main_mem_data_in : in  std_logic_vector(7 downto 0);
            cpu_data_in      : in  std_logic_vector(7 downto 0);
            cpu_data_out     : out std_logic_vector(7 downto 0);
            cache_mem_enable : in  std_logic;
            byte_address     : in  std_logic_vector(1 downto 0);
            byte_address_sel : in  std_logic;
            vt_reset         : in  std_logic;
            write_vt         : in  std_logic;
            data_sel         : in  std_logic;
            busy             : in  std_logic;
            cvt              : out std_logic
        );
    end component;

    -- DUT signals
    signal rd_wr            : std_logic := '0';
    signal start            : std_logic := '0';
    signal reset            : std_logic := '0';
    signal cpu_address      : std_logic_vector(7 downto 0) := (others => '0');
    signal main_mem_data_in : std_logic_vector(7 downto 0) := (others => '0');
    signal cpu_data_in      : std_logic_vector(7 downto 0) := (others => '0');
    signal cpu_data_out     : std_logic_vector(7 downto 0);
    signal cache_mem_enable : std_logic := '0';
    signal byte_address     : std_logic_vector(1 downto 0) := (others => '0');
    signal byte_address_sel : std_logic := '0';
    signal vt_reset         : std_logic := '0';
    signal write_vt         : std_logic := '0';
    signal data_sel         : std_logic := '0';
    signal busy             : std_logic := '0';
    signal cvt              : std_logic;

begin

    -- Instantiate DUT
    DUT: peripheral_interface
        port map (
            rd_wr            => rd_wr,
            start            => start,
            reset            => reset,
            cpu_address      => cpu_address,
            main_mem_data_in => main_mem_data_in,
            cpu_data_in      => cpu_data_in,
            cpu_data_out     => cpu_data_out,
            cache_mem_enable => cache_mem_enable,
            byte_address     => byte_address,
            byte_address_sel => byte_address_sel,
            vt_reset         => vt_reset,
            write_vt         => write_vt,
            data_sel         => data_sel,
            busy             => busy,
            cvt              => cvt
        );

    -------------------------------------------------------------------------
    -- Stimulus process
    -------------------------------------------------------------------------
    stim_proc : process
    begin
        reset <= '1';
        wait for 5 ns;
        vt_reset <= '1';
        wait for 5 ns;
        reset <= '0';
        vt_reset <= '0';

        -----------------------------------------------------------------
        -- TEST 1: Write cycle (Tag = "01", Block = "10", Byte = "01")
        -- Address = "00_01_10_01" = 0x19
        -----------------------------------------------------------------
        cpu_address <= "00000000";     -- Tag=01, Block=10, Byte=01
        cpu_data_in <= "00000000";          -- Example data
        main_mem_data_in <= "11111111";
        rd_wr <= '0';  
        wait for 1 ns;
        busy <= '1';
        wait for 5 ns;
        write_vt <= '1';       
        data_sel <= '0';               -- Select CPU input
        byte_address_sel <= '0';       -- Use address bits [1:0]
        wait for 1 ns;
        cache_mem_enable <= '1';
        wait for 1 ns;
        busy <= '0';
        wait for 1 ns;
        write_vt <= '0';
        cache_mem_enable <= '0';
        wait for 20 ns;

        -----------------------------------------------------------------
        -- TEST 2: Read cycle (Tag = "10", Block = "01", Byte = "11")
        -- Address = "00_10_01_11" = 0x27
        -----------------------------------------------------------------
        cpu_address <= "00000011";     -- Tag=01, Block=10, Byte=01
        cpu_data_in <= "00000000";          -- Example data
        rd_wr <= '1';  
        wait for 1 ns;
        busy <= '1';
        wait for 5 ns;       
        data_sel <= '0';               -- Select CPU input
        byte_address_sel <= '0';       -- Use address bits [1:0]
        wait for 1 ns;
        cache_mem_enable <= '1';
        wait for 1 ns;
        busy <= '0';
        wait for 1 ns;
        cache_mem_enable <= '0';
        wait for 20 ns;

        -----------------------------------------------------------------
        -- End of simulation
        -----------------------------------------------------------------
        wait;
    end process;

end architecture;
