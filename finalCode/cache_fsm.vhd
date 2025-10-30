library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cache_fsm is
    Port (
        clk        : in  std_logic;
        reset      : in  std_logic;  -- Active high
        start      : in  std_logic;
        rd_wr_not  : in  std_logic;  -- 1 = read, 0 = write
        CVT        : in  std_logic;  -- Comparator: 1 = hit, 0 = miss
        counter    : in  integer range 0 to 31;
        Busy       : out std_logic;
        MAIN_MEM_EN : out std_logic;
        O_EN       : out std_logic;
        WR_TAG     : out std_logic;
        ST_SEL     : out std_logic;
        DATA_SEL   : out std_logic;
        M_EN       : out std_logic;
        B_OFFSET   : out std_logic_vector(1 downto 0);
        CS         : out std_logic_vector(4 downto 0);
		S_RESET : out std_logic;
        Next_State : out std_logic_vector(4 downto 0)
    );
end cache_fsm;

architecture Behavioral of cache_fsm is

    type state_type is (Idle, RD_Start, WR_Start, RD_HIT, WR_HIT, RD_MISS,
                        EN_Mem, DB_Mem, B_OFFSET0, B_DEN0, B_OFFSET1, B_DEN1,
                        B_OFFSET2, B_DEN2, B_OFFSET3, B_DEN3, ON_En, WR_MISS, Done);
    signal current_state, next_state_sig : state_type;
    signal busy_internal : std_logic := '0';
    signal oe_internal : std_logic := '0';
    signal m_en_internal : std_logic := '0';
    signal main_m_en_internal : std_logic := '0';
    signal b_offset_internal : std_logic_vector(1 downto 0);
    signal st_select_internal, data_select_internal : std_logic := '0';
	signal s_reset_internal : std_logic := '0';
	signal wr_tag_internal : std_logic := '0';
	signal s_reset_d        : std_logic := '0';
	signal reset_d1         : std_logic := '0';
begin


-------------------------------------------------------------
-- 1. Generate one-cycle S_RESET pulse (after reset rising)
-------------------------------------------------------------
process(clk)
begin
    if rising_edge(clk) then
        reset_d1 <= reset;

        -- Detect rising edge of reset, issue 1-cycle pulse
        if (reset = '1' and reset_d1 = '0') then
            s_reset_internal <= '1';
        else
            s_reset_internal <= '0';
        end if;
    end if;
end process;

S_RESET <= s_reset_internal;

-------------------------------------------------------------
-- 2. State register and Busy update (on falling edge)
-------------------------------------------------------------
process(clk)
begin
    if reset = '1' then
        current_state <= Idle;
        Busy          <= '0';
    elsif falling_edge(clk) then
        current_state <= next_state_sig;
        Busy          <= busy_internal;
    end if;
end process;



    process(current_state, start, rd_wr_not, CVT, counter, reset)
    begin
        next_state_sig <= current_state;

        case current_state is
            when Idle =>
                if reset = '1' then
                    next_state_sig <= Idle;
                elsif start = '1' then
                    if rd_wr_not = '1' then
                        next_state_sig <= RD_Start;
                    else
                        next_state_sig <= WR_Start;
                    end if;
                end if;

            when RD_Start =>
                if CVT = '1' then
                    next_state_sig <= RD_HIT;
                else
                    next_state_sig <= RD_MISS;
                end if;

            when RD_HIT =>
                if counter = 1 then
                    next_state_sig <= Done;
                else
                    next_state_sig <= RD_HIT;
                end if;

            when RD_MISS =>
                if counter = 1 then
                    next_state_sig <= EN_Mem;
                else
                    next_state_sig <= RD_MISS;
                end if;

            when EN_Mem =>
                if counter = 2 then
                    next_state_sig <= DB_Mem;
                else
                    next_state_sig <= EN_Mem;
                end if;

            when DB_Mem =>
                if counter = 10 then
                    next_state_sig <= B_OFFSET0;
                else
                    next_state_sig <= DB_Mem;
                end if;

            when B_OFFSET0 =>
                if counter = 11 then
                    next_state_sig <= B_DEN0;
                else
                    next_state_sig <= B_OFFSET0;
                end if;

            when B_DEN0 =>
                if counter = 12 then
                    next_state_sig <= B_OFFSET1;
                else
                    next_state_sig <= B_DEN0;
                end if;

            when B_OFFSET1 =>
                if counter = 13 then
                    next_state_sig <= B_DEN1;
                else
                    next_state_sig <= B_OFFSET1;
                end if;

            when B_DEN1 =>
                if counter = 14 then
                    next_state_sig <= B_OFFSET2;
                else
                    next_state_sig <= B_DEN1;
                end if;

            when B_OFFSET2 =>
                if counter = 15 then
                    next_state_sig <= B_DEN2;
                else
                    next_state_sig <= B_OFFSET2;
                end if;

            when B_DEN2 =>
                if counter = 16 then
                    next_state_sig <= B_OFFSET3;
                else
                    next_state_sig <= B_DEN2;
                end if;

            when B_OFFSET3 =>
                if counter = 17 then
                    next_state_sig <= B_DEN3;
                else
                    next_state_sig <= B_OFFSET3;
                end if;

            when B_DEN3 =>
                if counter = 18 then
                    next_state_sig <= ON_En;
                else
                    next_state_sig <= B_DEN3;
                end if;

            when ON_En =>
                if counter = 19 then
                    next_state_sig <= Done;
                else
                    next_state_sig <= ON_En;
                end if;

            when WR_Start =>
                if CVT = '1' then
                    next_state_sig <= WR_HIT;
                else
                    next_state_sig <= WR_MISS;
                end if;

            when WR_HIT =>
                if counter = 1 then
                    next_state_sig <= Done;
                else
                    next_state_sig <= WR_HIT;
                end if;

            when WR_MISS =>
                if counter = 1 then
                    next_state_sig <= Done;
                else
                    next_state_sig <= WR_MISS;
                end if;

            when Done =>
                next_state_sig <= Idle;

            when others =>
                next_state_sig <= Idle;
        end case;
    end process;
    
    -- process(next_state_sig)
	process(next_state_sig)
    begin
        case next_state_sig is
            when Idle | Done | RD_HIT =>
                busy_internal <= '0';
            when others =>
                busy_internal <= '1';
        end case;
    end process;
    process(current_state)
    begin
        --busy_internal <= '1';
        --m_en_internal <= '0';
        --st_select_internal <= '0';
        --data_select_internal <= '0';
        --b_offset_internal <= "00";
       -- main_m_en_internal <= '0';
	--            	oe_internal <= '1';
        case current_state is
            when Idle | Done=>
                m_en_internal <= '0';
                oe_internal <= '0';
				wr_tag_internal <= '0';
            when EN_Mem =>
                main_m_en_internal <= '1';
                st_select_internal <= '1';
                data_select_internal <= '1';
                m_en_internal <= '0';
            when ON_EN =>
            	oe_internal <= '1';
                st_select_internal <= '1';
                data_select_internal <= '1';
                m_en_internal <= '1';
				wr_tag_internal <= '1';
            when DB_Mem =>
            	main_m_en_internal <= '0';
                st_select_internal <= '1';
                data_select_internal <= '1';
            when B_OFFSET0 =>
                st_select_internal <= '1';
                data_select_internal <= '1';
                b_offset_internal <= "00";
                m_en_internal <= '1';
            when B_OFFSET1 =>
                st_select_internal <= '1';
                data_select_internal <= '1';
                b_offset_internal <= "01";
                m_en_internal <= '1';
            when B_OFFSET2 =>
                st_select_internal <= '1';
                data_select_internal <= '1';
                b_offset_internal <= "10";
                m_en_internal <= '1';
            when B_OFFSET3 =>
                st_select_internal <= '1';
                data_select_internal <= '1';
                b_offset_internal <= "11";
                m_en_internal <= '1';
            when B_DEN0 | B_DEN1 | B_DEN2 | B_DEN3 =>
                st_select_internal <= '1';
                data_select_internal <= '1';
                m_en_internal <= '0';
            when RD_MISS =>
            	st_select_internal <= '1';
                data_select_internal <= '1';
                m_en_internal <= '0';
            when WR_HIT =>
            	 m_en_internal <= '1';
            when WR_MISS =>
            	 m_en_internal <= '0';            
            when RD_HIT =>
            	 m_en_internal <= '1';
            when others =>
                m_en_internal <= '0';
                st_select_internal <= '0';
                data_select_internal <= '0';
                b_offset_internal <= "00";
                main_m_en_internal <= '0';
                oe_internal <= '0';
        end case;
    end process;
    

    MAIN_MEM_EN <= main_m_en_internal;
    ST_SEL <= st_select_internal;
    DATA_SEL <= data_select_internal;
    M_EN <= m_en_internal;
    B_OFFSET <= b_offset_internal;
    O_EN <= oe_internal;
	WR_TAG <= wr_tag_internal;

    CS <= std_logic_vector(to_unsigned(state_type'pos(current_state), 5));
    Next_State <= std_logic_vector(to_unsigned(state_type'pos(next_state_sig), 5));

end Behavioral;
