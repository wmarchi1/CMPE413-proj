library IEEE;
use IEEE.std_logic_1164.all;

entity tb_hit_miss is 
end tb_hit_miss;

architecture behavioral of tb_hit_miss is

  component hit_miss
    port(
        tag_in    : in  std_logic_vector(1 downto 0);
        tag_cache : in  std_logic_vector(1 downto 0);
        valid     : in  std_logic;
        hit_miss  : out std_logic);
  end component;

  signal A0, A1 : std_logic_vector(1 downto 0);
  signal valid, hit_miss_out : std_logic;

begin

  UUT: hit_miss port map(
    tag_in    => A0,
    tag_cache => A1,
    valid     => valid,
    hit_miss  => hit_miss_out
  );


  stim_proc: process
  begin
    A0 <= "00"; A1 <= "00"; valid <= '1'; wait for 10 ns;
    A0 <= "01"; A1 <= "01"; valid <= '1'; wait for 10 ns;
    A0 <= "10"; A1 <= "10"; valid <= '1'; wait for 10 ns;
    A0 <= "11"; A1 <= "11"; valid <= '1'; wait for 10 ns;
    A0 <= "01"; A1 <= "10"; valid <= '1'; wait for 10 ns;  
    A0 <= "11"; A1 <= "11"; valid <= '0'; wait for 10 ns; 
    A0 <= "10"; A1 <= "01"; valid <= '1'; wait for 10 ns; 
    A0 <= "11"; A1 <= "11"; valid <= '0'; wait for 10 ns;  

    wait;
  end process;

end behavioral;

