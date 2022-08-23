----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/10/2022 02:24:25 PM
-- Design Name: 
-- Module Name: AND_gate - Behavioral
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

entity seven_segment is
    Port  ( sw  :  in STD_LOGIC_VECTOR (3  downto  0 ) ;
        seg :  out STD_LOGIC_VECTOR(6 downto 0)
);
end seven_segment;

architecture Behavioral of seven_segment is
begin
    -- middle - 0, up right - 5. low - right - 4, down - 3, down-left - 2, up-left - 1, up - 6
    seg(0) <= (not(sw(3)) and not(sw(2)) and not(sw(1))) or (sw(2) and sw(1) and sw(0));
    seg(1) <= (not(sw(2)) and sw(3)) or (sw(1) and sw(0)) or (not(sw(3)) and not(sw(2)) and sw(0));
    seg(2) <= sw(0) or (sw(2) and not(sw(1)));
    seg(3) <= (sw(2) and not(sw(1)) and not(sw(0))) or (sw(2) and sw(1) and sw(0)) or (not(sw(3)) and not(sw(2)) and not(sw(1)) and sw(0));
    seg(4) <= not(sw(2)) and sw(1) and not(sw(0));
    seg(5) <= (sw(2) and not(sw(1)) and sw(0)) or (sw(2) and sw(1) and not(sw(0)));
    seg(6) <= (sw(2) and not(sw(1)) and not(sw(0))) or (not(sw(3)) and not(sw(2)) and not(sw(1)) and sw(0));

end Behavioral;


