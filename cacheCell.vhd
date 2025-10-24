library IEEE;
use IEEE.std_logic_1164.all;

entity cacheCell is
    port(
        chip_enable : in std_logic;
        rd_wr       : in std_logic;
        data_in     : in std_logic;
        data_out    : out std_logic
    );
end cacheCell;

architecture structural of cacheCell is

component Dlatch
    port(
        d   : in  std_logic;  -- data input
        clk : in  std_logic;  -- write enable
        q   : out std_logic   -- latch output
    ); 
end component;

component tx
    port(
        sel       : in std_logic;  -- read enable
        selnot    : in std_logic;  -- inverted read enable
        tx_input  : in std_logic;  -- input from latch
        tx_output : out std_logic  -- output to data_out
    );
end component;

component selector
    port(
        in0  : in std_logic;  -- chip enable
        in1  : in std_logic;  -- rd_wr
        out0 : out std_logic; -- read enable
        out1 : out std_logic  -- write enable
    ); 
end component;

component inv
    port(
        inv_input : in  std_logic;  -- read enable
        inv_out   : out std_logic   -- inverted read enable
    ); 
end component;

-- Component bindings
for Dlatch_0 : Dlatch use entity work.Dlatch(structural);
for tx_0     : tx     use entity work.tx(structural);
for selector_0 : selector use entity work.selector(structural);
for inv_0    : inv    use entity work.inv(structural);

-- Internal signals
signal n_rd_e  : std_logic;
signal net_wr_e: std_logic;
signal net_q   : std_logic;
signal net_rd_e: std_logic;

begin
    -- Selector instantiation
    selector_0 : selector
        port map(
            in0  => chip_enable,
            in1  => rd_wr,
            out0 => net_rd_e,
            out1 => net_wr_e
        );

    -- D-latch instantiation
    Dlatch_0 : Dlatch
        port map(
            d   => data_in,
            clk => net_wr_e,
            q   => net_q
        );

    -- Inverter instantiation
    inv_0 : inv
        port map(
            inv_input => net_rd_e,
            inv_out   => n_rd_e
        );

    -- Transmission gate instantiation
    tx_0 : tx
        port map(
            sel       => net_rd_e,
            selnot    => n_rd_e,
            tx_input  => net_q,
            tx_output => data_out
        );

end structural;
