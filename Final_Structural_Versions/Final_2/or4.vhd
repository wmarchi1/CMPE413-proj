library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity or4 is
  port (
    input0 : in  std_logic;
    input1 : in  std_logic;
    input2 : in  std_logic;
    input3 : in  std_logic;
    output0 : out std_logic
  );
end or4;

architecture structural of or4 is

  component or2
    port (
      input0  : in  std_logic;
      input1  : in  std_logic;
      output0 : out std_logic
    );
  end component;

  signal s1, s2, s3 : std_logic;

begin

  u1: or2 port map(input0, input1, s1);
  u2: or2 port map(s1, input2, s2);
  u3: or2 port map(s2, input3, output0);

end structural;
