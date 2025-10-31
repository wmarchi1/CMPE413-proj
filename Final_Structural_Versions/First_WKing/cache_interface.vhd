library IEEE;                      
use IEEE.std_logic_1164.all;       

entity cache_interface is                      
  port ( 
    rd_wr : in std_logic;
    mem_enable : in std_logic;
    block_off : in std_logic_vector(1 downto 0);
    byte_off  : in std_logic_vector(1 downto 0);
    data_input : in std_logic_vector(7 downto 0);
    data_output : out std_logic_vector(7 downto 0)
  );
end cache_interface;          

architecture structural of cache_interface is

    component addressToCacheE
            port(
                address          : in  std_logic_vector(3 downto 0);
                mem_enable       : in  std_logic;
                cacheByte_enable : out std_logic_vector(15 downto 0)
            );
        end component;

    component cache16Byte
            port(
                byte_data_in   : in  std_logic_vector(7 downto 0);
                rd_wr_sig      : in  std_logic;
                enable_vector  : in  std_logic_vector(15 downto 0);
                byte_data_out0 : out std_logic_vector(7 downto 0);
                byte_data_out1 : out std_logic_vector(7 downto 0);
                byte_data_out2 : out std_logic_vector(7 downto 0);
                byte_data_out3 : out std_logic_vector(7 downto 0);
                byte_data_out4 : out std_logic_vector(7 downto 0);
                byte_data_out5 : out std_logic_vector(7 downto 0);
                byte_data_out6 : out std_logic_vector(7 downto 0);
                byte_data_out7 : out std_logic_vector(7 downto 0);
                byte_data_out8 : out std_logic_vector(7 downto 0);
                byte_data_out9 : out std_logic_vector(7 downto 0);
                byte_data_out10 : out std_logic_vector(7 downto 0);
                byte_data_out11 : out std_logic_vector(7 downto 0);
                byte_data_out12 : out std_logic_vector(7 downto 0);
                byte_data_out13 : out std_logic_vector(7 downto 0);
                byte_data_out14 : out std_logic_vector(7 downto 0);
                byte_data_out15 : out std_logic_vector(7 downto 0)
            );
        end component;

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

    signal net_cacheEnable : std_logic_vector(15 downto 0);
    signal net_byte0, net_byte1, net_byte2, net_byte3, net_byte4, net_byte5, net_byte6, net_byte7 : std_logic_vector(7 downto 0);
    signal net_byte8, net_byte9, net_byte10, net_byte11, net_byte12, net_byte13, net_byte14, net_byte15 : std_logic_vector(7 downto 0);
    signal net_address : std_logic_vector(3 downto 0); 

begin
    
    net_address <= block_off & byte_off;

    atce_inst : addressToCacheE
        port map(
            address          => net_address,
            mem_enable       => mem_enable,
            cacheByte_enable => net_cacheEnable
        );
    
    c16b_inst : cache16Byte
        port map(
            byte_data_in   => data_input,
            rd_wr_sig      => rd_wr,
            enable_vector  => net_cacheEnable,
            byte_data_out0 => net_byte0,
            byte_data_out1 => net_byte1,
            byte_data_out2 => net_byte2,
            byte_data_out3 => net_byte3,
            byte_data_out4 => net_byte4,
            byte_data_out5 => net_byte5,
            byte_data_out6 => net_byte6,
            byte_data_out7 => net_byte7,
            byte_data_out8 => net_byte8,
            byte_data_out9 => net_byte9,
            byte_data_out10 => net_byte10,
            byte_data_out11 => net_byte11,
            byte_data_out12 => net_byte12,
            byte_data_out13 => net_byte13,
            byte_data_out14 => net_byte14,
            byte_data_out15 => net_byte15
        );

    m1618do_inst: mux1618_data_out
        port map(
            byte_data_in0  => net_byte0,
            byte_data_in1  => net_byte1,
            byte_data_in2  => net_byte2,
            byte_data_in3  => net_byte3,
            byte_data_in4  => net_byte4,
            byte_data_in5  => net_byte5,
            byte_data_in6  => net_byte6,
            byte_data_in7  => net_byte7,
            byte_data_in8  => net_byte8,
            byte_data_in9  => net_byte9,
            byte_data_in10 => net_byte10,
            byte_data_in11 => net_byte11,
            byte_data_in12 => net_byte12,
            byte_data_in13 => net_byte13,
            byte_data_in14 => net_byte14,
            byte_data_in15 => net_byte15,
            mux1618_sel    => net_address,
            mux1618_out    => data_output
        );
    
end structural;