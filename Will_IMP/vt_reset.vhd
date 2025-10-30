library IEEE;                      
use IEEE.std_logic_1164.all;       

entity vt_interface is                      
  port ( 
    address5_2 : in std_logic_vector(3 downto 0); -- Expecting Ca[5,2]
    write_vt  : in std_logic
  );
end vt_interface;                  

architecture structural of vt_interface is

component mux413HML
        port ( 
            cb0_bits : in std_logic_vector(2 downto 0);
            cb1_bits : in std_logic_vector(2 downto 0);
            cb2_bits : in std_logic_vector(2 downto 0);
            cb3_bits : in std_logic_vector(2 downto 0);
            address_slice  : in std_logic_vector(1 downto 0);
            address_slice2 : in std_logic_vector(1 downto 0);
            hm_out : out std_logic
        );
    end component;

component vt_regs
        port (
            address_s : in std_logic_vector(3 downto 0);
            write_vt  : in std_logic;
            valid_bit : in std_logic;
            cb0_bits  : out std_logic_vector(2 downto 0);
            cb1_bits  : out std_logic_vector(2 downto 0);
            cb2_bits  : out std_logic_vector(2 downto 0);
            cb3_bits  : out std_logic_vector(2 downto 0)
        );
    end component;

signal cb0_bits_net  : std_logic_vector(2 downto 0);
signal cb1_bits_net  : std_logic_vector(2 downto 0);
signal cb2_bits_net  : std_logic_vector(2 downto 0);
signal cb3_bits_net  : std_logic_vector(2 downto 0);

begin

vt_regs_inst: vt_regs
        port map (
            address_s => address5_2,
            write_vt  => write_vt,
            valid_bit => '1',
            cb0_bits  => cb0_bits_net,
            cb1_bits  => cb1_bits_net,
            cb2_bits  => cb2_bits_net,
            cb3_bits  => cb3_bits_net
        );

mux413HML_inst : mux413HML
        port map(
            cb0_bits => cb0_bits_net,
            cb1_bits => cb1_bits_net,
            cb2_bits => cb2_bits_net,
            cb3_bits => cb3_bits_net,
            address_slice  => address5_2(1 downto 0), -- 3, 2
            address_slice2 => address5_2(3 downto 2), -- 5,4
            hm_out => hit_miss
        );

end structural;
