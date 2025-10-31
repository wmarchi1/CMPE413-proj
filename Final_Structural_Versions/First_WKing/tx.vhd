library STD;
library IEEE;                      
use IEEE.std_logic_1164.all;       

entity tx is                      
  port ( sel   : in std_logic;
         selnot: in std_logic;
         tx_input : in std_logic;
         tx_output:out std_logic);
end tx;                          

architecture structural of tx is 

begin
	
  txprocess: process (sel, selnot, tx_input)                 
  begin                           
    if (sel = '1' and selnot = '0') then
      tx_output <= tx_input;
    else
      tx_output <= 'Z';
    end if;
  end process txprocess;        
 
end structural;