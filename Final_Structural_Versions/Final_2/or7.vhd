library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity or7 is
  port (
    input0 : in  std_logic;
    input1 : in  std_logic;
    input2 : in  std_logic;
    input3 : in  std_logic;
    input4 : in  std_logic;
    input5 : in  std_logic;
    input6 : in  std_logic;
    output0 : out std_logic
  );
end or7;

architecture structural of or7 is

  component or2
    port (
      input0  : in  std_logic;
      input1  : in  std_logic;
      output0 : out std_logic
    );
  end component;

  -- Internal signals for intermediate outputs
  signal s1, s2, s3, s4, s5, s6 : std_logic;

begin

  -- Cascade connections
  u1: or2 port map(input0, input1, s1);
  u2: or2 port map(s1, input2, s2);
  u3: or2 port map(s2, input3, s3);
  u4: or2 port map(s3, input4, s4);
  u5: or2 port map(s4, input5, s5);
  u6: or2 port map(s5, input6, output0);

end structural;
