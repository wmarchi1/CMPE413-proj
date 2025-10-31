library IEEE;
use IEEE.std_logic_1164.all;

entity vt_interface_tb is
end vt_interface_tb;

architecture sim of vt_interface_tb is

    -- DUT component declaration
    component vt_interface
        port (
            address5_2 : in std_logic_vector(3 downto 0);
            reset      : in std_logic;  -- active-low reset
            valid      : in std_logic;
            write_vt   : in std_logic;
            hit_miss   : out std_logic
        );
    end component;

    -- Test signals
    signal address5_2_s : std_logic_vector(3 downto 0);
    signal reset_s      : std_logic;
    signal write_vt_s   : std_logic;
    signal hit_miss_s   : std_logic;
    signal valid_s       : std_logic;

begin
    -- Instantiate the DUT
    DUT: vt_interface
        port map(
            address5_2 => address5_2_s,
            reset      => reset_s,
            valid      => valid_s,
            write_vt   => write_vt_s,
            hit_miss   => hit_miss_s
        );

    -- Test process
    stim_proc: process
    begin
        -----------------------------------------------------
        -- Initialize and apply active-low reset
        -----------------------------------------------------
        write_vt_s   <= '0';
        reset_s      <= '0';  
        address5_2_s <= (others => '0');
        valid_s        <= '0';
        --address5_2_s <= "0000";
        wait for 1 ns;
        reset_s      <= '1';           -- reset inactive
        wait for 10 ns;
        write_vt_s <= '0';
        reset_s      <= '0';           -- assert reset (active low)
        valid_s       <= '1';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 1: Write tag "01" to block 0
        -----------------------------------------------------
        address5_2_s <= "0100";        -- tag="01", block="00"
        wait for 1 ns;
        write_vt_s   <= '1';
        wait for 10 ns;
        write_vt_s   <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 2: HIT on block 0, tag "01"
        -----------------------------------------------------
        address5_2_s <= "0100";        -- same address, should hit
        wait for 1 ns;
        write_vt_s   <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 3: MISS on block 0, different tag
        -----------------------------------------------------
        address5_2_s <= "1000";        -- tag="10", block="00"
        wait for 1 ns;
        write_vt_s   <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 4: Write tag "11" to block 2
        -----------------------------------------------------
        address5_2_s <= "1110";        -- tag="11", block="10"
        wait for 1 ns;
        write_vt_s   <= '1';
        wait for 10 ns;
        write_vt_s   <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 5: HIT on block 2
        -----------------------------------------------------
        address5_2_s <= "1110";        -- same tag/block, hit expected
        wait for 1 ns;
        write_vt_s   <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 6: Apply active-low reset again
        -----------------------------------------------------
        reset_s <= '0';                -- assert reset
        wait for 20 ns;
        valid_s        <= '0';
        wait for 1 ns;
        reset_s <= '1';                -- release reset
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 7: MISS after reset (registers cleared)
        -----------------------------------------------------
        address5_2_s <= "0100";        -- previously written block
        wait for 1 ns;
        write_vt_s   <= '0';
        wait for 20 ns;

        -----------------------------------------------------
        -- End of simulation
        -----------------------------------------------------
        wait;
    end process;

end sim;
