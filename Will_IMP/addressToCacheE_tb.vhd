--exec xvhdl and2.vhd and3.vhd inv.vhd decoder24.vhd addressToCacheE.vhd addressToCacheE_tb.vhd
--exec xelab addressToCacheE_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;

entity addressToCacheE_tb is
end addressToCacheE_tb;

architecture sim of addressToCacheE_tb is

    -- Component under test
    component addressToCacheE
        port(
            address          : in  std_logic_vector(3 downto 0);
            mem_enable       : in  std_logic;
            cacheByte_enable : out std_logic_vector(15 downto 0)
        );
    end component;

    -- Testbench signals
    signal tb_address          : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_mem_enable       : std_logic := '0';
    signal tb_cacheByte_enable : std_logic_vector(15 downto 0);

begin

    -- DUT instantiation
    DUT: addressToCacheE
        port map(
            address          => tb_address,
            mem_enable       => tb_mem_enable,
            cacheByte_enable => tb_cacheByte_enable
        );

    -- Test process
    process
    begin
        -- Case 1: mem_enable = 0 (everything should be 0)
        tb_mem_enable <= '0';
        tb_address <= "0000";
        wait for 10 ns;

        -- Case 2: mem_enable = 1, address = 0000 → bit 0
        tb_mem_enable <= '1';
        tb_address <= "0000";
        wait for 10 ns;

        -- Case 3: address = 0001 → bit 1
        tb_address <= "0001";
        wait for 10 ns;

        -- Case 4: address = 0010 → bit 2
        tb_address <= "0010";
        wait for 10 ns;

        -- Case 5: address = 0011 → bit 3
        tb_address <= "0011";
        wait for 10 ns;

        -- Case 6: address = 0100 → bit 4
        tb_address <= "0100";
        wait for 10 ns;

        -- Case 7: address = 1011 → bit 11
        tb_address <= "1011";
        wait for 10 ns;

        -- Case 8: address = 1111 → bit 15
        tb_address <= "1111";
        wait for 10 ns;

        -- Disable memory access
        tb_mem_enable <= '0';
        tb_address <= "0101";
        wait for 10 ns;

        wait; -- End simulation
    end process;

end sim;
