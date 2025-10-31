library IEEE;                      
use IEEE.std_logic_1164.all;       

entity addressToCacheE  is                  
    port ( 
        address : in std_logic_vector(3 downto 0);
        mem_enable : in std_logic;
        cacheByte_enable: out std_logic_vector(15 downto 0)
    );
    end addressToCacheE;

    architecture structural of addressToCacheE is 
    component decoder24                   
    port ( 
        a	: in  std_logic_vector(1 downto 0);
        e	: in  std_logic;
        y	: out std_logic_vector(3 downto 0)
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
    ----------------------------------
    --block 1 enable
    ----------------------------------
    and_00bytee : and2
    port map(
        input0  => block_enable(0),
        input1  => byte_enable(0),
        output0 => cacheByte_enable(0)
    );

    and_01bytee : and2
    port map(
        input0  => block_enable(0),
        input1  => byte_enable(1),
        output0 => cacheByte_enable(1)
    );
    
    and_02bytee : and2
    port map(
        input0  => block_enable(0),
        input1  => byte_enable(2),
        output0 => cacheByte_enable(2)
    );
    and_03bytee : and2
    port map(
        input0  => block_enable(0),
        input1  => byte_enable(3),
        output0 => cacheByte_enable(3)
    );
    ----------------------------------
    --block 2 enable
    ----------------------------------
    and_04bytee : and2
    port map(
        input0  => block_enable(1),
        input1  => byte_enable(0),
        output0 => cacheByte_enable(4)
    );

    and_05bytee : and2
    port map(
        input0  => block_enable(1),
        input1  => byte_enable(1),
        output0 => cacheByte_enable(5)
    );
    
    and_06bytee : and2
    port map(
        input0  => block_enable(1),
        input1  => byte_enable(2),
        output0 => cacheByte_enable(6)
    );
    and_07bytee : and2
    port map(
        input0  => block_enable(1),
        input1  => byte_enable(3),
        output0 => cacheByte_enable(7)
    );
    ----------------------------------

    ----------------------------------
    --block 3 enable
    ----------------------------------
    and_08bytee : and2
    port map(
        input0  => block_enable(2),
        input1  => byte_enable(0),
        output0 => cacheByte_enable(8)
    );

    and_09bytee : and2
    port map(
        input0  => block_enable(2),
        input1  => byte_enable(1),
        output0 => cacheByte_enable(9)
    );
    
    and_10bytee : and2
    port map(
        input0  => block_enable(2),
        input1  => byte_enable(2),
        output0 => cacheByte_enable(10)
    );
    and_11bytee : and2
    port map(
        input0  => block_enable(2),
        input1  => byte_enable(3),
        output0 => cacheByte_enable(11)
    );
    ----------------------------------
    --block 4 enable
    ----------------------------------
    and_12bytee : and2
    port map(
        input0  => block_enable(3),
        input1  => byte_enable(0),
        output0 => cacheByte_enable(12)
    );

    and_13bytee : and2
    port map(
        input0  => block_enable(3),
        input1  => byte_enable(1),
        output0 => cacheByte_enable(13)
    );
    
    and_14bytee : and2
    port map(
        input0  => block_enable(3),
        input1  => byte_enable(2),
        output0 => cacheByte_enable(14)
    );
    and_15bytee : and2
    port map(
        input0  => block_enable(3),
        input1  => byte_enable(3),
        output0 => cacheByte_enable(15)
    );
    ----------------------------------

end structural;

