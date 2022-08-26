----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2022 03:57:15 PM
-- Design Name: 
-- Module Name: mux - Behavioral
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

entity mux is
    Port ( digit1 : in unsigned(3 downto 0);
        digit2 : in unsigned(3 downto 0);
        digit3 : in unsigned(3 downto 0);
        digit4 : in unsigned(3 downto 0);
        sel : in std_logic_vector (1 downto 0);
        digit_out : out unsigned(3 downto 0) := "0000");
end mux;

architecture Behavioral of mux is
begin
    digit_out(0) <= (not(sel(0)) and not(sel(1)) and digit1(0)) or (not(sel(1)) and (sel(0)) and digit2(0)) or ((sel(1)) and not(sel(0)) and digit3(0)) or ((sel(0)) and (sel(1)) and digit4(0));  
    digit_out(1) <= (not(sel(0)) and not(sel(1)) and digit1(1)) or (not(sel(1)) and (sel(0)) and digit2(1)) or ((sel(1)) and not(sel(0)) and digit3(1)) or ((sel(0)) and (sel(1)) and digit4(1));  
    digit_out(2) <= (not(sel(0)) and not(sel(1)) and digit1(2)) or (not(sel(1)) and (sel(0)) and digit2(2)) or ((sel(1)) and not(sel(0)) and digit3(2)) or ((sel(0)) and (sel(1)) and digit4(2));  
    digit_out(3) <= (not(sel(0)) and not(sel(1)) and digit1(3)) or (not(sel(1)) and (sel(0)) and digit2(3)) or ((sel(1)) and not(sel(0)) and digit3(3)) or ((sel(0)) and (sel(1)) and digit4(3));  
    

end Behavioral;
