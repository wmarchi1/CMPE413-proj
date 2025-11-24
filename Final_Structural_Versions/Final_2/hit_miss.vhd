library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity hit_miss is 
    port(
        tag_in  : in  std_logic_vector(1 downto 0);
        tag_cache  : in  std_logic_vector(1 downto 0);
        valid  : in std_logic;
        hit_miss  : out std_logic);
end hit_miss;

architecture structural of hit_miss is 

component and2
  port (
    input0   : in  std_logic;
    input1   : in  std_logic;
    output0   : out std_logic);
end component;

component xnor2
    port(
        input1  : in std_logic;
        input2  : in std_logic;
        output  : out std_logic);
end component;

for and2_1: and2 use entity work.and2(structural);
for and2_2: and2 use entity work.and2(structural);
for xnor2_1: xnor2 use entity work.xnor2(structural);
for xnor2_2: xnor2 use entity work.xnor2(structural);

signal temp1, temp2, temp3 : std_logic;


begin
    xnor2_1: xnor2 port map (tag_in(0), tag_cache(0), temp1);
    xnor2_2: xnor2 port map (tag_in(1), tag_cache(1), temp2);
    and2_1: and2 port map (temp1, temp2, temp3);
    and2_2: and2 port map (valid, temp3, hit_miss);

end structural;
