library IEEE;
use IEEE.std_logic_1164.all;

entity dff2bit is
    port(
        d   : in  std_logic_vector(1 downto 0);
        clk : in  std_logic;
        q   : out std_logic_vector(1 downto 0)
    );
end dff2bit;

architecture structural of dff2bit is
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
end structural;
