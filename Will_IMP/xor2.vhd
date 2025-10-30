library IEEE;
use IEEE.std_logic_1164.all;

entity xor2 is
    port (
        input0  : in  std_logic;   -- First input (A)
        input1  : in  std_logic;   -- Second input (B)
        output0 : out std_logic    -- Output = A XOR B
    );
end xor2;

architecture structural of xor2 is

    --------------------------------------------------------------------
    -- Component Declarations
    --------------------------------------------------------------------
    component and2
        port (
            input0  : in  std_logic;
            input1  : in  std_logic;
            output0 : out std_logic
        );
    end component;

    component or2
        port (
            input0  : in  std_logic;
            input1  : in  std_logic;
            output0 : out std_logic
        );
    end component;

    component inv
        port (
            inv_input : in  std_logic;
            inv_out   : out std_logic
        );
    end component;

    --------------------------------------------------------------------
    -- Internal Signals
    --------------------------------------------------------------------
    signal a_not, b_not : std_logic;
    signal term1, term2 : std_logic;

begin
    --------------------------------------------------------------------
    -- Structural implementation of XOR
    -- Logic: Y = (A AND NOT B) OR (NOT A AND B)
    --------------------------------------------------------------------
    inv_a : inv port map(inv_input => input0, inv_out => a_not);
    inv_b : inv port map(inv_input => input1, inv_out => b_not);

    and1_gate : and2 port map(input0 => input0, input1 => b_not, output0 => term1); -- A & ~B
    and2_gate : and2 port map(input0 => a_not, input1 => input1, output0 => term2); -- ~A & B

    or_gate : or2 port map(input0 => term1, input1 => term2, output0 => output0);

end structural;