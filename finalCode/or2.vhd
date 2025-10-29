--
-- Entity: and2
-- Architecture : structural
-- Author: cpatel2
-- Created On: 11/11/2003
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
