--exec xvhdl mux21.vhd mux212.vhd mux212_tb.vhd

--exec xelab mux212_tb -debug typical -s sim_out

--exec xsim sim_out -gui

library IEEE;
use IEEE.std_logic_1164.all;

entity mux218 is
    port(
        input0   : in  std_logic_vector(7 downto 0);  -- Input 0 (sel 0)
        input1   : in  std_logic_vector(7 downto 0);  -- Input 1 (sel 1)
        sel_bit  : in  std_logic;  -- Select
        y   : out std_logic_vector(7 downto 0)   -- Output
    );
end mux218;

architecture structural of mux218 is
    component mux21
    port(
        a   : in  std_logic;  -- Input 0 (sel 0)
        b   : in  std_logic;  -- Input 1 (sel 1)
        sel : in  std_logic;  -- Select
        y   : out std_logic   -- Output
    );
    end component;

    signal output_vector : std_logic_vector(7 downto 0);
    signal bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7 : std_logic;


begin

    mux21_0 : mux21
        port map(
            a => input0(0),
            b => input1(0),
            sel => sel_bit,
            y => y(0)
        );

    mux21_1 : mux21
        port map(
            a => input0(1),
            b => input1(1),
            sel => sel_bit,
            y => y(1)
        );
    
    mux21_2 : mux21
        port map(
            a => input0(2),
            b => input1(2),
            sel => sel_bit,
            y => y(2)
        );
    
    mux21_3 : mux21
        port map(
            a => input0(3),
            b => input1(3),
            sel => sel_bit,
            y => y(3)
        );

    mux21_4 : mux21
        port map(
            a => input0(4),
            b => input1(4),
            sel => sel_bit,
            y => y(4)
        );

    mux21_5 : mux21
        port map(
            a => input0(5),
            b => input1(5),
            sel => sel_bit,
            y => y(5)
        );
    
    mux21_6 : mux21
        port map(
            a => input0(6),
            b => input1(6),
            sel => sel_bit,
            y => y(6)
        );
    
    mux21_7 : mux21
        port map(
            a => input0(7),
            b => input1(7),
            sel => sel_bit,
            y => y(7)
        );

end structural;