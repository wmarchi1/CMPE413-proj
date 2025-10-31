library IEEE;
use IEEE.std_logic_1164.all;

entity dff_neg_rst is
    port(
        d    : in  std_logic;   -- Data input
        clk  : in  std_logic;   -- Clock input
        rst  : in  std_logic;   -- Asynchronous reset (active high)
        q    : out std_logic    -- Output
    );
end dff_neg_rst;

architecture structural of dff_neg_rst is

    component dlatch
        port (
            d   : in  std_logic;
            clk : in  std_logic;
            q   : out std_logic
        );
    end component;

    component inv
        port (
            inv_input : in  std_logic;
            inv_out   : out std_logic
        );
    end component;

    -- Bind component architectures
    for dlatch_1 : dlatch use entity work.dlatch(structural);
    for dlatch_2 : dlatch use entity work.dlatch(structural);
    for inv_1 : inv use entity work.inv(structural);

    signal m_q, nclk : std_logic;
    signal s_q, q_int : std_logic;

begin
    ----------------------------------------------------------------
    -- Standard negative-edge DFF structure (master/slave)
    ----------------------------------------------------------------
    inv_1 : inv port map(inv_input => clk, inv_out => nclk);
    dlatch_1 : dlatch port map(d => d, clk => clk, q => m_q);
    dlatch_2 : dlatch port map(d => m_q, clk => nclk, q => s_q);

    ----------------------------------------------------------------
    -- Asynchronous reset (active high)
    ----------------------------------------------------------------
    process(rst, s_q)
    begin
        if rst = '1' then
            q_int <= '0';
        else
            q_int <= s_q;
        end if;
    end process;

    q <= q_int;

end structural;
