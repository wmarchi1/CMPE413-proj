--exec xvhdl and2.vhd inv.vhd selector.vhd tx.vhd dff.vhd cacheCell.vhd cacheByte.vhd cache16Byte.vhd cache16Byte_tb.vhd
--exec xelab cache16Byte_tb -debug typical -s sim_out

--exec xvhdl and2.vhd and3.vhd inv.vhd decoder24.vhd addressToCacheE.vhd addressToCacheE_tb.vhd
--exec xelab addressToCacheE_tb -debug typical -s sim_out

--exec xvhdl and2.vhd or2.vhd inv.vhd mux21.vhd mux21_tb.vhd mux42.vhd mux161.vhd mux1618_data_out.vhd mux1618_data_out_tb.vhd
--exec xelab mux1618_data_out_tb -debug typical -s sim_out

--exec xvhdl and2.vhd and3.vhd or2.vhd inv.vhd selector.vhd tx.vhd dff.vhd cacheCell.vhd cacheByte.vhd cache16Byte.vhd decoder24.vhd addressToCacheE.vhd mux21.vhd mux21_tb.vhd mux42.vhd mux161.vhd mux1618_data_out.vhd cache_interface.vhd cache_interface_tb.vhd
--exec xelab cache_interface_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cache_interface_tb is
end cache_interface_tb;

architecture tb of cache_interface_tb is

    --------------------------------------------------------------------
    -- DUT Declaration
    --------------------------------------------------------------------
    component cache_interface
        port ( 
            rd_wr        : in std_logic;
            mem_enable   : in std_logic;
            block_off    : in std_logic_vector(1 downto 0);
            byte_off     : in std_logic_vector(1 downto 0);
            data_input   : in std_logic_vector(7 downto 0);
            data_output  : out std_logic_vector(7 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Signals
    --------------------------------------------------------------------
    signal rd_wr       : std_logic := '0';  -- '0' = write, '1' = read
    signal mem_enable  : std_logic := '0';
    signal block_off   : std_logic_vector(1 downto 0) := "00";
    signal byte_off    : std_logic_vector(1 downto 0) := "00";
    signal data_input  : std_logic_vector(7 downto 0) := (others => '0');
    signal data_output : std_logic_vector(7 downto 0);

begin

    --------------------------------------------------------------------
    -- DUT Instantiation
    --------------------------------------------------------------------
    DUT: cache_interface
        port map(
            rd_wr       => rd_wr,
            mem_enable  => mem_enable,
            block_off   => block_off,
            byte_off    => byte_off,
            data_input  => data_input,
            data_output => data_output
        );

    --------------------------------------------------------------------
    -- Test Process
    --------------------------------------------------------------------
    process
    begin
        ----------------------------------------------------------------
        -- TEST 1: Write to address 0000, then read back
        ----------------------------------------------------------------
        
        rd_wr      <= '0'; -- Write
        block_off  <= "00";
        byte_off   <= "00";
        data_input <= x"A1";
        wait for 18 ns;
        data_input <= x"00";
        wait for 2 ns;

        rd_wr <= '1'; -- Read
        wait for 10 ns;

        ----------------------------------------------------------------
        -- TEST 2: Write to address 0101, then read back
        ----------------------------------------------------------------
        rd_wr      <= '0';
        block_off  <= "01";
        byte_off   <= "01";
        data_input <= x"B2";
        wait for 18 ns;
        data_input <= x"00";
        wait for 2 ns;

        rd_wr <= '1';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- TEST 3: Write to address 1010, then read back
        ----------------------------------------------------------------
        rd_wr      <= '0';
        block_off  <= "10";
        byte_off   <= "10";
        data_input <= x"C3";
        wait for 18 ns;
        data_input <= x"00";
        wait for 2 ns;

        rd_wr <= '1';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- TEST 4: Write to address 1111, then read back
        ----------------------------------------------------------------
        rd_wr      <= '0';
        block_off  <= "11";
        byte_off   <= "11";
        data_input <= x"D4";
        wait for 18 ns;
        data_input <= x"00";
        wait for 2 ns;

        rd_wr <= '1';
        wait for 10 ns;

        ----------------------------------------------------------------
        -- TEST 5: Disable memory and attempt read
        ----------------------------------------------------------------
        mem_enable <= '0';
        rd_wr      <= '1';
        wait for 20 ns;

        wait;
    end process;

end tb;
