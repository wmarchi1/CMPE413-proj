library IEEE;
use IEEE.std_logic_1164.all;

entity mux1618_data_out is
    port(
        byte_data_in0 : in std_logic_vector(7 downto 0);
        byte_data_in1 : in std_logic_vector(7 downto 0);
        byte_data_in2 : in std_logic_vector(7 downto 0);
        byte_data_in3 : in std_logic_vector(7 downto 0);
        byte_data_in4 : in std_logic_vector(7 downto 0);
        byte_data_in5 : in std_logic_vector(7 downto 0);
        byte_data_in6 : in std_logic_vector(7 downto 0);
        byte_data_in7 : in std_logic_vector(7 downto 0);
        byte_data_in8 : in std_logic_vector(7 downto 0);
        byte_data_in9 : in std_logic_vector(7 downto 0);
        byte_data_in10 : in std_logic_vector(7 downto 0);
        byte_data_in11 : in std_logic_vector(7 downto 0);
        byte_data_in12 : in std_logic_vector(7 downto 0);
        byte_data_in13 : in std_logic_vector(7 downto 0);
        byte_data_in14 : in std_logic_vector(7 downto 0);
        byte_data_in15 : in std_logic_vector(7 downto 0);
        mux1618_sel   : in  std_logic_vector(3 downto 0); -- expecting Ca[3:0]
        mux1618_out   : out std_logic_vector(7 downto 0) -- output
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

    signal bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7 : std_logic_vector(15 downto 0);

    signal ouput_vector : std_logic_vector(7 downto 0);
    signal b0, b1, b2, b3, b4, b5, b6, b7 : std_logic;

begin
    bit0 <= byte_data_in15(0) & byte_data_in14(0) & byte_data_in13(0) & byte_data_in12(0) & byte_data_in11(0) & byte_data_in10(0) & byte_data_in9(0) & byte_data_in8(0) & byte_data_in7(0) & byte_data_in6(0) & byte_data_in5(0) & byte_data_in4(0) & byte_data_in3(0) & byte_data_in2(0) & byte_data_in1(0) & byte_data_in0(0);

    bit1 <= byte_data_in15(1) & byte_data_in14(1) & byte_data_in13(1) & byte_data_in12(1) & byte_data_in11(1) & byte_data_in10(1) & byte_data_in9(1) & byte_data_in8(1) & byte_data_in7(1) & byte_data_in6(1) & byte_data_in5(1) & byte_data_in4(1) & byte_data_in3(1) & byte_data_in2(1) & byte_data_in1(1) & byte_data_in0(1);

    bit2 <= byte_data_in15(2) & byte_data_in14(2) & byte_data_in13(2) & byte_data_in12(2) & byte_data_in11(2) & byte_data_in10(2) & byte_data_in9(2) & byte_data_in8(2) & byte_data_in7(2) & byte_data_in6(2) & byte_data_in5(2) & byte_data_in4(2) & byte_data_in3(2) & byte_data_in2(2) & byte_data_in1(2) & byte_data_in0(2);

    bit3 <= byte_data_in15(3) & byte_data_in14(3) & byte_data_in13(3) & byte_data_in12(3) & byte_data_in11(3) & byte_data_in10(3) & byte_data_in9(3) & byte_data_in8(3) & byte_data_in7(3) & byte_data_in6(3) & byte_data_in5(3) & byte_data_in4(3) & byte_data_in3(3) & byte_data_in2(3) & byte_data_in1(3) & byte_data_in0(3);
    
    bit4 <= byte_data_in15(4) & byte_data_in14(4) & byte_data_in13(4) & byte_data_in12(4) & byte_data_in11(4) & byte_data_in10(4) & byte_data_in9(4) & byte_data_in8(4) & byte_data_in7(4) & byte_data_in6(4) & byte_data_in5(4) & byte_data_in4(4) & byte_data_in3(4) & byte_data_in2(4) & byte_data_in1(4) & byte_data_in0(4);

    bit5 <= byte_data_in15(5) & byte_data_in14(5) & byte_data_in13(5) & byte_data_in12(5) & byte_data_in11(5) & byte_data_in10(5) & byte_data_in9(5) & byte_data_in8(5) & byte_data_in7(5) & byte_data_in6(5) & byte_data_in5(5) & byte_data_in4(5) & byte_data_in3(5) & byte_data_in2(5) & byte_data_in1(5) & byte_data_in0(5);

    bit6 <= byte_data_in15(6) & byte_data_in14(6) & byte_data_in13(6) & byte_data_in12(6) & byte_data_in11(6) & byte_data_in10(6) & byte_data_in9(6) & byte_data_in8(6) & byte_data_in7(6) & byte_data_in6(6) & byte_data_in5(6) & byte_data_in4(6) & byte_data_in3(6) & byte_data_in2(6) & byte_data_in1(6) & byte_data_in0(6);

    bit7 <= byte_data_in15(7) & byte_data_in14(7) & byte_data_in13(7) & byte_data_in12(7) & byte_data_in11(7) & byte_data_in10(7) & byte_data_in9(7) & byte_data_in8(7) & byte_data_in7(7) & byte_data_in6(7) & byte_data_in5(7) & byte_data_in4(7) & byte_data_in3(7) & byte_data_in2(7) & byte_data_in1(7) & byte_data_in0(7);
            
    mux161_bit0 : mux161 
        port map (
            mux16_input => bit0,
            mux16_sel   => mux1618_sel,
            mux16_out   => b0
        );
    mux161_bit1 : mux161 
        port map (
            mux16_input => bit1,
            mux16_sel   => mux1618_sel,
            mux16_out   => b1
        );
    mux161_bit2 : mux161 
        port map (
            mux16_input => bit2,
            mux16_sel   => mux1618_sel,
            mux16_out   => b2
        );
    mux161_bit3 : mux161 
        port map (
            mux16_input => bit3,
            mux16_sel   => mux1618_sel,
            mux16_out   => b3
        );
     mux161_bit4 : mux161 
        port map (
            mux16_input => bit4,
            mux16_sel   => mux1618_sel,
            mux16_out   => b4
        );
    mux161_bit5 : mux161 
        port map (
            mux16_input => bit5,
            mux16_sel   => mux1618_sel,
            mux16_out   => b5
        );
    mux161_bit6 : mux161 
        port map (
            mux16_input => bit6,
            mux16_sel   => mux1618_sel,
            mux16_out   => b6
        );
    mux161_bit7 : mux161 
        port map (
            mux16_input => bit7,
            mux16_sel   => mux1618_sel,
            mux16_out   => b7
        );
    
    ouput_vector <= b7 & b6 & b5 & b4 & b3 & b2 & b1 & b0;

    mux1618_out <= ouput_vector;


end structural;