library IEEE;
use IEEE.std_logic_1164.all;

entity dff is
    port(
        d    : in  std_logic;
        clk  : in  std_logic;
        q    : out std_logic --,
        --qbar : out std_logic
    );
end dff;

architecture structural of dff is

    component and2
        port(
            input0  : in  std_logic;
            input1  : in  std_logic;
            output0 : out std_logic
        );
    end component;

    component or2
        port(
            input0  : in  std_logic;
            input1  : in  std_logic;
            output0 : out std_logic
        );
    end component;

    component inv
        port(
            inv_input : in  std_logic;
            inv_out   : out std_logic
        );
    end component;

    signal d_n, clk_n : std_logic;
    signal s, r : std_logic;
    signal q_int, qbar_int : std_logic;

begin

    -- Invert signals
    inv_d   : inv port map(inv_input => d,   inv_out => d_n);
    inv_clk : inv port map(inv_input => clk, inv_out => clk_n);

    -- Generate S and R signals
    s_gen : and2 port map(input0 => d,   input1 => clk_n, output0 => s);
    r_gen : and2 port map(input0 => d_n, input1 => clk_n, output0 => r);

    -- Cross-coupled NORs to create the latch
    q_nor  : or2 port map(input0 => r,     input1 => qbar_int, output0 => q_int);
    qb_nor : or2 port map(input0 => s,     input1 => q_int,    output0 => qbar_int);

    q    <= q_int;
    --qbar <= qbar_int;

end structural;
