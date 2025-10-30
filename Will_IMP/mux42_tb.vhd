library IEEE;
use IEEE.std_logic_1164.all;

entity mux42_tb is
-- No ports for testbench
end mux42_tb;

architecture sim of mux42_tb is

    -- Component declaration
    component mux42
        port(
            mux42_input : in  std_logic_vector(3 downto 0);
            mux42_sel   : in  std_logic_vector(1 downto 0);
            mux42_out   : out std_logic
        );
    end component;

    -- Test signals
    signal tb_input  : std_logic_vector(3 downto 0);
    signal tb_sel    : std_logic_vector(1 downto 0);
    signal tb_output : std_logic;

begin

    -- Instantiate the DUT
    DUT: mux42
        port map(
            mux42_input => tb_input,
            mux42_sel   => tb_sel,
            mux42_out   => tb_output
        );

    -- Test process
    process
    begin
        -- Test case 1
        tb_input <= "0000"; tb_sel <= "00"; wait for 10 ns;
        tb_input <= "0000"; tb_sel <= "01"; wait for 10 ns;
        tb_input <= "0000"; tb_sel <= "10"; wait for 10 ns;
        tb_input <= "0000"; tb_sel <= "11"; wait for 10 ns;

        -- Test case 2
        tb_input <= "0001"; tb_sel <= "00"; wait for 10 ns;
        tb_input <= "0001"; tb_sel <= "01"; wait for 10 ns;
        tb_input <= "0001"; tb_sel <= "10"; wait for 10 ns;
        tb_input <= "0001"; tb_sel <= "11"; wait for 10 ns;

        -- Test case 3
        tb_input <= "0010"; tb_sel <= "00"; wait for 10 ns;
        tb_input <= "0010"; tb_sel <= "01"; wait for 10 ns;
        tb_input <= "0010"; tb_sel <= "10"; wait for 10 ns;
        tb_input <= "0010"; tb_sel <= "11"; wait for 10 ns;

        -- Test case 4
        tb_input <= "0011"; tb_sel <= "00"; wait for 10 ns;
        tb_input <= "0011"; tb_sel <= "01"; wait for 10 ns;
        tb_input <= "0011"; tb_sel <= "10"; wait for 10 ns;
        tb_input <= "0011"; tb_sel <= "11"; wait for 10 ns;

        -- Add more test cases as needed (0100 to 1111)
        -- Finish simulation
        wait;
    end process;

end sim;
