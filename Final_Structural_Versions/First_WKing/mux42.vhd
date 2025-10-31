library IEEE;
use IEEE.std_logic_1164.all;

entity mux42 is
    port(
        mux42_input : in  std_logic_vector(3 downto 0);  -- Inputs
        mux42_sel        : in  std_logic_vector(1 downto 0);  -- Select lines
        mux42_out              : out std_logic   -- Output
    );
end mux42;

architecture structural of mux42 is

    -- Component declaration for 2-to-1 mux
    component mux21
        port(
            a   : in  std_logic;
            b   : in  std_logic;
            sel : in  std_logic;
            y   : out std_logic
        );
    end component;

    -- Internal signals to connect the 2-to-1 muxes
    signal mux_out0, mux_out1 : std_logic;

begin

    -- First layer: select between a0/a1 and a2/a3 using s0
    mux0: mux21
        port map(
            a   => mux42_input(0),
            b   => mux42_input(1),
            sel => mux42_sel(0),
            y   => mux_out0
        );

    mux1: mux21
        port map(
            a   => mux42_input(2),
            b   => mux42_input(3),
            sel => mux42_sel(0),
            y   => mux_out1
        );

    -- Second layer: select between the outputs of first layer using s1
    mux2: mux21
        port map(
            a   => mux_out0,
            b   => mux_out1,
            sel => mux42_sel(1),
            y   => mux42_out
        );

end structural;