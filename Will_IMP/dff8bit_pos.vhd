library IEEE;
use IEEE.std_logic_1164.all;

entity dff8bit_pos is
    port(
        d   : in  std_logic_vector(7 downto 0);
        clk : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end dff8bit_pos;

architecture structural of dff8bit_pos is
    component dff
        port(
            d   : in  std_logic;
            clk : in  std_logic;
            q   : out std_logic
        );
    end component;

begin

    dff0: dff port map(d => d(0), clk => clk, q => q(0));
    dff1: dff port map(d => d(1), clk => clk, q => q(1));
    dff2: dff port map(d => d(2), clk => clk, q => q(2));
    dff3: dff port map(d => d(3), clk => clk, q => q(3));
    dff4: dff port map(d => d(4), clk => clk, q => q(4));
    dff5: dff port map(d => d(5), clk => clk, q => q(5));
    dff6: dff port map(d => d(6), clk => clk, q => q(6));
    dff7: dff port map(d => d(7), clk => clk, q => q(7));
    
end structural;
