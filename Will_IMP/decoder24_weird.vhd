library IEEE;                      
use IEEE.std_logic_1164.all;       

entity decoder24_weird is                      
  port ( 
    a	: in  std_logic_vector(1 downto 0);
    reset	: in  std_logic;
    y	: out std_logic_vector(3 downto 0)
  );
end decoder24_weird;                          

architecture structural of decoder24_weird is 

component inv
port(
	  inv_input	: in std_logic;
	  inv_out	: out std_logic
);
end component;	

component and2
  port (
    input0   : in  std_logic;
    input1   : in  std_logic;
    output0   : out std_logic);
end component;

component or2 
  port (
    input0   : in  std_logic;
    input1   : in  std_logic;
    output0   : out std_logic);
end component;

for and3_1 : and2 use entity work.and2(structural);
for and3_2 : and2 use entity work.and2(structural);
for and3_3 : and2 use entity work.and2(structural);
for and3_4 : and2 use entity work.and2(structural);

for inv_1 : inv use entity work.inv(structural);
for inv_2 : inv use entity work.inv(structural);

signal n_a0 : std_logic;	
signal n_a1 : std_logic;
signal o0, o1, o2, o3 : std_logic;

begin

inv_1 : inv port map (a(0), n_a0);
inv_2 : inv port map (a(1), n_a1);

and3_1 : and2 port map ( n_a1 , n_a0, o0);
or2_inst0 : or2
    port map(
        input0 => o0,
        input1 => reset,
        output0 => y(0)
    );
and3_2 : and2 port map ( n_a1, a(0), o1);
or2_inst1 : or2
    port map(
        input0 => o1,
        input1 => reset,
        output0 => y(1)
    );
and3_3 : and2 port map ( a(1), n_a0, o2);
or2_inst2 : or2
    port map(
        input0 => o2,
        input1 => reset,
        output0 => y(2)
    );
and3_4 : and2 port map ( a(1), a(0), o3);
or2_inst3 : or2
    port map(
        input0 => o3,
        input1 => reset,
        output0 => y(3)
    );

end structural;  
