library IEEE;
use IEEE.std_logic_1164.all;

entity nand2 is
    port(
        input0  : in std_logic;
        input1  : in std_logic;
        output0 : out std_logic
    );
end nand2;

architecture structural of nand2 is
begin
    output0 <= not (input0 and input1);
end structural;
