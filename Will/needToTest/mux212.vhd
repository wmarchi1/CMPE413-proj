library IEEE;
use IEEE.std_logic_1164.all;

entity mux212 is
    port(
        input0   : in  std_logic_vector(1 downto 0);  -- Input 0 (sel 0)
        input1   : in  std_logic_vector(1 downto 0);  -- Input 1 (sel 1)
        sel_bit  : in  std_logic;  -- Select
        y   : out std_logic(1 downto 0)   -- Output
    );
end mux212;

architecture structural of mux212 is
    component mux21
    port(
        a   : in  std_logic;  -- Input 0 (sel 0)
        b   : in  std_logic;  -- Input 1 (sel 1)
        sel : in  std_logic;  -- Select
        y   : out std_logic   -- Output
    );
    end component;

    signal output_vector : std_logic_vector(1 downto 0);
    signal bit0, bit1 : std_logic;


begin

    mux21_0 : mux21
        port map(
            a => input0(0),
            b => input1(0),
            sel => sel_bit,
            y => bit0
        );

    mux21_1 : mux21
        port map(
            a => input0(1),
            b => input1(1),
            sel => sel_bit,
            y => bit1
        );

    output_vector <= bit1 & bit0;
    

end structural;
