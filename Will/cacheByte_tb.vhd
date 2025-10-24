--exec xvhdl and2.vhd inv.vhd selector.vhd tx.vhd dff.vhd cacheCell.vhd cacheByte.vhd cacheByte_tb.vhd
--exec xelab cacheByte_tb -debug typical -s sim_out
library IEEE;
use IEEE.std_logic_1164.all;

entity cacheByte_tb is
-- Testbench has no ports
end cacheByte_tb;

architecture behavior of cacheByte_tb is

    -- Component declaration
    component cacheByte
        port(
            chip_enable : in  std_logic;
            rd_wr       : in  std_logic;
            data_in     : in  std_logic_vector(7 downto 0);
            data_out    : out std_logic_vector(7 downto 0)
        );
    end component;

    -- Signals to connect to DUT
    signal chip_enable : std_logic := '0';
    signal rd_wr       : std_logic := '0';
    signal data_in     : std_logic_vector(7 downto 0) := (others => '0');
    signal data_out    : std_logic_vector(7 downto 0);

begin

    -- Instantiate the DUT
    DUT: cacheByte
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in,
            data_out    => data_out
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Enable chip and write data
        chip_enable <= '1';
        rd_wr       <= '0';  -- Write mode
        data_in     <= "10101010";
        wait for 10 ns;

        data_in <= "11001100";
        wait for 10 ns;

        data_in <= "11110000";
        wait for 10 ns;

        -- Switch to read mode
        rd_wr <= '1';  -- Read mode
        wait for 10 ns;

        data_in <= "00000000";
        wait for 5 ns;

        -- Disable chip
        chip_enable <= '0';
        wait for 10 ns;

        -- Enable chip and read again
        chip_enable <= '1';
        rd_wr <= '0';  -- write mode
        wait for 10 ns;

        rd_wr <= '1';
        wait for 1 ns;
        data_in <= "11111111";
        wait for 4 ns;

        -- Finish simulation
        wait;
    end process;

end behavior;
