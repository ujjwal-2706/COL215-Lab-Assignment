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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seven_segment is
    Port  ( sw  :  in unsigned (3  downto  0 ) ;
        seg :  out STD_LOGIC_VECTOR(6 downto 0)
        );
end seven_segment;

architecture Behavioral of seven_segment is
--signal counter : integer := 1;
--signal anode : std_logic_vector(1 downto 0) := "11";
begin
    -- middle - 0, up right - 5. low - right - 4, down - 3, down-left - 2, up-left - 1, up - 6
    seg(0) <= (not(sw(3)) and not(sw(2)) and not(sw(1))) or (sw(2) and sw(1) and sw(0));
    seg(1) <= (not(sw(2)) and sw(1)) or (sw(1) and sw(0)) or (not(sw(3)) and not(sw(2)) and sw(0));
    seg(2) <= sw(0) or (sw(2) and not(sw(1)));
    seg(3) <= (sw(2) and not(sw(1)) and not(sw(0))) or (sw(2) and sw(1) and sw(0)) or (not(sw(3)) and not(sw(2)) and not(sw(1)) and sw(0));
    seg(4) <= not(sw(2)) and sw(1) and not(sw(0));
    seg(5) <= (sw(2) and not(sw(1)) and sw(0)) or (sw(2) and sw(1) and not(sw(0)));
    seg(6) <= (sw(2) and not(sw(1)) and not(sw(0))) or (not(sw(3)) and not(sw(2)) and not(sw(1)) and sw(0));
--    process(clk) is
--        begin 
--            if rising_edge(clk) then
--                if counter = 10000000 then
--                counter <= 1;
--                case anode is
--                    when "11" =>
--                        an <= "1110";
--                        anode <= "10";
--                    when "10" =>
--                        an <= "1101";
--                        anode <= "01";
--                    when "01" =>
--                        an <= "1011";
--                        anode <= "00";
--                    when others =>
--                        an <= "0111";
--                        anode <= "11";
--                end case;
--             else
--                counter <= counter + 1;
--            end if; 
--            end if;
--    end process;
--    process(anode) is
--        begin
--         seg(0) <= (not(sw(3)) and not(sw(2)) and not(sw(1))) or (sw(2) and sw(1) and sw(0));
--          seg(1) <= (not(sw(2)) and sw(1)) or (sw(1) and sw(0)) or (not(sw(3)) and not(sw(2)) and sw(0));
--          seg(2) <= sw(0) or (sw(2) and not(sw(1)));
--          seg(3) <= (sw(2) and not(sw(1)) and not(sw(0))) or (sw(2) and sw(1) and sw(0)) or (not(sw(3)) and not(sw(2)) and not(sw(1)) and sw(0));
--          seg(4) <= not(sw(2)) and sw(1) and not(sw(0));
--          seg(5) <= (sw(2) and not(sw(1)) and sw(0)) or (sw(2) and sw(1) and not(sw(0)));
--          seg(6) <= (sw(2) and not(sw(1)) and not(sw(0))) or (not(sw(3)) and not(sw(2)) and not(sw(1)) and sw(0));
--    end process;
----    an <= "1110" when anode = "11" else "1101" when anode = "10" else "1011" when anode = "01" else "0111";
   
end Behavioral;


