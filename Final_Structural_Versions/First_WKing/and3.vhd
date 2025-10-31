
library IEEE;                      
use IEEE.std_logic_1164.all;       

entity and3 is                      
  port ( x	: in  std_logic;
         y	: in  std_logic;
         z	: in  std_logic;
         o	: out std_logic);
end and3;                          

architecture structural of and3 is 
component and2 
  port(input0   : in  std_logic;
        input1   : in  std_logic;
        output0   : out std_logic);
  end component;

  signal and1_net : std_logic;
begin 
and2_inst1 : and2
  port map(
    input0  => x,
    input1  => y,
    output0 => and1_net
  );
and2_inst2 : and2
  port map(
    input0  => and1_net,
    input1  => z,
    output0 => o
  );
	o <= x and y and z;
end structural;  