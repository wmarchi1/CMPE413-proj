library IEEE;
use IEEE.std_logic_1164.all;

entity mux161 is
    port(
        mux16_input : in  std_logic_vector(15 downto 0); -- 16 data inputs
        mux16_sel   : in  std_logic_vector(3 downto 0); -- 4-bit select
        mux16_out   : out std_logic -- output
    );
end mux161;

architecture structural of mux161 is

    component mux42
        port(
            mux42_input : in  std_logic_vector(3 downto 0);
            mux42_sel   : in  std_logic_vector(1 downto 0);
            mux42_out   : out std_logic
        );
    end component;

    signal layer1_out : std_logic_vector(3 downto 0);  -- outputs of first layer (4 mux42s)

begin

    mux0: mux42
        port map(
            mux42_input => mux16_input(3 downto 0),
            mux42_sel   => mux16_sel(1 downto 0),
            mux42_out   => layer1_out(0)
        );

    mux1: mux42
        port map(
            mux42_input => mux16_input(7 downto 4),
            mux42_sel   => mux16_sel(1 downto 0),
            mux42_out   => layer1_out(1)
        );

    mux2: mux42
        port map(
            mux42_input => mux16_input(11 downto 8),
            mux42_sel   => mux16_sel(1 downto 0),
            mux42_out   => layer1_out(2)
        );

    mux3: mux42
        port map(
            mux42_input => mux16_input(15 downto 12),
            mux42_sel   => mux16_sel(1 downto 0),
            mux42_out   => layer1_out(3)
        );

    mux4: mux42
        port map(
            mux42_input => layer1_out,
            mux42_sel   => mux16_sel(3 downto 2),
            mux42_out   => mux16_out
        );

end structural;
