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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity timer is
  Port (
    clock : in std_logic;
    sel : inout std_logic_vector (1 downto 0) := "11";
    anode : out std_logic_vector (3 downto 0) := "1110");
end timer;

architecture Behavioral of timer is
signal counter : unsigned (31 downto 0) := x"00000001";
begin
    process(clock) is
    begin
      if rising_edge(clock) then
        -- counter = 1e5
        if counter = x"000186A0" then
          counter <= x"00000001";
          if (sel="00") then 
            sel <= "01"; 
            anode <= "1011";
          elsif (sel="01") then 
            sel <= "10"; 
            anode <= "1101";
          elsif (sel="10") then 
            sel <= "11"; 
            anode <= "1110";
          else
            sel <= "00"; 
            anode <= "0111";
          end if;
        else
          counter <= counter + 1;
        end if;
      end if;
        -- if(mod1e5 = 1)
        -- then 
        --   if (sel="00") then sel <= "01"; anode <= "1011" ;
        --   elsif (sel="01") then sel <= "10"; anode <= "1101" ;
        --   elsif (sel="10") then sel <= "11"; anode <= "1110" ;
        --   else sel <= "00"; anode <= "0111" ;
        --   end if;
        -- end if;
    end process;
end Behavioral;
