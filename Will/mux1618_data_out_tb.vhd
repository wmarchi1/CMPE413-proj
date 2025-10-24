--exec xvhdl and2.vhd or2.vhd inv.vhd mux21.vhd mux21_tb.vhd mux42.vhd mux161.vhd mux1618_data_out.vhd mux1618_data_out_tb.vhd
--exec xelab mux1618_data_out_tb -debug typical -s sim_out

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux1618_data_out_tb is
end mux1618_data_out_tb;

architecture tb of mux1618_data_out_tb is

    --------------------------------------------------------------------
    -- DUT Declaration
    --------------------------------------------------------------------
    component mux1618_data_out
        port(
            byte_data_in0  : in  std_logic_vector(7 downto 0);
            byte_data_in1  : in  std_logic_vector(7 downto 0);
            byte_data_in2  : in  std_logic_vector(7 downto 0);
            byte_data_in3  : in  std_logic_vector(7 downto 0);
            byte_data_in4  : in  std_logic_vector(7 downto 0);
            byte_data_in5  : in  std_logic_vector(7 downto 0);
            byte_data_in6  : in  std_logic_vector(7 downto 0);
            byte_data_in7  : in  std_logic_vector(7 downto 0);
            byte_data_in8  : in  std_logic_vector(7 downto 0);
            byte_data_in9  : in  std_logic_vector(7 downto 0);
            byte_data_in10 : in  std_logic_vector(7 downto 0);
            byte_data_in11 : in  std_logic_vector(7 downto 0);
            byte_data_in12 : in  std_logic_vector(7 downto 0);
            byte_data_in13 : in  std_logic_vector(7 downto 0);
            byte_data_in14 : in  std_logic_vector(7 downto 0);
            byte_data_in15 : in  std_logic_vector(7 downto 0);
            mux1618_sel    : in  std_logic_vector(3 downto 0);
            mux1618_out    : out std_logic_vector(7 downto 0)
        );
    end component;

    --------------------------------------------------------------------
    -- Signals
    --------------------------------------------------------------------
    signal byte_data_in0,  byte_data_in1,  byte_data_in2,  byte_data_in3  : std_logic_vector(7 downto 0);
    signal byte_data_in4,  byte_data_in5,  byte_data_in6,  byte_data_in7  : std_logic_vector(7 downto 0);
    signal byte_data_in8,  byte_data_in9,  byte_data_in10, byte_data_in11 : std_logic_vector(7 downto 0);
    signal byte_data_in12, byte_data_in13, byte_data_in14, byte_data_in15 : std_logic_vector(7 downto 0);
    signal mux1618_sel    : std_logic_vector(3 downto 0);
    signal mux1618_out    : std_logic_vector(7 downto 0);

begin
    --------------------------------------------------------------------
    -- DUT Instantiation
    --------------------------------------------------------------------
    DUT: mux1618_data_out
        port map(
            byte_data_in0  => byte_data_in0,
            byte_data_in1  => byte_data_in1,
            byte_data_in2  => byte_data_in2,
            byte_data_in3  => byte_data_in3,
            byte_data_in4  => byte_data_in4,
            byte_data_in5  => byte_data_in5,
            byte_data_in6  => byte_data_in6,
            byte_data_in7  => byte_data_in7,
            byte_data_in8  => byte_data_in8,
            byte_data_in9  => byte_data_in9,
            byte_data_in10 => byte_data_in10,
            byte_data_in11 => byte_data_in11,
            byte_data_in12 => byte_data_in12,
            byte_data_in13 => byte_data_in13,
            byte_data_in14 => byte_data_in14,
            byte_data_in15 => byte_data_in15,
            mux1618_sel    => mux1618_sel,
            mux1618_out    => mux1618_out
        );

    --------------------------------------------------------------------
    -- TEST PROCESS (no loops)
    --------------------------------------------------------------------
    process
    begin
        ----------------------------------------------------------------
        -- Initialize input bytes with known values
        ----------------------------------------------------------------
        byte_data_in0  <= x"00"; byte_data_in1  <= x"11";
        byte_data_in2  <= x"22"; byte_data_in3  <= x"33";
        byte_data_in4  <= x"44"; byte_data_in5  <= x"55";
        byte_data_in6  <= x"66"; byte_data_in7  <= x"77";
        byte_data_in8  <= x"88"; byte_data_in9  <= x"99";
        byte_data_in10 <= x"AA"; byte_data_in11 <= x"BB";
        byte_data_in12 <= x"CC"; byte_data_in13 <= x"DD";
        byte_data_in14 <= x"EE"; byte_data_in15 <= x"FF";

        ----------------------------------------------------------------
        --report "Starting mux1618_data_out tests" severity note;

        ----------------------------------------------------------------
        -- TEST 1: Select input 0
        ----------------------------------------------------------------
        mux1618_sel <= "0000";
        wait for 10 ns;
        --report "SEL=0 => OUT=" & to_hstring(mux1618_out);

        ----------------------------------------------------------------
        -- TEST 2: Select input 3
        ----------------------------------------------------------------
        mux1618_sel <= "0011";
        wait for 10 ns;
        --report "SEL=3 => OUT=" & to_hstring(mux1618_out);

        ----------------------------------------------------------------
        -- TEST 3: Select input 7
        ----------------------------------------------------------------
        mux1618_sel <= "0111";
        wait for 10 ns;
        --report "SEL=7 => OUT=" & to_hstring(mux1618_out);

        ----------------------------------------------------------------
        -- TEST 4: Select input 10
        ----------------------------------------------------------------
        mux1618_sel <= "1010";
        wait for 10 ns;
        --report "SEL=10 => OUT=" & to_hstring(mux1618_out);

        ----------------------------------------------------------------
        -- TEST 5: Select input 15
        ----------------------------------------------------------------
        mux1618_sel <= "1111";
        wait for 10 ns;
        --report "SEL=15 => OUT=" & to_hstring(mux1618_out);

        ----------------------------------------------------------------
        --report "✅ All mux1618_data_out tests completed." severity note;
        wait;
    end process;

end tb;
