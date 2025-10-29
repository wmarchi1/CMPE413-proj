--
-- Entity: or2
-- Architecture : structural
-- Author: Connor Cox
-- Created On: 2/6/2025
--
library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity or2 is

  port (
    input0   : in  std_logic;
    input1   : in  std_logic;
    output0   : out std_logic);
end or2;

architecture structural of or2 is

begin

  output0 <= input1 or input0;

end structural;
