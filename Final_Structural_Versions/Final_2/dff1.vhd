--
-- Entity: negative edge triggered D flip-flop (dff)
-- Architecture : structural
-- Author: 
--

library STD;
library IEEE;                      
use IEEE.std_logic_1164.all;       

entity dff1 is                      
  port ( d   : in  std_logic;
         clk : in  std_logic;
         q   : out std_logic--;
         --qbar: out std_logic
         ); 
end dff1;                          

architecture structural of dff1 is 

  
begin
  
  output: process                 

  begin                           
    wait until ( clk'EVENT and clk = '1' ); 
    q <= d;
    --qbar <= not d ;
  end process output;        

                             
end structural;  


