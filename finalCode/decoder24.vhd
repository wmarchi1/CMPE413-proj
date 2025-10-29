library IEEE;                      
use IEEE.std_logic_1164.all;       

entity decoder24 is                      
  port ( 
    a	: in  std_logic_vector(1 downto 0);
    e	: in  std_logic;
    y	: out std_logic_vector(3 downto 0)
  );
end decoder24;                          

architecture structural of decoder24 is 
component and3
port (
    x	: in  std_logic;
    y	: in  std_logic;
    z	: in  std_logic;
    o	: out std_logic
);
end component;

component inv
port(
	  inv_input	: in std_logic;
	  inv_out	: out std_logic
);
end component;	

for and3_1 : and3 use entity work.and3(structural);
for and3_2 : and3 use entity work.and3(structural);
for and3_3 : and3 use entity work.and3(structural);
for and3_4 : and3 use entity work.and3(structural);

for inv_1 : inv use entity work.inv(structural);
for inv_2 : inv use entity work.inv(structural);

signal n_a0 : std_logic;	
signal n_a1 : std_logic;

begin

inv_1 : inv port map (a(0), n_a0);
inv_2 : inv port map (a(1), n_a1);

and3_1 : and3 port map ( n_a1 , n_a0, e, y(0));
and3_2 : and3 port map ( n_a1, a(0), e, y(1));
and3_3 : and3 port map ( a(1), n_a0, e, y(2));
and3_4 : and3 port map ( a(1), a(0), e, y(3));

end structural;  
