library IEEE;
use IEEE.std_logic_1164.all;

entity dff8bit_neg is
    port(
        d   : in  std_logic_vector(7 downto 0);
        clk : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end dff8bit_neg;

architecture structural of dff8bit_neg is
    component dff
        port(
            d   : in  std_logic;
            clk : in  std_logic;
            q   : out std_logic
        );
    end component;

    component inv
        port(
            inv_input : in  std_logic;
            inv_out: out std_logic
        );
    end component;

    signal clk_bar : std_logic;
begin
    inv_inst : inv port map(inv_input => clk, inv_out => clk_bar);

    dff0: dff port map(d => d(0), clk => clk_bar, q => q(0));
    dff1: dff port map(d => d(1), clk => clk_bar, q => q(1));
    dff2: dff port map(d => d(2), clk => clk_bar, q => q(2));
    dff3: dff port map(d => d(3), clk => clk_bar, q => q(3));
    dff4: dff port map(d => d(4), clk => clk_bar, q => q(4));
    dff5: dff port map(d => d(5), clk => clk_bar, q => q(5));
    dff6: dff port map(d => d(6), clk => clk_bar, q => q(6));
    dff7: dff port map(d => d(7), clk => clk_bar, q => q(7));

end structural;
