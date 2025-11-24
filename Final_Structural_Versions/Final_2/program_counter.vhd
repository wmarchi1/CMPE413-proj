library IEEE;
use IEEE.std_logic_1164.all;

entity program_counter is
    port (
        clk   : in std_logic;
        reset : in std_logic;
        busy  : in std_logic;
        q     : out std_logic_vector(4 downto 0)
    );
end program_counter;

architecture structural of program_counter is

    --------------------------------------------------------------------
    -- Component Declarations
    --------------------------------------------------------------------
    component dff_neg
        port ( d : in std_logic; clk : in std_logic; q : out std_logic );
    end component;

    component inv
        port ( inv_input : in std_logic; inv_out : out std_logic );
    end component;

    component and2
        port ( input0,input1 : in std_logic; output0 : out std_logic );
    end component;

    component or2
        port ( input0,input1 : in std_logic; output0 : out std_logic );
    end component;

    component mux21
        port ( a,b,sel : in std_logic; y : out std_logic );
    end component;

    component xor2
        port ( input0,input1 : in std_logic; output0 : out std_logic );
    end component;

    --------------------------------------------------------------------
    -- Internal Signals
    --------------------------------------------------------------------
    signal count, adder_sum, mux_out, d_in : std_logic_vector(4 downto 0);
    signal carry: std_logic_vector(3 downto 0);
    signal not_busy, effective_reset, effective_reset_n : std_logic;
    signal const_0 : std_logic := '0';

begin

    --------------------------------------------------------------------
    -- Effective reset = reset OR (NOT busy)
    -- Counter clears when system reset or when busy goes low
    --------------------------------------------------------------------
    inv_busy : inv port map(inv_input => busy, inv_out => not_busy);
    or_reset : or2 port map(input0 => reset, input1 => not_busy, output0 => effective_reset);
    inv_eff : inv port map(inv_input => effective_reset, inv_out => effective_reset_n);

    --------------------------------------------------------------------
    -- Ripple Carry Incrementer (count + 1)
    --------------------------------------------------------------------
    inv_b0 : inv port map(inv_input => count(0), inv_out => adder_sum(0));
    carry(0) <= count(0);

    xor2_1 : xor2 port map(input0 => count(1), input1 => carry(0), output0 => adder_sum(1));
    and_b1 : and2 port map(input0 => count(1), input1 => carry(0), output0 => carry(1));

    xor2_2 : xor2 port map(input0 => count(2), input1 => carry(1), output0 => adder_sum(2));
    and_b2 : and2 port map(input0 => count(2), input1 => carry(1), output0 => carry(2));

    xor2_3 : xor2 port map(input0 => count(3), input1 => carry(2), output0 => adder_sum(3));
    and_b3 : and2 port map(input0 => count(3), input1 => carry(2), output0 => carry(3));

    xor2_4 : xor2 port map(input0 => count(4), input1 => carry(3), output0 => adder_sum(4));

    --------------------------------------------------------------------
    -- MUX: Increment or Hold (controlled by busy)
    --------------------------------------------------------------------
    mux_en0 : mux21 port map(a => count(0), b => adder_sum(0), sel => busy, y => mux_out(0));
    mux_en1 : mux21 port map(a => count(1), b => adder_sum(1), sel => busy, y => mux_out(1));
    mux_en2 : mux21 port map(a => count(2), b => adder_sum(2), sel => busy, y => mux_out(2));
    mux_en3 : mux21 port map(a => count(3), b => adder_sum(3), sel => busy, y => mux_out(3));
    mux_en4 : mux21 port map(a => count(4), b => adder_sum(4), sel => busy, y => mux_out(4));

    --------------------------------------------------------------------
    -- Reset gating (forces 0 when reset or busy goes low)
    --------------------------------------------------------------------
    and_r0 : and2 port map(input0 => mux_out(0), input1 => effective_reset_n, output0 => d_in(0));
    and_r1 : and2 port map(input0 => mux_out(1), input1 => effective_reset_n, output0 => d_in(1));
    and_r2 : and2 port map(input0 => mux_out(2), input1 => effective_reset_n, output0 => d_in(2));
    and_r3 : and2 port map(input0 => mux_out(3), input1 => effective_reset_n, output0 => d_in(3));
    and_r4 : and2 port map(input0 => mux_out(4), input1 => effective_reset_n, output0 => d_in(4));

    --------------------------------------------------------------------
    -- D Flip-Flops (Negative-edge triggered)
    --------------------------------------------------------------------
    dff0 : dff_neg port map(d => d_in(0), clk => clk, q => count(0));
    dff1 : dff_neg port map(d => d_in(1), clk => clk, q => count(1));
    dff2 : dff_neg port map(d => d_in(2), clk => clk, q => count(2));
    dff3 : dff_neg port map(d => d_in(3), clk => clk, q => count(3));
    dff4 : dff_neg port map(d => d_in(4), clk => clk, q => count(4));
    
   q <= count;

end structural;

