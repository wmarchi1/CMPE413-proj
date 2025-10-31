--exec xvhdl and2.vhd decoder24.vhd dff.vhd dff2bit.vhd vt_regs.vhd vt_regs_tb.vhd

--exec xelab vt_regs_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;

entity vt_regs_tb is
end vt_regs_tb;

architecture sim of vt_regs_tb is

    -- DUT component declaration
    component vt_regs
        port ( 
            address_s : in std_logic_vector(3 downto 0);
            write_vt  : in std_logic;
            cb0_bits  : out std_logic_vector(2 downto 0);
            cb1_bits  : out std_logic_vector(2 downto 0);
            cb2_bits  : out std_logic_vector(2 downto 0);
            cb3_bits  : out std_logic_vector(2 downto 0)
        );
    end component;

    -- Test signals
    signal address_s_s : std_logic_vector(3 downto 0);
    signal write_vt_s  : std_logic;
    signal cb0_bits_s, cb1_bits_s, cb2_bits_s, cb3_bits_s : std_logic_vector(2 downto 0);

begin
    -- Instantiate the DUT
    DUT: vt_regs
        port map(
            address_s => address_s_s,
            write_vt  => write_vt_s,
            cb0_bits  => cb0_bits_s,
            cb1_bits  => cb1_bits_s,
            cb2_bits  => cb2_bits_s,
            cb3_bits  => cb3_bits_s
        );

    -- Test process
    stim_proc: process
    begin
        -----------------------------------------------------
        -- Initialize signals
        -----------------------------------------------------
        address_s_s <= (others => '0');
        write_vt_s  <= '0';
        wait for 10 ns;

        -----------------------------------------------------
        -- Test Case 1: Write tag "01" to cache block 0
        -----------------------------------------------------
        address_s_s <= "0100";  -- tag="01", block="00"
        wait for 1 ns;
        write_vt_s  <= '1';
        wait for 10 ns;
        write_vt_s  <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 2: Write tag "10" to cache block 3
        -----------------------------------------------------
        address_s_s <= "1011";  -- tag="10", block="11"
        wait for 1 ns;
        write_vt_s  <= '1';
        wait for 10 ns;
        write_vt_s  <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 3: Write tag "11" to cache block 1
        -----------------------------------------------------
        address_s_s <= "1101";  -- tag="11", block="01"
        wait for 1 ns;
        write_vt_s  <= '1';
        wait for 10 ns;
        write_vt_s  <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 4: Write tag "00" to cache block 2
        -----------------------------------------------------
        address_s_s <= "0010";  -- tag="00", block="10"
        wait for 1 ns;
        write_vt_s  <= '1';
        wait for 10 ns;
        write_vt_s  <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 5: No write event (hold values)
        -----------------------------------------------------
        address_s_s <= "1111";  -- tag="11", block="11"
        wait for 1 ns;
        write_vt_s  <= '1';
        wait for 10 ns;
        write_vt_s  <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- End of simulation
        -----------------------------------------------------
        wait;
    end process;

end sim;
