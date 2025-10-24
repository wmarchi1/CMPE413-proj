library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity xnor2 is 
    port(
        input1  : in std_logic;
        input2  : in std_logic;
        output  : out std_logic);
end xnor2;

architecture structural of xnor2 is 

component and2
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;

component or2
  port (
    input1   : in  std_logic;
    input2   : in  std_logic;
    output   : out std_logic);
end component;

component inv
  port (
    input   : in std_logic;
    inv_out   : out std_logic);
end component;

for and2_1, and2_2: and2 use entity work.and2(structural);
for or2_1: or2 use entity work.or2(structural);
for inverter_1, inverter_2: inv use entity work.inv(structural);

signal temp1, temp2 : std_logic;
signal input1_not, input2_not : std_logic;


begin

    inverter_1: inv port map (input1, input1_not);
    inverter_2: inv port map (input2, input2_not);
    and2_1: and2 port map (input1, input2, temp1);
    and2_2: and2 port map (input1_not, input2_not, temp2);
    or2_1: or2 port map (temp1, temp2, output);

end structural;
