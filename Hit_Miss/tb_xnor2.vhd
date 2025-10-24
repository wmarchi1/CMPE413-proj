library IEEE;
use IEEE.std_logic_1164.all;

entity tb_xnor2 is
end tb_xnor2;

architecture behavioral of tb_xnor2 is
  component xnor2
    port (
        input1  : in std_logic;
        input2  : in std_logic;
        output  : out std_logic);
  end component;

  signal A0, A1, Y : std_logic := '0';

begin
  UUT: xnor2 port map(
    input1 => A0,
    input2 => A1,
    output => Y
  );

  stim_proc: process
  begin
    A0 <= '0'; A1 <= '0'; wait for 10 ns;
    A0 <= '1'; A1 <= '0'; wait for 10 ns;
    A0 <= '0'; A1 <= '1'; wait for 10 ns;
    A0 <= '1'; A1 <= '1'; wait for 10 ns;

    wait;
  end process;

end behavioral;

