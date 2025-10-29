
library IEEE;                      
use IEEE.std_logic_1164.all;       

entity peripheral_interface2 is                      
  port (
        -- chip io
        rd_wr : in std_logic;
        start : in std_logic;
        reset : in std_logic;
        cpu_address : in std_logic_vector(7 downto 0);
        main_mem_data_in : in std_logic_vector(7 downto 0);
        cpu_data_in : inout std_logic_vector(7 downto 0);
        --cpu_data_out : out std_logic_vector(7 downto 0);
        -- fsm io
        cache_mem_enable : in std_logic;
        byte_address    : in std_logic_vector( 1 downto 0);
        byte_address_sel : in std_logic;
        vt_reset    : in std_logic;
        write_vt    : in std_logic;
        data_sel    : in std_logic;
        busy        : in std_logic;
        cvt         : out std_logic;

        --testing
        byte_off_mux_output : out std_logic_vector(1 downto 0);
        data_mux_output : out std_logic_vector(7 downto 0)
        );

end peripheral_interface2;                          

architecture structural of peripheral_interface2 is 

component cache_interface
        port ( 
            rd_wr        : in std_logic;
            mem_enable   : in std_logic;
            block_off    : in std_logic_vector(1 downto 0);
            byte_off     : in std_logic_vector(1 downto 0);
            data_input   : in std_logic_vector(7 downto 0);
            data_output  : out std_logic_vector(7 downto 0)
        );
    end component;

component vt_interface
        port (
            address5_2 : in std_logic_vector(3 downto 0);
            reset      : in std_logic; 
            valid      : in std_logic;
            write_vt   : in std_logic;
            hit_miss   : out std_logic
        );
    end component;

component inv                      
  port ( inv_input	: in  std_logic;
         inv_out: out std_logic);
 end component;

component mux218
    port(
        input0   : in  std_logic_vector(7 downto 0);  -- Input 0 (sel 0)
        input1   : in  std_logic_vector(7 downto 0);  -- Input 1 (sel 1)
        sel_bit  : in  std_logic;  -- Select
        y   : out std_logic_vector(7 downto 0)   -- Output
    );
 end component;

component mux212
    port(
        input0   : in  std_logic_vector(1 downto 0);  -- Input 0 (sel 0)
        input1   : in  std_logic_vector(1 downto 0);  -- Input 1 (sel 1)
        sel_bit  : in  std_logic;  -- Select
        y   : out std_logic_vector(1 downto 0)   -- Output
    );
 end component;

component dff8bit_pos 
    port(
        d   : in  std_logic_vector(7 downto 0);
        clk : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end component;

component tx8bit                  
  port ( sel   : in std_logic;
         selnot: in std_logic;
         tx_input : in std_logic_vector(7 downto 0);
         tx_output:out std_logic_vector(7 downto 0));
end component; 

signal busy_bar, read_write_net_bar, reset_bar : std_logic;
signal data_to_cache, data_from_cache, data_out_reg, data_out_tx : std_logic_vector(7 downto 0);
signal byte_off_to_cache : std_logic_vector(1 downto 0);

begin 

-- Mux for data selection
mux218_inst0 : mux218 
    port map(
        input0 => cpu_data_in,
        input1 => main_mem_data_in,
        sel_bit => data_sel,
        y => data_to_cache
    );
data_mux_output <= data_to_cache;

-- Mux for byte offset selection
mux212_inst0 : mux212
    port map(
        input0 => cpu_address(1 downto 0), -- fix this
        input1 => byte_address,
        sel_bit => byte_address_sel,
        y => byte_off_to_cache
    );
byte_off_mux_output <= byte_off_to_cache;

--cahce interface
cache_interface_inst0: cache_interface
        port map(
           rd_wr       => rd_wr,
            mem_enable  => cache_mem_enable,
            block_off   => cpu_address(3 downto 2),
           byte_off    => byte_off_to_cache,
            data_input  => data_to_cache,
            data_output => data_from_cache
        );

---------------------------
-- data_from_cache register
inv_inst0 : inv
        port map(
            inv_input => busy,
            inv_out   => busy_bar
        );

dff8bit_pos_inst2 : dff8bit_pos
        port map(
            d => data_from_cache,
            clk => busy_bar,
            q => data_out_reg
        );
---------------------------
-- txx8 data_out_from_reg
inv_inst1 : inv
        port map(
            inv_input => rd_wr,
            inv_out   => read_write_net_bar
        ); 

tx8bit_inst0 : tx8bit
        port map(
            sel => rd_wr,
            selnot => read_write_net_bar,
            tx_input => data_out_reg,
            tx_output => cpu_data_in
        );
--cpu_data_out <= data_out_tx; --Gunna cause problems
----------------------------
-- vt_interface
inv_inst2 : inv
        port map(
            inv_input => reset,
            inv_out   => reset_bar
        ); 

vt_interface_inst0: vt_interface
        port map(
            address5_2 => cpu_address(5 downto 2),
            reset      => vt_reset,
            valid      => reset_bar,
            write_vt   => write_vt,
            hit_miss   => cvt
    );

end structural;  
