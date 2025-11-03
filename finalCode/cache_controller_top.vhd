library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cache_controller_top is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        start       : in  std_logic;
        rd_wr_not   : in  std_logic;
        CVT         : in  std_logic;
        MAIN_MEM_EN : out std_logic;
        O_EN        : out std_logic;
        WR_TAG      : out std_logic;
        ST_SEL      : out std_logic;
        DATA_SEL    : out std_logic;
        M_EN        : out std_logic;
        B_OFFSET    : out std_logic_vector(1 downto 0);
        Busy        : out std_logic;
		s_reset : out std_logic
    );
end cache_controller_top;

architecture Structural of cache_controller_top is

    --------------------------------------------------------------------
    -- Component Declarations
    --------------------------------------------------------------------
    component cache_fsm
        Port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            start       : in  std_logic;
            rd_wr_not   : in  std_logic;
            CVT         : in  std_logic;
            counter_in     : in std_logic_vector(4 downto 0);
            Busy        : out std_logic;
            MAIN_MEM_EN : out std_logic;
            O_EN        : out std_logic;
            WR_TAG      : out std_logic;
            ST_SEL      : out std_logic;
            DATA_SEL    : out std_logic;
            M_EN        : out std_logic;
            B_OFFSET    : out std_logic_vector(1 downto 0);
			s_reset : out std_logic
        );
    end component;

    component program_counter
        Port (
            clk   : in  std_logic;
            reset : in  std_logic;
            busy  : in  std_logic;
            q     : out std_logic_vector(4 downto 0)
        );
    end component;
	component inv   port(inv_input:in std_logic; inv_out:out std_logic); end component;
    --------------------------------------------------------------------
    -- Internal Signals
    --------------------------------------------------------------------
    signal counter_bits : std_logic_vector(4 downto 0);
    signal counter_int  : integer range 0 to 31;
    signal Busy_sig, oe_sig, n_oe_sig     : std_logic;

begin
    --------------------------------------------------------------------
    -- Instantiate Program Counter
    --------------------------------------------------------------------
    pc_inst : program_counter
        port map (
            clk   => clk,
            reset => reset,
            busy  => Busy_sig,       -- driven by FSM Busy
            q     => counter_bits
        );
    inv_oe : inv port map(inv_input => oe_sig,     inv_out => n_oe_sig);
    --------------------------------------------------------------------
    -- Instantiate FSM
    --------------------------------------------------------------------
    fsm_inst : cache_fsm
        port map (
            clk         => clk,
            reset       => reset,
            start       => start,
            rd_wr_not   => rd_wr_not,
            CVT         => CVT,
            counter_in     => counter_bits,
            Busy        => Busy_sig,
            MAIN_MEM_EN => MAIN_MEM_EN,
            O_EN        => O_EN,
            WR_TAG      => WR_TAG,
            ST_SEL      => ST_SEL,
            DATA_SEL    => DATA_SEL,
            M_EN        => M_EN,
            B_OFFSET    => B_OFFSET,
			s_reset     => s_reset
        );
    --------------------------------------------------------------------
    -- Drive top-level Busy output
    --------------------------------------------------------------------
    Busy <= Busy_sig;
end Structural;