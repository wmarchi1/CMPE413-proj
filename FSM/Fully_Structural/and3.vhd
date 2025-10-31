library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity and3 is
  port (
    input0   : in  std_logic;
    input1   : in  std_logic;
    input2   : in  std_logic;
    output0  : out std_logic
  );
end and3;

architecture structural of and3 is

  -- base 2-input AND gate
  component and2
    port (
      input0   : in  std_logic;
      input1   : in  std_logic;
      output0  : out std_logic
    );
  end component;

  -- internal signal
  signal t1 : std_logic;

begin
  -- first stage
  and2_0 : and2 port map(input0 => input0, input1 => input1, output0 => t1);

  -- second stage
  and2_1 : and2 port map(input0 => t1, input1 => input2, output0 => output0);

end structural;
