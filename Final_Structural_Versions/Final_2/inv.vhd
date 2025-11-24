
library IEEE;                      
use IEEE.std_logic_1164.all;       

entity inv is                      
  port ( inv_input	: in  std_logic;
         inv_out: out std_logic);
end inv;                          

architecture structural of inv is 
begin 
	inv_out <= not(inv_input);
end structural;  
