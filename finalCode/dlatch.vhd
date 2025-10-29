library IEEE;
use IEEE.std_logic_1164.all;

entity dlatch is
    port(
        d   : in  std_logic;   -- Data input
        clk : in  std_logic;   -- Clock input
        q   : out std_logic   -- Output
    );
end dlatch;

architecture structural of dlatch is

    component nand2
        port (
            input0 : in std_logic;
            input1 : in std_logic;
            output0 : out std_logic
        );
    end component;
    component inv
      port ( inv_input	: in  std_logic;
         inv_out: out std_logic);
    end component;

    for nand2_1 : nand2 use entity work.nand2(structural);
    for nand2_2 : nand2 use entity work.nand2(structural);
    for nand2_3 : nand2 use entity work.nand2(structural);
    for nand2_4 : nand2 use entity work.nand2(structural);
    for inv_1 : inv use entity work.inv(structural);
    signal d_n : std_logic;
    signal m_q, m_qn : std_logic;
    signal s_q, s_qn : std_logic;

begin
    inv_1 : inv port map (inv_input => d, inv_out => d_n);
    nand2_1 : nand2 port map (input0 => d,    input1 => clk, output0 => m_q);
    nand2_2 : nand2 port map (input0 => d_n,  input1 => clk, output0 => m_qn);
    nand2_3 : nand2 port map (input0 => m_q,  input1 => s_qn, output0 => s_q);
    nand2_4 : nand2 port map (input0 => m_qn,  input1 => s_q, output0 => s_qn);


    ----------------------------------------------------------------
    -- Outputs
    ----------------------------------------------------------------
    q  <= s_q;

end structural;
