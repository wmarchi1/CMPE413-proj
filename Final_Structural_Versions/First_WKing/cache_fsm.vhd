library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cache_fsm is
    port(
        clk, reset, start, rd_wr_not, CVT : in  std_logic;
        counter_in : in std_logic_vector(4 downto 0);
        Busy, MAIN_MEM_EN, O_EN, WR_TAG,
        ST_SEL, DATA_SEL, M_EN, s_reset : out std_logic;
        B_OFFSET : out std_logic_vector(1 downto 0);
        CS      : out std_logic_vector(25 downto 0)
    );
end cache_fsm;

architecture Structural of cache_fsm is
    ----------------------------------------------------------------
    -- Component declarations
    ----------------------------------------------------------------
    component and2  port(input0,input1:in std_logic; output0:out std_logic); end component;
    component and3  port(x,y,z:in std_logic; o:out std_logic); end component;
    component and5  port(input0,input1,input2,input3,input4:in std_logic; output0:out std_logic); end component;
    component or2   port(input0,input1:in std_logic; output0:out std_logic); end component;
    component inv   port(inv_input:in std_logic; inv_out:out std_logic); end component;
    component dff_neg port(d,clk:in std_logic; q:out std_logic); end component;
    component dff port(d,clk:in std_logic; q:out std_logic); end component;
    ----------------------------------------------------------------
    -- Internal signals
    ----------------------------------------------------------------
    signal s : std_logic_vector(25 downto 0);
    signal d : std_logic_vector(25 downto 0);

    signal d18_from_rdd, d18_from_wdd, d18_from_rdmd, d18_from_wmdd : std_logic := '0';
    signal c, nc : std_logic_vector(4 downto 0) := (others => '0');

    signal n_start, n_rd, n_cvt, n_reset : std_logic := '0';
    signal eq1, eq2, eq3, eq4, eq5, eq6, eq7, eq8, eq9, eq10, eq11, eq12, eq13, eq14, eq15, eq16,
           eq17, eq18, eq19 : std_logic := '0';

    signal current_state_int : integer range 0 to 25;
    signal current_state_hex : std_logic_vector(4 downto 0);

    signal t_idle_from_done, t_idle_hold, t_idle_pre, t_idle_clear : std_logic := '0';
    signal done_a, done_b, done_all, temp_eq : std_logic := '0';
	signal rst_s1, rst_s2 : std_logic := '1';
        -- two-stage synchronized reset
	signal n_rst_s2       : std_logic;
	signal sreset_comb    : std_logic;
	signal sreset_q       : std_logic;        -- registered one-cycle pulse (recommended)
begin
    ----------------------------------------------------------------
    -- Inversions
    ----------------------------------------------------------------
    inv_start : inv port map(inv_input => start,     inv_out => n_start);
    inv_rd    : inv port map(inv_input => rd_wr_not, inv_out => n_rd);
    inv_cvt   : inv port map(inv_input => CVT,       inv_out => n_cvt);
    inv_reset : inv port map(inv_input => reset,     inv_out => n_reset);
--------------------------------------------------------------------
-- Synchronous reset detector (structural form, level-based)
--------------------------------------------------------------------

-- emulate first latch (posedge)
rst_s1 <= (reset and clk) or (rst_s1 and not clk);

-- emulate second latch (negedge)
rst_s2 <= (rst_s1 and not clk) or (rst_s2 and clk);

-- synchronized reset output
s_reset <= rst_s2;


-- 2) Output stays high while reset is high, turns off when reset goes low
--s_reset <= rst_s2;


	
    c <= counter_in;
    inv0 : inv port map(inv_input => c(0), inv_out => nc(0));
    inv1 : inv port map(inv_input => c(1), inv_out => nc(1));
    inv2 : inv port map(inv_input => c(2), inv_out => nc(2));
    inv3 : inv port map(inv_input => c(3), inv_out => nc(3));
    inv4 : inv port map(inv_input => c(4), inv_out => nc(4));

    ----------------------------------------------------------------
    -- Counter equality detectors
    ----------------------------------------------------------------
	-- 1  = 00001
	and5_1  : and5 port map(nc(4), nc(3), nc(2), nc(1),  c(0), eq1);
	-- 2  = 00010
	and5_2  : and5 port map(nc(4), nc(3), nc(2),  c(1), nc(0), eq2);
	-- 3  = 00011
	and5_3  : and5 port map(nc(4), nc(3), nc(2),  c(1),  c(0), eq3);
	-- 4  = 00100
	and5_4  : and5 port map(nc(4), nc(3),  c(2), nc(1), nc(0), eq4);
	-- 5  = 00101
	and5_5  : and5 port map(nc(4), nc(3),  c(2), nc(1),  c(0), eq5);
	-- 6  = 00110
	and5_6  : and5 port map(nc(4), nc(3),  c(2),  c(1), nc(0), eq6);
	-- 7  = 00111
	and5_7  : and5 port map(nc(4), nc(3),  c(2),  c(1),  c(0), eq7);
	-- 8  = 01000
	and5_8  : and5 port map(nc(4),  c(3), nc(2), nc(1), nc(0), eq8);
	-- 9  = 01001
	and5_9  : and5 port map(nc(4),  c(3), nc(2), nc(1),  c(0), eq9);
	-- 10 = 01010
	and5_10 : and5 port map(nc(4),  c(3), nc(2),  c(1), nc(0), eq10);
	-- 11 = 01011
	and5_11 : and5 port map(nc(4),  c(3), nc(2),  c(1),  c(0), eq11);
	-- 12 = 01100
	and5_12 : and5 port map(nc(4),  c(3),  c(2), nc(1), nc(0), eq12);
	-- 13 = 01101
	and5_13 : and5 port map(nc(4),  c(3),  c(2), nc(1),  c(0), eq13);
	-- 14 = 01110
	and5_14 : and5 port map(nc(4),  c(3),  c(2),  c(1), nc(0), eq14);
	-- 15 = 01111
	and5_15 : and5 port map(nc(4),  c(3),  c(2),  c(1),  c(0), eq15);
	-- 16 = 10000
	and5_16 : and5 port map( c(4), nc(3), nc(2), nc(1), nc(0), eq16);
	-- 17 = 10001
	and5_17 : and5 port map( c(4), nc(3), nc(2), nc(1),  c(0), eq17);
	-- 18 = 10010
	and5_18 : and5 port map( c(4), nc(3), nc(2),  c(1), nc(0), eq18);
	-- 19 = 10011
	and5_19 : and5 port map( c(4), nc(3), nc(2),  c(1),  c(0), eq19);



	temp_eq <= eq2 or eq3 or eq4 or eq5 or eq6 or eq7 or eq8 or eq9;
    ----------------------------------------------------------------
    -- Idle state (fixed feedback)
    ----------------------------------------------------------------
    -- Clear idle when start = 1
    and_idle_done : and2 port map(s(25), n_start, t_idle_from_done); -- Done → Idle
    and_idle_hold : and2 port map(s(0),  n_start, t_idle_hold);      -- Hold idle while start=0
    and_idle_clear: and2 port map(s(0),  start,   t_idle_clear);     -- Clear idle when start=1

    -- d(0) = reset OR (done·¬start) OR (idle·¬start)
    or_idle_pre   : or2 port map(reset, t_idle_from_done, t_idle_pre);
    or_idle_a     : or2 port map(t_idle_pre, t_idle_hold, d(0));

    -- Combine clear logic: q goes low when start=1 (no latch overlap)
    -- This is handled by structure since t_idle_hold disables when start=1

    ----------------------------------------------------------------
    -- Start, hit, miss, done logic
    ----------------------------------------------------------------
    and_rds : and3 port map(s(0), start, rd_wr_not, d(1));
    and_wrs : and3 port map(s(0), start, n_rd,      d(2));

    and_rdh : and2 port map(s(1), CVT,  d(3));
    and2_rdd : and2 port map(s(3), eq1, d18_from_rdd);

    and_wrh : and2 port map(s(2), CVT,  d(4));
    and_wdd : and2 port map(s(4), eq1, d18_from_wdd);

    and_rdm   : and2 port map(s(1),  n_cvt, d(5));
    and_enm   : and2 port map(s(5),  eq1,   d(6));
	and_dbm : and2 port map(s(6), eq2, d(7));	
	and_hold_1 : and2 port map(s(7), eq3, d(8));
	and_hold_2 : and2 port map(s(8), eq4, d(9));
	and_hold_3 : and2 port map(s(9), eq5, d(10));
	and_hold_4 : and2 port map(s(10), eq6, d(11));
	and_hold_5 : and2 port map(s(11), eq7, d(12));
	and_hold_6 : and2 port map(s(12), eq8, d(13));
	and_hold_7 : and2 port map(s(13), eq9, d(14));
    and_b0    : and2 port map(s(14),  eq10,  d(15));
    and_d0    : and2 port map(s(15),  eq11,  d(16));
    and_b1    : and2 port map(s(16),  eq12,  d(17));
    and_d1    : and2 port map(s(17), eq13,  d(18));
    and_b2    : and2 port map(s(18), eq14,  d(19));
    and_d2    : and2 port map(s(19), eq15,  d(20));
    and_b3    : and2 port map(s(20), eq16,  d(21));
    and_d3    : and2 port map(s(21), eq17,  d(22));
    and_onen  : and2 port map(s(22), eq18,  d(23));
    and_rdmd  : and2 port map(s(23), eq19,  d18_from_rdmd);

    and_wrm  : and2 port map(s(2),  n_cvt, d(24));
    and_wmdd : and2 port map(s(24), eq1,   d18_from_wmdd);

    or_done_a : or2 port map(d18_from_rdd, d18_from_wdd,  done_a);
    or_done_b : or2 port map(d18_from_rdmd, d18_from_wmdd, done_b);
    or_done_c : or2 port map(done_a, done_b, done_all);
    d(25) <= done_all;

    ----------------------------------------------------------------
    -- 26 D flip-flops (neg-edge)
    ----------------------------------------------------------------
    dff0  : dff_neg port map(d(0),  clk, s(0));
    dff1  : dff_neg port map(d(1),  clk, s(1));
    dff2  : dff_neg port map(d(2),  clk, s(2));
    dff3  : dff_neg port map(d(3),  clk, s(3));
    dff4  : dff_neg port map(d(4),  clk, s(4));
    dff5  : dff_neg port map(d(5),  clk, s(5));
    dff6  : dff_neg port map(d(6),  clk, s(6));
    dff7  : dff_neg port map(d(7),  clk, s(7));
    dff8  : dff_neg port map(d(8),  clk, s(8));
    dff9  : dff_neg port map(d(9),  clk, s(9));
    dff10 : dff_neg port map(d(10), clk, s(10));
    dff11 : dff_neg port map(d(11), clk, s(11));
    dff12 : dff_neg port map(d(12), clk, s(12));
    dff13 : dff_neg port map(d(13), clk, s(13));
    dff14 : dff_neg port map(d(14), clk, s(14));
    dff15 : dff_neg port map(d(15), clk, s(15));
    dff16 : dff_neg port map(d(16), clk, s(16));
    dff17 : dff_neg port map(d(17), clk, s(17));
    dff18 : dff_neg port map(d(18), clk, s(18));
    dff19 : dff_neg port map(d(19), clk, s(19));
    dff20 : dff_neg port map(d(20), clk, s(20));
    dff21 : dff_neg port map(d(21), clk, s(21));
    dff22 : dff_neg port map(d(22), clk, s(22));
    dff23 : dff_neg port map(d(23), clk, s(23));
    dff24 : dff_neg port map(d(24), clk, s(24));
    dff25 : dff_neg port map(d(25), clk, s(25));
    ----------------------------------------------------------------
    -- State monitor (for visualization)
    ----------------------------------------------------------------
    process(s)
    begin
        current_state_int <= 0;
        for i in 0 to 25 loop
            if s(i) = '1' then
                current_state_int <= i;
            end if;
        end loop;
        current_state_hex <= std_logic_vector(to_unsigned(current_state_int, 5));
    end process;

    ----------------------------------------------------------------
    -- Output logic
    ----------------------------------------------------------------
    MAIN_MEM_EN <= s(6);
    M_EN        <= s(3) or s(4) or s(15) or s(17) or s(19) or s(21) or s(23);
    Busy        <= s(1) or s(2) or s(4) or s(5) or s(6) or
                   s(7) or s(8) or s(9) or s(10) or s(11) or s(12) or
                   s(13) or s(14) or s(15) or s(16) or s(17) or s(18) or s(19) or s(20) or s(21) or s(22) or s(23) or s(24);
    DATA_SEL    <= s(5) or s(6) or s(7) or s(8) or s(9) or s(10) or s(11) or s(12) or s(13) or s(14) or s(15) or s(16) or s(17) or s(18) or s(19) or s(20) or s(21) or s(22) or s(23);
    ST_SEL      <= s(7) or s(8) or s(9) or s(10) or s(11) or s(12) or s(13) or s(14) or s(15) or s(16) or s(17) or s(18) or s(19) or s(20) or s(21);
    WR_TAG      <= s(23) or rst_s2;
    O_EN        <= s(0) or s(25);
    B_OFFSET(0) <= s(16)  or s(17) or s(20) or s(21);
    B_OFFSET(1) <= s(18) or s(19) or s(20) or s(21);
    CS          <= d;
	

end Structural;