library IEEE;
use IEEE.std_logic_1164.all;

entity mux1618_data_out is
    port(
        mux16_input : in  std_logic_vector(15 downto 0); -- 16 data inputs
        mux16_sel   : in  std_logic_vector(3 downto 0); -- 4-bit select
        mux16_out   : out std_logic -- output
    );
end mux1618_data_out;

architecture structural of mux1618_data_out is

    component mux161
        port(
            mux16_input : in  std_logic_vector(15 downto 0); -- 16 data inputs
            mux16_sel   : in  std_logic_vector(3 downto 0); -- 4-bit select
            mux16_out   : out std_logic -- output
        );
    end component;

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
    signal bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7 : std_logic_vector(15 downto 0);

begin
    bit0 <= byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0) & byte_data_out0(0);
    mux161_bit0 : mux161 
        port map (
            mux16_input => 
            mux16_sel   : in  std_logic_vector(3 downto 0); -- 4-bit select
            mux16_out   : out std_logic -- output
        );


end structural;