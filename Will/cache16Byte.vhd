library IEEE;
use IEEE.std_logic_1164.all;

entity cache16Byte is
    port(
        byte_data_in : in std_logic_vector(7 downto 0);
        rd_wr_sig : in std_logic;
        enable_vector : in std_logic_vector(15 downto 0);
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
end cache16Byte;

architecture structural of cache16Byte is
    component cacheByte
        port(
            chip_enable : in  std_logic;
            rd_wr       : in  std_logic;
            data_in     : in  std_logic_vector(7 downto 0);
            data_out    : out std_logic_vector(7 downto 0)
        );
    end component;

begin
    cacheByte00 : cacheByte
        port map(
            chip_enable => enable_vector(0),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out0
        );
    cacheByte01 : cacheByte
        port map(
            chip_enable => enable_vector(1),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out1
        );
    cacheByte02 : cacheByte
        port map(
            chip_enable => enable_vector(2),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out2
        );
    cacheByte03 : cacheByte
        port map(
            chip_enable => enable_vector(3),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out3
        );
    --------------------------------------------


    cacheByte04 : cacheByte
        port map(
            chip_enable => enable_vector(4),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out4
        );
    cacheByte05 : cacheByte
        port map(
            chip_enable => enable_vector(5),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out5
        );
    cacheByte06 : cacheByte
        port map(
            chip_enable => enable_vector(6),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out6
        );
    cacheByte07 : cacheByte
        port map(
            chip_enable => enable_vector(7),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out7
        );
    ----------------------------------------------

    cacheByte08 : cacheByte
        port map(
            chip_enable => enable_vector(8),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out8
        );
    cacheByte09 : cacheByte
        port map(
            chip_enable => enable_vector(9),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out9
        );
    cacheByte10 : cacheByte
        port map(
            chip_enable => enable_vector(10),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out10
        );
    cacheByte11 : cacheByte
        port map(
            chip_enable => enable_vector(11),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out11
        );
    --------------------------------------------

    cacheByte12 : cacheByte
        port map(
            chip_enable => enable_vector(12),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out12
        );
    cacheByte13 : cacheByte
        port map(
            chip_enable => enable_vector(13),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out13
        );
    cacheByte14 : cacheByte
        port map(
            chip_enable => enable_vector(14),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out14
        );
    cacheByte15 : cacheByte
        port map(
            chip_enable => enable_vector(15),
            rd_wr => rd_wr_sig,
            data_in => byte_data_in,
            data_out => byte_data_out15
        );

end structural;