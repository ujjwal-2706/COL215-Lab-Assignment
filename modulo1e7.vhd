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

entity counter1e7 is
    Port ( 
        clock : in std_logic;
        count : out integer := 1;
    );
end counter1e7;

architecture Behavioral of counter1e7 is
begin
    process(clock) is
    begin
        if(rising_edge(clock)) then
            if(count = 10000000) then 
                count <= 1;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end Behavioral;
