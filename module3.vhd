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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity modulo3 is
    Port ( 
        mod4 : in integer;
        count : out integer := 0;
    );
end modulo3;

architecture Behavioral of modulo3 is
begin
    process(mod4) is
    begin
        if(mod4 = 0) then
            if(count = 9) then
                count <= 0;
            else 
                count <= count + 1;
            end if;
        end if;
    end process;
end Behavioral;
