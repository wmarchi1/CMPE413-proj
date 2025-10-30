library STD;
library IEEE;                      
use IEEE.std_logic_1164.all;       

entity tx8bit is                      
  port ( sel   : in std_logic;
         selnot: in std_logic;
         tx_input : in std_logic_vector(7 downto 0);
         tx_output:out std_logic_vector(7 downto 0));
end tx8bit;                          

architecture structural of tx8bit is 
component tx
  port(
    sel   : in std_logic;
    selnot: in std_logic;
    tx_input : in std_logic;
    tx_output:out std_logic
  );
  end component;
begin   
  tx_inst0: tx
        port map(
            sel       => sel,
            selnot    => selnot,
            tx_input  => tx_input(0), 
            tx_output => tx_output(0)
        );
  tx_inst1: tx
        port map(
            sel       => sel,
            selnot    => selnot,
            tx_input  => tx_input(1), 
            tx_output => tx_output(1)
        );
  tx_inst2: tx
        port map(
            sel       => sel,
            selnot    => selnot,
            tx_input  => tx_input(2), 
            tx_output => tx_output(2)
        );
  tx_inst3: tx
        port map(
            sel       => sel,
            selnot    => selnot,
            tx_input  => tx_input(3), 
            tx_output => tx_output(3)
        );
    tx_inst4: tx
        port map(
            sel       => sel,
            selnot    => selnot,
            tx_input  => tx_input(4), 
            tx_output => tx_output(4)
        );
  tx_inst5: tx
        port map(
            sel       => sel,
            selnot    => selnot,
            tx_input  => tx_input(5), 
            tx_output => tx_output(5)
        );
  tx_inst6: tx
        port map(
            sel       => sel,
            selnot    => selnot,
            tx_input  => tx_input(6), 
            tx_output => tx_output(6)
        );
  tx_inst7: tx
        port map(
            sel       => sel,
            selnot    => selnot,
            tx_input  => tx_input(7), 
            tx_output => tx_output(7)
        );
    
end structural;
