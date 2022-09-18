----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2022 02:13:28 PM
-- Design Name: 
-- Module Name: mac - Behavioral
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

entity mac is
  Port (
  weight : in signed(7 downto 0);
  activation : in signed(15 downto 0);
  clk : in std_logic;
  ctrl : in std_logic;
  accum : inout signed(15 downto 0));
end mac;

architecture Behavioral of mac is
component multiplier is
    Port (
  weight : in signed(7 downto 0);     
  activation : in signed(15 downto 0);
  result : out signed(23 downto 0 )); 
end component;
signal multiply : signed(23 downto 0);
begin
-- need to ensure in fsm that multiply is of previous cycle else accum wrong
uut : multiplier port map(weight,activation,multiply);
process(clk) is 
begin
    if rising_edge(clk) then
        if ctrl = '1' then
           accum <= multiply(15 downto 0);
        else
           accum <= accum + multiply(15 downto 0);
        end if;
    end if;
end process;
end Behavioral;
