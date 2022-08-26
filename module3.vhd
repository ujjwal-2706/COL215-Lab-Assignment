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

entity modulo3 is
    Port ( 
        clock : in std_logic;
        enable_watch : in std_logic;
        reset_watch : in std_logic;
        digit : inout unsigned (3 downto 0) := x"0"
    );
end modulo3;

architecture Behavioral of modulo3 is
signal counter : unsigned (35 downto 0) := x"000000001";
begin
    process(clock) is
    begin
        if reset_watch = '1' then
            counter <= x"000000001";
            digit <= x"0";
        elsif rising_edge(clock) then
            -- when counter = 1e8
            if counter = x"005F5E100" then
                counter <= x"000000001";
                if digit = x"9" then
                    digit <= x"0";
                else 
                    digit <= digit + 1;
                end if;
            else 
                counter <= counter + 1;
            end if;
        end if;
    end process;
end Behavioral;
