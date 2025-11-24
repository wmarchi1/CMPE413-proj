
-- Creates registers that hold valid and tag bits for each cache block
-- Updates Val and Tag for a given block, updates on rising edge of write_vt
library IEEE;                      
use IEEE.std_logic_1164.all;       

entity vt_regs is                      
  port ( 
    address_s : in std_logic_vector(3 downto 0); -- Expecting Ca[7,4]
    write_vt       : in std_logic;
    reset    : in std_logic;
    valid    : in std_logic;
    cb0_bits : out std_logic_vector(2 downto 0); -- Expecting valid bit(2) + 2 tag bits(10)
    cb1_bits : out std_logic_vector(2 downto 0);
    cb2_bits : out std_logic_vector(2 downto 0);
    cb3_bits : out std_logic_vector(2 downto 0)
  );
end vt_regs;                  

architecture structural of vt_regs is 

  component dff2bit 
      port(
          d   : in  std_logic_vector(1 downto 0);
          clk : in  std_logic;
          q   : out std_logic_vector(1 downto 0)
      );
  end component;

  component dff
        port(
            d   : in  std_logic;
            clk : in  std_logic;
            q   : out std_logic
        );
    end component;

  component dlatch
    port(
        d   : in  std_logic;   -- Data input
        clk : in  std_logic;   -- Clock input
        q   : out std_logic   -- Output
    );
  end component;

  component decoder24_weird               
  port ( 
    a	: in  std_logic_vector(1 downto 0);
    reset	: in  std_logic;
    y	: out std_logic_vector(3 downto 0)
  );
  end component;

  component inv
  port(
	  inv_input	: in std_logic;
	  inv_out	: out std_logic
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

  signal dout, en : std_logic_vector(3 downto 0);
  signal reset_not : std_logic;
  signal valid_enable : std_logic_vector(3 downto 0);

begin

  decode : decoder24_weird
    port map (
      a => address_s(1 downto 0),
      reset => '0', -- probably going to cause issues
      y => dout
    );
  --------------------------------------------------
  and2_inst0 : and2
    port map (
      input0 => dout(0),
      input1 => write_vt,
      output0 => en(0)
    );
  
  and2_inst1 : and2
    port map (
      input0 => dout(1),
      input1 => write_vt,
      output0 => en(1)
    );

  and2_inst2 : and2
    port map (
      input0 => dout(2),
      input1 => write_vt,
      output0 => en(2)
    );
  
  and2_inst3 : and2
    port map (
      input0 => dout(3),
      input1 => write_vt,
      output0 => en(3)
    );
  --------------------------------------------------

  or2_inst0 : or2
  port map (
    input0 => en(0),
    input1 => reset,
    output0 => valid_enable(0));

  or2_inst1 : or2
  port map (
    input0 => en(1),
    input1 => reset,
    output0 => valid_enable(1));

  or2_inst2 : or2
  port map (
    input0 => en(2),
    input1 => reset,
    output0 => valid_enable(2));

  or2_inst3 : or2
  port map (
    input0 => en(3),
    input1 => reset,
    output0 => valid_enable(3));
  -------------------------------------------------

  dff_inst0 : dlatch
    port map(
      d => valid,
      clk => valid_enable(0),
      q => cb0_bits(2)
    );

  dff_inst1 : dlatch
    port map(
      d => valid,
      clk => valid_enable(1),
      q => cb1_bits(2)
    );
  
  dff_inst2 : dlatch
    port map(
      d => valid,
      clk => valid_enable(2),
      q => cb2_bits(2)
    );

  dff_inst3 : dlatch
    port map(
      d => valid,
      clk => valid_enable(3),
      q => cb3_bits(2)
    );

  -------------------------------------------------
  dff2bit_int0 : dff2bit
    port map(
      d => address_s(3 downto 2),
      clk => en(0),
      q => cb0_bits(1 downto 0)
    );

  dff2bit_int1 : dff2bit
    port map(
      d => address_s(3 downto 2),
      clk => en(1),
      q => cb1_bits(1 downto 0)
    );
  
  dff2bit_int2 : dff2bit
    port map(
      d => address_s(3 downto 2),
      clk => en(2),
      q => cb2_bits(1 downto 0)
    );

  dff2bit_int3 : dff2bit
    port map(
      d => address_s(3 downto 2),
      clk => en(3),
      q => cb3_bits(1 downto 0)
    );


end structural;