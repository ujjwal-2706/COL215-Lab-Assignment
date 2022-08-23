----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2022 04:15:36 PM
-- Design Name: 
-- Module Name: timer - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer is
  Port (
    mod1e5: in integer;
    sel : inout std_logic_vector (1 downto 0) := "11";
    anode : out std_logic_vector (3 downto 0));
end timer;

architecture Behavioral of timer is
begin
    process(mod1e5) is
    begin
        if(mod1e5 = 1)
        then 
          if (sel="00") then sel <= "01"; anode <= "1101" ;
          elsif (sel="01") then sel <= "10"; anode <= "1011" ;
          elsif (sel="10") then sel <= "11"; anode <= "0111" ;
          else sel <= "00"; anode <= "1110" ;
          end if;
        end if;
    end process;
end Behavioral;
