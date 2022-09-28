----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2022 02:59:18 PM
-- Design Name: 
-- Module Name: ram - Behavioral
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

entity ram is
  Port ( 
  clk :in std_logic;
  ctrl : in std_logic;
  write_enable : in std_logic;
  write_addr : in unsigned(11 downto 0);
  read_act_addr : in unsigned(11 downto 0);
  read_weight_addr : in unsigned(11 downto 0);
  input_mac : in signed(15 downto 0);
  input_ram : in signed(15 downto 0);
  output_act : out signed(15 downto 0);
  output_weight : out signed(15 downto 0));
end ram;

architecture Behavioral of ram is
type first_layer is array(3135 downto 0) of signed(15 downto 0);
signal layer : first_layer := (others => x"0000");
begin
    output_act <= layer(to_integer(read_act_addr));
    output_weight <= layer(to_integer(read_weight_addr)); 
    process(clk) is
    begin
        if rising_edge(clk) then
            if write_enable = '1' then
                if ctrl = '1' then
                     layer(to_integer(write_addr)) <= input_mac;
                else
                     layer(to_integer(write_addr)) <= input_ram;  
                end if;
            end if;
        end if;
    end process;

end Behavioral;
