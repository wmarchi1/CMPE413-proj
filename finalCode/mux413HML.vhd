library IEEE;                      
use IEEE.std_logic_1164.all;       

entity mux413HML is                      
  port ( 
    cb0_bits : in std_logic_vector(2 downto 0); -- Expecting valid bit(2) + 2 tag bits(10)
    cb1_bits : in std_logic_vector(2 downto 0);
    cb2_bits : in std_logic_vector(2 downto 0);
    cb3_bits : in std_logic_vector(2 downto 0);
    address_slice : in std_logic_vector(1 downto 0); -- Expecting Ca[3,2]
    address_slice2 : in std_logic_vector(1 downto 0); -- Expecting Ca[5,4]
    hm_out        : out std_logic
  );
end mux413HML;                  

architecture structural of mux413HML is 

component hit_miss 
    port(
        tag_in  : in  std_logic_vector(1 downto 0);
        tag_cache  : in  std_logic_vector(1 downto 0);
        valid  : in std_logic;
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

signal val_out_bit : std_logic;
signal tag0_out_bit : std_logic;
signal tag1_out_bit : std_logic;

signal valBit_input : std_logic_vector(3 downto 0);
signal tag1Bit_input : std_logic_vector(3 downto 0);
signal tag0Bit_input : std_logic_vector(3 downto 0);

signal tag_concat : std_logic_vector(1 downto 0);

begin
    valBit_input <= cb3_bits(2) & cb2_bits(2) & cb1_bits(2) & cb0_bits(2);
    tag1Bit_input <= cb3_bits(1) & cb2_bits(1) & cb1_bits(1) & cb0_bits(1);
    tag0Bit_input <= cb3_bits(0) & cb2_bits(0) & cb1_bits(0) & cb0_bits(0);
    -- Selects the 
    valBit: mux42
        port map(
            mux42_input => valBit_input,
            mux42_sel   => address_slice,
            mux42_out   => val_out_bit
        );
    tag1Bit: mux42
        port map(
            mux42_input => tag1Bit_input,
            mux42_sel   => address_slice,
            mux42_out   => tag1_out_bit
        );
    tag0Bit: mux42
        port map(
            mux42_input => tag0Bit_input,
            mux42_sel   => address_slice,
            mux42_out   => tag0_out_bit
        );

    tag_concat <= tag1_out_bit & tag0_out_bit;

    hit_miss_out : hit_miss
        port map(
            tag_in => address_slice2,
            tag_cache  => tag_concat,
            valid => val_out_bit,
            hit_miss => hm_out
        );

end structural;