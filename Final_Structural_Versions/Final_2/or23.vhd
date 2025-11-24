library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity or23 is
  port (
    input0  : in  std_logic;
    input1  : in  std_logic;
    input2  : in  std_logic;
    input3  : in  std_logic;
    input4  : in  std_logic;
    input5  : in  std_logic;
    input6  : in  std_logic;
    input7  : in  std_logic;
    input8  : in  std_logic;
    input9  : in  std_logic;
    input10 : in  std_logic;
    input11 : in  std_logic;
    input12 : in  std_logic;
    input13 : in  std_logic;
    input14 : in  std_logic;
    input15 : in  std_logic;
    input16 : in  std_logic;
    input17 : in  std_logic;
    input18 : in  std_logic;
    input19 : in  std_logic;
    input20 : in  std_logic;
    input21 : in  std_logic;
    input22 : in  std_logic;
    output0 : out std_logic
  );
end or23;

architecture structural of or23 is

  component or2
    port (
      input0  : in  std_logic;
      input1  : in  std_logic;
      output0 : out std_logic
    );
  end component;

  component or4
    port (
      input0 : in  std_logic;
      input1 : in  std_logic;
      input2 : in  std_logic;
      input3 : in  std_logic;
      output0 : out std_logic
    );
  end component;

  component or7
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
  end component;

  component or15
    port (
      input0  : in  std_logic;
      input1  : in  std_logic;
      input2  : in  std_logic;
      input3  : in  std_logic;
      input4  : in  std_logic;
      input5  : in  std_logic;
      input6  : in  std_logic;
      input7  : in  std_logic;
      input8  : in  std_logic;
      input9  : in  std_logic;
      input10 : in  std_logic;
      input11 : in  std_logic;
      input12 : in  std_logic;
      input13 : in  std_logic;
      input14 : in  std_logic;
      output0 : out std_logic
    );
  end component;

  component or19
    port (
      input0  : in  std_logic;
      input1  : in  std_logic;
      input2  : in  std_logic;
      input3  : in  std_logic;
      input4  : in  std_logic;
      input5  : in  std_logic;
      input6  : in  std_logic;
      input7  : in  std_logic;
      input8  : in  std_logic;
      input9  : in  std_logic;
      input10 : in  std_logic;
      input11 : in  std_logic;
      input12 : in  std_logic;
      input13 : in  std_logic;
      input14 : in  std_logic;
      input15 : in  std_logic;
      input16 : in  std_logic;
      input17 : in  std_logic;
      input18 : in  std_logic;
      output0 : out std_logic
    );
  end component;

  signal s1, s2 : std_logic;

begin
  -- First 19 inputs go into or19
  u1: or19 port map(
    input0, input1, input2, input3, input4, input5, input6,
    input7, input8, input9, input10, input11, input12, input13,
    input14, input15, input16, input17, input18, s1
  );

  -- Remaining 4 inputs go into or4
  u2: or4 port map(input19, input20, input21, input22, s2);

  -- Combine results with or2
  u3: or2 port map(s1, s2, output0);

end structural;
