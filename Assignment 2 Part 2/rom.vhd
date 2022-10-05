----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2022 03:36:08 PM
-- Design Name: 
-- Module Name: mif_reader - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


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

entity ROM_MEM is
generic (
ADDR_WIDTH: integer := 10;
DATA_WIDTH: integer:= 8;
IMAGE_SIZE: integer := 52914;
IMAGE_FILE_NAME: string := "imgdata_digit4.mif";
WEIGHT_FILE_NAME: string := "weights_bias.mif"
);
    Port (
    clk : in std_logic;
    read_enable : in std_logic;
    addr : in unsigned(15 downto 0);
    read_out : out signed(7 downto 0)
  );
end ROM_MEM;

architecture Behavioral of ROM_MEM is
TYPE mem_type IS ARRAY(0 TO IMAGE_SIZE) OF std_logic_vector((DATA_WIDTH-1) DOWNTO 0);
impure function init_mem(image_file_name : in string; weight_file_name : in string) return mem_type is
    file image_file : text open read_mode is image_file_name;
    file weight_file : text open read_mode is weight_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : mem_type;
begin
    for i in 0 to 783 loop
        readline(image_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    for i in 1024 to 51913 loop
        readline(weight_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    file_close(image_file);
    file_close(weight_file);
    return temp_mem;
end function;
signal rom_block: mem_type := init_mem(IMAGE_FILE_NAME, WEIGHT_FILE_NAME);
begin
   process(clk) is
   begin
    if rising_edge(clk) then
        if read_enable = '1' then 
            read_out <= signed(rom_block(to_integer(addr)));
        end if;
    end if;
   end process;
end Behavioral;
