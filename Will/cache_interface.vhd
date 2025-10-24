library IEEE;                      
use IEEE.std_logic_1164.all;       

entity cache_interface is                      
  port ( 
    address : in std_logic_vector(5 downto 0);
    data_in : in std_logic_vector(7 downto 0);
    rd_wr   : in std_logic;
    mem_enable : in std_logic; -- goes to decoders
    wr_tag  : in std_logic; -- for updating tag
    hit_miss: out std_logic;
    data_out: out std_logic_vector(7 downto 0)
  );
end cache_interface;                          

architecture structural of cache_interface is 
component cacheByte 
    port(
        chip_enable : in  std_logic;
        rd_wr       : in  std_logic;
        data_in     : in  std_logic_vector(7 downto 0);
        data_out    : out std_logic_vector(7 downto 0)
    );
end component;

component mux161
port(
        mux16_input : in  std_logic_vector(15 downto 0); -- 16 data inputs
        mux16_sel   : in  std_logic_vector(3 downto 0); -- 4-bit select
        mux16_out   : out std_logic -- output
    );
end component;

component mux42 is
    port(
        mux42_input : in  std_logic_vector(3 downto 0);  -- Inputs
        mux42_sel        : in  std_logic_vector(1 downto 0);  -- Select lines
        mux42_out              : out std_logic   -- Output
    );
end component;

component decoder24                   
  port ( 
    a	: in  std_logic_vector(1 downto 0);
    e	: in  std_logic;
    y	: out std_logic_vector(3 downto 0)
  );
end component;

component dff
    port(
        d    : in  std_logic;
        clk  : in  std_logic;
        q    : out std_logic --,
        --qbar : out std_logic
    );
end component;

component dff2bit 
    port(
        d       : in  std_logic_vector(1 downto 0);  -- Data inputs
        clk     : in  std_logic;                     -- Clock input
        enable  : in  std_logic;                     -- Load enable
        q       : out std_logic_vector(1 downto 0)   -- Outputs
    );
end component;

component and2
  port (
    input0   : in  std_logic;
    input1   : in  std_logic;
    output0   : out std_logic);
end component;

-- block and byte enables for enable matrix
signal block_enable : std_logic_vector(3 downto 0);
signal byte_enable : std_logic_vector(3 downto 0);

signal and_nets : std_logic_vector(15 downto 0);

signal tag_wr_enable : std_logic;
signal val_nets, tag0_nets, tag1_nets : std_logic_vector(3 downto 0);

begin
    -- enable decoders
    block_decoder : decoder24
    port map(
        a => address(3 downto 2),
        e => mem_enable,
        y => block_enable
    );

    byte_decoder : decoder24
    port map(
        a => address(1 downto 0),
        e => mem_enable,
        y => byte_enable
    );
    -- And matrix

    -- Cache Bytes
    cache_byte00 : cacheByte
    port map(
        
    );


end structural;