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
end ROM_MEM;

architecture Behavioral of ROM_MEM is
TYPE mem_type IS ARRAY(0 TO IMAGE_SIZE) OF std_logic_vector((DATA_WIDTH-1) DOWNTO 0);
impure function init_mem(mif_file_name : in string) return mem_type is
        file mif_file : text open read_mode is mif_file_name;
        variable mif_line : line;
        variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
        variable temp_mem : mem_type;
begin
for i in mem_type'range loop
    readline(mif_file, mif_line);
    read(mif_line, temp_bv);
    temp_mem(i) := to_stdlogicvector(temp_bv);
end loop;
return temp_mem;
end function;
impure function load_memory(rom_block : in mem_type; rom_block_weight : in mem_type) return mem_type is
    variable AA : mem_type;
begin 
for i in 0 to 783 loop
    AA(i) := rom_block(i);
end loop;
for i in 1024 to 51913 loop
    AA(i) := rom_block_weight(i-1024);
end loop;
return AA;
end function;
signal rom_block: mem_type := init_mem(IMAGE_FILE_NAME);
signal rom_block_weight : mem_type := init_mem(WEIGHT_FILE_NAME);
signal AA : mem_type := (others => x"00");
begin
   read_out <= signed(AA(to_integer(addr)));
   process(clk) is
   begin
    if rising_edge(clk) then
        if load_enable = '0' then 
            AA <= load_memory(rom_block,rom_block_weight);
        end if;
    end if;
   end process;
end Behavioral;
