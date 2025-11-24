library STD;
library IEEE;
use IEEE.std_logic_1164.all;

entity or19 is
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
end or19;

architecture structural of or19 is

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

  signal s1, s2, s3, s4, s5 : std_logic;

begin
  -- group inputs efficiently into OR7 + OR4 combinations
  u1: or7 port map(input0, input1, input2, input3, input4, input5, input6, s1);
  u2: or7 port map(input7, input8, input9, input10, input11, input12, input13, s2);
  u3: or4 port map(input14, input15, input16, input17, s3);
  u4: or2 port map(s1, s2, s4);
  u5: or2 port map(s3, input18, s5);  -- combine last inputs
  u6: or2 port map(s4, s5, output0);

end structural;
