----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2022 03:45:11 PM
-- Design Name: 
-- Module Name: fsm - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
  Port (
  clk : in std_logic;
  layer_index : out integer;
  ctrl_mac : out std_logic;
  rom_addr : inout unsigned(19 downto 0) := x"00000";
  ram_addr_write : inout unsigned(15 downto 0) := x"0000";
  ram_addr_read : inout unsigned(15 downto 0) := x"0000";
  ctrl_ram : out std_logic  );
end fsm;

architecture Behavioral of fsm is
signal state : integer := 0;
signal single_column : integer := 0;
begin
process(clk) is
begin
    if rising_edge(clk) then
        if state = 0 then
            -- rom_addr = 783
            ctrl_ram <= '1';
            if rom_addr = x"0030F" then
                state <= 1;
                rom_addr <= x"00400";
                ctrl_mac <= '1';
            else
                rom_addr <= rom_addr + 1;
            end if;
        elsif state = 1 then
            -- weights in rom start from 1024 index
            if single_column = 783 then
                state <= 2;
                ctrl_mac <= '0';
            else
                single_column <= single_column + 1;
                rom_addr <= rom_addr + 1;
                ram_addr_read <= ram_addr_read + 1;
            end if;
        elsif state = 2 then 
            ctrl_mac <= '1';
            if ram_addr_write = x"0007F" then
                state <= 3;
            else
                ram_addr_read <= x"00000";
                rom_addr <= rom_addr + 1;
                ram_addr_write <= ram_addr_write + 1;
                single_column <= 0;
            end if;
        elsif state = 3 then
            if single_column = 127 then
                state <= 4;
                ctrl_mac <= '0';
            else
                single_column <= single_column + 1;
                rom_addr <= rom_addr + 1;
                ram_addr_read <= ram_addr_read + 1;
            end if;
        elsif state = 4 then 
           ctrl_mac <= '1';
           if ram_addr_write = x"00009" then
               state <= 5;
           else
               ram_addr_read <= x"00000";
               rom_addr <= rom_addr + 1;
               ram_addr_write <= ram_addr_write + 1;
               single_column <= 0;
           end if;
        -- state 5 is final state with 10 values
        end if;
    end if;
end process;
end Behavioral;
