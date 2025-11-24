library IEEE;                      
use IEEE.std_logic_1164.all;       

entity mux413HML is                      
  port ( 
    cb0_bits : in std_logic_vector(2 downto 0); -- valid + tag1 + tag0
    cb1_bits : in std_logic_vector(2 downto 0);
    cb2_bits : in std_logic_vector(2 downto 0);
    cb3_bits : in std_logic_vector(2 downto 0);
    address_slice : in std_logic_vector(1 downto 0); -- select cache block
    address_slice2 : in std_logic_vector(1 downto 0); -- tag to compare
    hm_out        : out std_logic
  );
end mux413HML;                  

architecture structural of mux413HML is 

component hit_miss 
    port(
        tag_in    : in  std_logic_vector(1 downto 0);
        tag_cache : in  std_logic_vector(1 downto 0);
        valid     : in std_logic;
        hit_miss  : out std_logic
    );
end component;

component mux42
    port(
        mux42_input : in  std_logic_vector(3 downto 0);
        mux42_sel   : in  std_logic_vector(1 downto 0);
        mux42_out   : out std_logic
    );
end component;

-- Renamed signals to completely avoid collisions
signal val_cache_input   : std_logic_vector(3 downto 0);
signal tag1_cache_input  : std_logic_vector(3 downto 0);
signal tag0_cache_input  : std_logic_vector(3 downto 0);

signal val_cache_selected   : std_logic;
signal tag1_cache_selected  : std_logic;
signal tag0_cache_selected  : std_logic;

signal tag_cache_concat : std_logic_vector(1 downto 0);

begin

    -- Collect bits from cache blocks
    val_cache_input(3)  <= cb3_bits(2);
    val_cache_input(2)  <= cb2_bits(2);
    val_cache_input(1)  <= cb1_bits(2);
    val_cache_input(0)  <= cb0_bits(2);

    tag1_cache_input(3) <= cb3_bits(1);
    tag1_cache_input(2) <= cb2_bits(1);
    tag1_cache_input(1) <= cb1_bits(1);
    tag1_cache_input(0) <= cb0_bits(1);

    tag0_cache_input(3) <= cb3_bits(0);
    tag0_cache_input(2) <= cb2_bits(0);
    tag0_cache_input(1) <= cb1_bits(0);
    tag0_cache_input(0) <= cb0_bits(0);

    -- 4-to-1 multiplexers to select bits based on address_slice
    val_mux: mux42
        port map(
            mux42_input => val_cache_input,
            mux42_sel   => address_slice,
            mux42_out   => val_cache_selected
        );

    tag1_mux: mux42
        port map(
            mux42_input => tag1_cache_input,
            mux42_sel   => address_slice,
            mux42_out   => tag1_cache_selected
        );

    tag0_mux: mux42
        port map(
            mux42_input => tag0_cache_input,
            mux42_sel   => address_slice,
            mux42_out   => tag0_cache_selected
        );

    -- Concatenate tag bits
    tag_cache_concat(1) <= tag1_cache_selected; -- MSB
    tag_cache_concat(0) <= tag0_cache_selected; -- LSB

    -- Hit/miss check
    hit_miss_out : hit_miss
        port map(
            tag_in    => address_slice2,
            tag_cache => tag_cache_concat,
            valid     => val_cache_selected,
            hit_miss  => hm_out
        );

end structural;

