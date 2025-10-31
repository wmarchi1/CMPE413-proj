library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity and5 is
  port (
    input0   : in  std_logic;
    input1   : in  std_logic;
    input2   : in  std_logic;
    input3   : in  std_logic;
    input4   : in  std_logic;
    output0  : out std_logic
  );
end and5;

architecture structural of and5 is

  -- base 2-input AND gate component
  component and2
    port (
      input0   : in  std_logic;
      input1   : in  std_logic;
      output0  : out std_logic
    );
  end component;

  -- internal signals
  signal t1, t2, t3 : std_logic;

begin
  -- level 1
  and2_0 : and2 port map(input0 => input0, input1 => input1, output0 => t1);
  and2_1 : and2 port map(input0 => input2, input1 => input3, output0 => t2);

  -- level 2
  and2_2 : and2 port map(input0 => t1, input1 => t2, output0 => t3);

  -- level 3 (combine with 5th input)
  and2_3 : and2 port map(input0 => t3, input1 => input4, output0 => output0);

end structural;