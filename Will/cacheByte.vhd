library IEEE;
use IEEE.std_logic_1164.all;

entity cacheByte is
    port(
        chip_enable : in  std_logic;
        rd_wr       : in  std_logic;
        data_in     : in  std_logic_vector(7 downto 0);
        data_out    : out std_logic_vector(7 downto 0)
    );
end cacheByte;

architecture structural of cacheByte is

    component cacheCell
        port(
            chip_enable : in  std_logic;
            rd_wr       : in  std_logic;
            data_in     : in  std_logic;
            data_out    : out std_logic
        );
    end component;

begin

    cell_inst1 : cacheCell
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in(0),
            data_out    => data_out(0)
        );
    cell_inst2 : cacheCell
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in(1),
            data_out    => data_out(1)
        );
    cell_inst3 : cacheCell
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in(2),
            data_out    => data_out(2)
        );
    cell_inst4 : cacheCell
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in(3),
            data_out    => data_out(3)
        );
    cell_inst5 : cacheCell
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in(4),
            data_out    => data_out(4)
        );
    cell_inst6 : cacheCell
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in(5),
            data_out    => data_out(5)
        );
    cell_inst7 : cacheCell
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in(6),
            data_out    => data_out(6)
        );
    cell_inst8 : cacheCell
        port map(
            chip_enable => chip_enable,
            rd_wr       => rd_wr,
            data_in     => data_in(7),
            data_out    => data_out(7)
        );
    

end structural;
