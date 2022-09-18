library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROM_TB is
end entity;

architecture testbench of ROM_TB is
    component ROM_MEM is
        generic (
        ADDR_WIDTH: integer := 10;
        DATA_WIDTH: integer:= 8;
        IMAGE_SIZE: integer := 51914;
        IMAGE_FILE_NAME: string := "imgdata.mif";
        WEIGHT_FILE_NAME: string := "weights_bias.mif"
        );
            Port (
            clk : in std_logic;
            load_enable : in std_logic;
            addr : in unsigned(15 downto 0);
            read_out : out signed(7 downto 0)
          );
    end component;
signal clk, load_enable : std_logic := '0';
signal addr : unsigned(15 downto 0) := x"0000";
signal read_out : signed(7 downto 0);
begin
    clk <= not(clk) after 10 ns;
    ROM_MEM1 : ROM_MEM port map(clk, load_enable, addr, read_out)
    process is 
    begin
        wait for 10 ns;
        load_enable <= '1';
        addr <= x"00CA";
        wait for 20 ns;
        addr <= x"0401";
        wait for 20 ns;
        addr <= x"0404";
        wait for 20 ns;
    end process;
end testbench;