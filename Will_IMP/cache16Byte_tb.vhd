--exec xvhdl and2.vhd inv.vhd selector.vhd tx.vhd dff.vhd cacheCell.vhd cacheByte.vhd cache16Byte.vhd cache16Byte_tb.vhd
--exec xelab cache16Byte_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cache16Byte_tb is
end cache16Byte_tb;

architecture sim of cache16Byte_tb is

    --------------------------------------------------------------------
    -- DUT Declaration
    --------------------------------------------------------------------
    component cache16Byte
        port(
            byte_data_in   : in  std_logic_vector(7 downto 0);
            rd_wr_sig      : in  std_logic;
            enable_vector  : in  std_logic_vector(15 downto 0);
            byte_data_out0 : out std_logic_vector(7 downto 0);
            byte_data_out1 : out std_logic_vector(7 downto 0);
            byte_data_out2 : out std_logic_vector(7 downto 0);
            byte_data_out3 : out std_logic_vector(7 downto 0);
            byte_data_out4 : out std_logic_vector(7 downto 0);
            byte_data_out5 : out std_logic_vector(7 downto 0);
            byte_data_out6 : out std_logic_vector(7 downto 0);
            byte_data_out7 : out std_logic_vector(7 downto 0);
            byte_data_out8 : out std_logic_vector(7 downto 0);
            byte_data_out9 : out std_logic_vector(7 downto 0);
            byte_data_out10 : out std_logic_vector(7 downto 0);
            byte_data_out11 : out std_logic_vector(7 downto 0);
            byte_data_out12 : out std_logic_vector(7 downto 0);
            byte_data_out13 : out std_logic_vector(7 downto 0);
            byte_data_out14 : out std_logic_vector(7 downto 0);
            byte_data_out15 : out std_logic_vector(7 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Signals
    --------------------------------------------------------------------
    signal tb_data_in        : std_logic_vector(7 downto 0) := (others => '0');
    signal tb_rd_wr_sig      : std_logic := '0';
    signal tb_enable_vector  : std_logic_vector(15 downto 0) := (others => '0');

    signal byte_data_out0  : std_logic_vector(7 downto 0);
    signal byte_data_out1  : std_logic_vector(7 downto 0);
    signal byte_data_out2  : std_logic_vector(7 downto 0);
    signal byte_data_out3  : std_logic_vector(7 downto 0);
    signal byte_data_out4  : std_logic_vector(7 downto 0);
    signal byte_data_out5  : std_logic_vector(7 downto 0);
    signal byte_data_out6  : std_logic_vector(7 downto 0);
    signal byte_data_out7  : std_logic_vector(7 downto 0);
    signal byte_data_out8  : std_logic_vector(7 downto 0);
    signal byte_data_out9  : std_logic_vector(7 downto 0);
    signal byte_data_out10 : std_logic_vector(7 downto 0);
    signal byte_data_out11 : std_logic_vector(7 downto 0);
    signal byte_data_out12 : std_logic_vector(7 downto 0);
    signal byte_data_out13 : std_logic_vector(7 downto 0);
    signal byte_data_out14 : std_logic_vector(7 downto 0);
    signal byte_data_out15 : std_logic_vector(7 downto 0);

begin
    --------------------------------------------------------------------
    -- DUT instantiation
    --------------------------------------------------------------------
    DUT: cache16Byte
        port map(
            byte_data_in   => tb_data_in,
            rd_wr_sig      => tb_rd_wr_sig,
            enable_vector  => tb_enable_vector,
            byte_data_out0 => byte_data_out0,
            byte_data_out1 => byte_data_out1,
            byte_data_out2 => byte_data_out2,
            byte_data_out3 => byte_data_out3,
            byte_data_out4 => byte_data_out4,
            byte_data_out5 => byte_data_out5,
            byte_data_out6 => byte_data_out6,
            byte_data_out7 => byte_data_out7,
            byte_data_out8 => byte_data_out8,
            byte_data_out9 => byte_data_out9,
            byte_data_out10 => byte_data_out10,
            byte_data_out11 => byte_data_out11,
            byte_data_out12 => byte_data_out12,
            byte_data_out13 => byte_data_out13,
            byte_data_out14 => byte_data_out14,
            byte_data_out15 => byte_data_out15
        );

    --------------------------------------------------------------------
    -- TEST PROCESS (no loops)
    --------------------------------------------------------------------
    process
    begin
        --report "Starting manual testbench for cache16Byte" severity note;

        ----------------------------------------------------------------
        -- TEST 1 : Write to byte 0
        ----------------------------------------------------------------
        tb_data_in <= x"AA";
        tb_rd_wr_sig <= '0';  -- write
        wait for 1 ns;
        tb_enable_vector <= "0000000000000001";
        wait for 10 ns;
        tb_data_in <= x"00";
        wait for 1 ns;
        tb_rd_wr_sig <= '1';  -- read
        wait for 10 ns;
        --report "Byte0 OUT = " & to_hstring(byte_data_out0);

        ----------------------------------------------------------------
        -- TEST 2 : Write to byte 4
        ----------------------------------------------------------------
        tb_data_in <= x"BB";
        tb_rd_wr_sig <= '0';  -- write
        wait for 1 ns;
        tb_enable_vector <= "0000000000010000";

        wait for 10 ns;
        tb_data_in <= x"00";
        wait for 1 ns;
        tb_rd_wr_sig <= '1';
        wait for 10 ns;
        --report "Byte4 OUT = " & to_hstring(byte_data_out4);

        ----------------------------------------------------------------
        -- TEST 3 : Write to byte 7
        ----------------------------------------------------------------
        tb_data_in <= x"CC";
        tb_rd_wr_sig <= '0';  -- write
        wait for 1 ns;

        tb_enable_vector <= "0000000100000000";
        wait for 10 ns;
        tb_data_in <= x"00";
        wait for 1 ns;
        tb_rd_wr_sig <= '1';
        wait for 10 ns;
        --report "Byte7 OUT = " & to_hstring(byte_data_out7);

        ----------------------------------------------------------------
        -- TEST 4 : Write to byte 10
        ----------------------------------------------------------------
        tb_data_in <= x"DD";
        tb_rd_wr_sig <= '0';  -- write
        wait for 1 ns;
        tb_enable_vector <= "0001000000000000";
        wait for 10 ns;
        tb_data_in <= x"00";
        wait for 1 ns;
        tb_rd_wr_sig <= '1';
        wait for 10 ns;
        --report "Byte10 OUT = " & to_hstring(byte_data_out10);

        ----------------------------------------------------------------
        -- TEST 5 : Write to byte 15
        ----------------------------------------------------------------
        tb_data_in <= x"EE";
        tb_rd_wr_sig <= '0';  -- write
        wait for 1 ns;

        tb_enable_vector <= "1000000000000000";
        wait for 10 ns;
        tb_data_in <= x"00";
        wait for 1 ns;
        tb_rd_wr_sig <= '1';
        wait for 10 ns;
        --report "Byte15 OUT = " & to_hstring(byte_data_out15);

        ----------------------------------------------------------------
        --report "✅ All 5 manual cache16Byte tests completed." severity note;
        wait;
    end process;

end sim;
