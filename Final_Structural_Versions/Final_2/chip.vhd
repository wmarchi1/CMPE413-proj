library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
use IEEE.std_logic_arith.all;
use STD.textio.all;
  
entity chip is
    port (
        cpu_add    : in  std_logic_vector(5 downto 0);
        cpu_data_in   : inout  std_logic_vector(7 downto 0);
        cpu_rd_wrn : in  std_logic;
        start      : in  std_logic;
        clk        : in  std_logic;
        reset      : in  std_logic;
        mem_data   : in  std_logic_vector(7 downto 0);
        -- Vdd	 : in  std_logic;
        -- Gnd        : in  std_logic;
        busy       : out std_logic;
        mem_en     : out std_logic;
        mem_add    : out std_logic_vector(5 downto 0)
        ); 
end chip;
  
    architecture Structural of chip is
        component peripheral_interface2
            port (
                -- chip io
                rd_wr : in std_logic;
                reset : in std_logic;
                cpu_address : in std_logic_vector(5 downto 0);
                main_mem_data_in : in std_logic_vector(7 downto 0);
                cpu_data_in : in std_logic_vector(7 downto 0);
                cpu_data_out : out std_logic_vector(7 downto 0);
                data_out_enable : in std_logic;
                -- fsm io
                cache_mem_enable : in std_logic;
                byte_address    : in std_logic_vector(1 downto 0);
                byte_address_sel : in std_logic;
                vt_reset    : in std_logic;
                write_vt    : in std_logic;
                data_sel    : in std_logic;
                cvt         : out std_logic
            );
        end component;
        
        component and2
            port (
                input0   : in  std_logic;
                input1   : in  std_logic;
                output0   : out std_logic);
            end component;

        component or2 
            port (
                input0   : in  std_logic;
                input1   : in  std_logic;
                output0   : out std_logic);
            end component;
        
        component and3                       
            port ( x	: in  std_logic;
                y	: in  std_logic;
                z	: in  std_logic;
                o	: out std_logic);
            end component;

        component inv                      
            port ( 
                inv_input	: in  std_logic;
                inv_out: out std_logic);
            end component;


        component cache_controller_top
            port (
                clk        : in  std_logic;
                reset      : in  std_logic;
                start      : in  std_logic;
                rd_wr_not  : in  std_logic;
                CVT        : in  std_logic;
                Busy       : out std_logic;
                MAIN_MEM_EN : out std_logic;
                O_EN       : out std_logic;
                WR_TAG     : out std_logic;
                ST_SEL     : out std_logic;
                DATA_SEL   : out std_logic;
                M_EN       : out std_logic;
                B_OFFSET   : out std_logic_vector(1 downto 0);
                s_reset : out std_logic
            );
        end component;

        component dff
            port(
                d   : in  std_logic;   -- Data input
                clk : in  std_logic;   -- Clock input
                q   : out std_logic   -- Output
            );
        end component;

        component dff8bit_pos
            port(
                d   : in  std_logic_vector(7 downto 0);
                clk : in  std_logic;
                q   : out std_logic_vector(7 downto 0)
            );
        end component;
        component dff6bit_pos
            port(
                d   : in  std_logic_vector(5 downto 0);
                clk : in  std_logic;
                q   : out std_logic_vector(5 downto 0)
            );
        end component;

        signal busy_net, read_write_net1, read_write_net, cvt_net, counter_net, wr_tag_net, data_sel_net : std_logic;
        signal  cache_mem_enable_net, vt_reset_net, byte_address_sel_net, output_enable : std_logic;
        signal cpu_data_net : std_logic_vector(7 downto 0);
        signal cpu_address_net : std_logic_vector(5 downto 0);
        signal byte_off_net : std_logic_vector(1 downto 0);
        signal data_out_enable_net, start_bar : std_logic;
        signal byte_address_sel_net_bar, busy_net_bar, reset_net : std_logic;

    begin
        -- address register
        dff6bit_pos_inst0 : dff6bit_pos
            port map(
                d => cpu_add,
                clk => busy_net, 
                q => cpu_address_net
            );
        -- data input register
        dff8bit_pos_inst1 : dff8bit_pos
            port map(
                d => cpu_data_in,
                clk => busy_net,
                q => cpu_data_net
            );

        -- rd wr register
        dff_inst0 : dff
            port map(
                d => cpu_rd_wrn,
                clk => busy_net,
                q => read_write_net
            );

        inv_inst5 : inv                      
            port map ( 
                inv_input => byte_address_sel_net,
                inv_out => byte_address_sel_net_bar
                );

        and2_inst10 : and2
           port map (
                input0  => byte_address_sel_net_bar,
                input1  => read_write_net,
               output0  => read_write_net1
            );


        cache_controller_top_inst : cache_controller_top
            port map (
                clk  => clk,
                reset => reset,
                start  => start,
                rd_wr_not => cpu_rd_wrn,
                CVT       => cvt_net,
                Busy      => busy_net,
                MAIN_MEM_EN => mem_en,
                O_EN       => output_enable,
                WR_TAG     => wr_tag_net,
                ST_SEL     => byte_address_sel_net,
                DATA_SEL   => data_sel_net,
                M_EN       => cache_mem_enable_net, 
                B_OFFSET   => byte_off_net,
                s_reset    => vt_reset_net
            );

        inv_inst0 : inv                      
            port map ( 
                inv_input => start,
                inv_out => start_bar
                );

        and3_inst0 : and3
            port map(
                x	 => start_bar,
                y	 => read_write_net1,
                z	 => output_enable,
                o	 => data_out_enable_net
            );

        or2_inst0 : or2 
            port map (
                input0   => start,
                input1   => reset,
                output0  => reset_net
                );

        peripheral_interface2_inst : peripheral_interface2
            port map (
                -- chip io
                rd_wr => read_write_net1,
                reset => reset_net,
                cpu_address => cpu_address_net,
                main_mem_data_in => mem_data,
                cpu_data_in => cpu_data_net,
                cpu_data_out => cpu_data_in,
                data_out_enable => data_out_enable_net,
                -- fsm io
                cache_mem_enable => cache_mem_enable_net,
                byte_address    => byte_off_net,
                byte_address_sel => byte_address_sel_net,
                vt_reset    => vt_reset_net,
                write_vt    => wr_tag_net,
                data_sel    => data_sel_net,
                cvt         => cvt_net
            );

        busy <= busy_net;
        mem_add <= cpu_address_net;

    end structural;
