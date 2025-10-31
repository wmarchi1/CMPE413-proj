library IEEE;
use IEEE.std_logic_1164.all;

entity mux413HML_tb is
end mux413HML_tb;

architecture sim of mux413HML_tb is

    -- DUT component declaration
    component mux413HML
        port ( 
            cb0_bits : in std_logic_vector(2 downto 0);
            cb1_bits : in std_logic_vector(2 downto 0);
            cb2_bits : in std_logic_vector(2 downto 0);
            cb3_bits : in std_logic_vector(2 downto 0);
            address_slice  : in std_logic_vector(1 downto 0);
            address_slice2 : in std_logic_vector(1 downto 0);
            hm_out : out std_logic
        );
    end component;

    -- Test signals
    signal cb0_bits_s, cb1_bits_s, cb2_bits_s, cb3_bits_s : std_logic_vector(2 downto 0);
    signal address_slice_s, address_slice2_s : std_logic_vector(1 downto 0);
    signal hm_out_s : std_logic;

begin
    -- Instantiate the DUT
    DUT: mux413HML
        port map(
            cb0_bits => cb0_bits_s,
            cb1_bits => cb1_bits_s,
            cb2_bits => cb2_bits_s,
            cb3_bits => cb3_bits_s,
            address_slice  => address_slice_s,
            address_slice2 => address_slice2_s,
            hm_out => hm_out_s
        );

    -- Test process
    stim_proc: process
    begin
        -----------------------------------------------------
        -- Test Case 1: Valid Hit on Block 0
        -----------------------------------------------------
        cb0_bits_s <= "111"; -- valid=1, tag="11"
        cb1_bits_s <= "000";
        cb2_bits_s <= "000";
        cb3_bits_s <= "000";
        address_slice_s  <= "00"; -- select block 0
        address_slice2_s <= "11"; -- matches cb0 tag
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 2: Valid Miss on Block 1 (wrong tag)
        -----------------------------------------------------
        cb0_bits_s <= "000";
        cb1_bits_s <= "110"; -- valid=1, tag="10"
        cb2_bits_s <= "000";
        cb3_bits_s <= "000";
        address_slice_s  <= "01"; -- select block 1
        address_slice2_s <= "01"; -- tag mismatch
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 3: Invalid Block 2 (valid=0)
        -----------------------------------------------------
        cb0_bits_s <= "000";
        cb1_bits_s <= "000";
        cb2_bits_s <= "010"; -- valid=0, tag="10"
        cb3_bits_s <= "000";
        address_slice_s  <= "10"; -- select block 2
        address_slice2_s <= "10";
        wait for 20 ns;

        -----------------------------------------------------
        -- Test Case 4: Valid Hit on Block 3
        -----------------------------------------------------
        cb0_bits_s <= "000";
        cb1_bits_s <= "000";
        cb2_bits_s <= "000";
        cb3_bits_s <= "101"; -- valid=1, tag="01"
        address_slice_s  <= "11"; -- select block 3
        address_slice2_s <= "01"; -- tag matches
        wait for 20 ns;

        -----------------------------------------------------
        -- Simulation Done
        -----------------------------------------------------
        wait;
    end process;

end sim;
