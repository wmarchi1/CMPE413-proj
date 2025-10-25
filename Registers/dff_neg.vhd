--exec xvhdl inv.vhd nand2.vhd dff_neg.vhd tb_dff_neg.vhd

--exec xelab tb_dff_neg -debug typical -s sim_out

--exec xsim sim_out -gui


library IEEE;
use IEEE.std_logic_1164.all;

entity dff_neg is
    port(
        d   : in  std_logic;   -- Data input
        clk : in  std_logic;   -- Clock input
        q   : out std_logic   -- Output
    );
end dff_neg;

architecture structural of dff_neg is

    component dlatch
        port (
        	d   : in  std_logic;   -- Data input
        	clk : in  std_logic;   -- Clock input
        	q   : out std_logic   -- Output
        );
    end component;
    component inv
      port ( inv_input	: in  std_logic;
         inv_out: out std_logic);
    end component;

    -- Bind component architectures
    for dlatch_1 : dlatch use entity work.dlatch(structural);
    for dlatch_2 : dlatch use entity work.dlatch(structural);
    for inv_1 : inv use entity work.inv(structural);
    signal m_q, nclk : std_logic;
    signal s_q : std_logic;

begin
    inv_1 : inv port map (inv_input => clk, inv_out => nclk);
    dlatch_1 : dlatch port map (d,    clk => clk, q => m_q);
    dlatch_2 : dlatch port map (m_q,  clk => nclk, q => s_q);
    q  <= s_q;

end structural;
