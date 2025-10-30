library IEEE;
use IEEE.std_logic_1164.all;

entity mux21 is
    port(
        a   : in  std_logic;  -- Input 0 (sel 0)
        b   : in  std_logic;  -- Input 1 (sel 1)
        sel : in  std_logic;  -- Select
        y   : out std_logic   -- Output
    );
end mux21;

architecture structural of mux21 is
    component and2 
        port(
        input0   : in  std_logic;
        input1   : in  std_logic;
        output0   : out std_logic);
    end component;

    component or2 
        port(
        input0   : in  std_logic;
        input1   : in  std_logic;
        output0   : out std_logic);
    end component;

    component inv
        port(
            inv_input	: in  std_logic;
            inv_out: out std_logic);
    end component;

    -- Internal signals
    signal sel_not : std_logic;
    signal a_and   : std_logic;
    signal b_and   : std_logic;

begin
    inv_inst : inv
        port map(
            inv_input => sel,
            inv_out => sel_not
        );
    and2_inst1 : and2
        port map(
            input0 => a,
            input1 => sel_not,
            output0 => a_and
        );
    and2_inst2 : and2
        port map(
            input0 => b,
            input1 => sel,
            output0 => b_and
        );
    or2_inst : or2
        port map(
            input0 => a_and,
            input1 => b_and,
            output0 => y
        );
    -- Invert select signal
    --sel_not <= not sel;

    -- AND gates
    --a_and <= a and sel_not;  -- a & ~sel
    --b_and <= b and sel;      -- b & sel

    -- OR gate to combine outputs
    --y <= a_and or b_and;

end structural;
