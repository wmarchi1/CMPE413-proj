library IEEE;
use IEEE.std_logic_1164.all;

entity selector is
    port(
        in0 : in std_logic; -- Chip Enable
        in1 : in std_logic; -- RD/ _WR
        out0 : out std_logic; -- Read Enable
        out1 : out std_logic -- Write Enable
    );
end selector;

architecture structural of selector is

    component and2
    port (
        input0 : in std_logic;
        input1 : in std_logic;
        output0 : out std_logic
    );
    end component;
    
    component inv
    port(
	    inv_input	: in std_logic;
	    inv_out	: out std_logic
    );
    end component;

    for and2_1 : and2 use entity work.and2(structural);
    for and2_2 : and2 use entity work.and2(structural);

    for inv_1 : inv use entity work.inv(structural);

    signal n_in1 : std_logic;

begin
    
    inv_1 : inv port map ( in1, n_in1);
    and2_1 : and2 port map (in0, in1, out0);  -- Read Enable
    and2_2 : and2 port map (in0, n_in1, out1);    -- Write Enable

end structural;

