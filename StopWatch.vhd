----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/17/2022 04:29:08 PM
-- Design Name: 
-- Module Name: StopWatch - Structural
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

entity StopWatch is
    Port ( 
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        dp : out STD_LOGIC := '1');

end StopWatch;


architecture Structural of StopWatch is
    component timer is
      Port (
    sel : inout std_logic_vector (1 downto 0) := "11";
    anode : out std_logic_vector (3 downto 0));
    end component;
    
    component mux is
    Port ( digit1 : in STD_LOGIC_VECTOR(3 downto 0);
        digit2 : in STD_LOGIC_VECTOR(3 downto 0);
        digit3 : in STD_LOGIC_VECTOR(3 downto 0);
        digit4 : in STD_LOGIC_VECTOR(3 downto 0);
        sel : in std_logic_vector (1 downto 0);
        digit_out : out std_logic_vector(3 downto 0));
    end component;
    
    component seven_segment is
        Port  ( sw  :  in STD_LOGIC_VECTOR (3  downto  0 ) ;
        seg :  out STD_LOGIC_VECTOR(6 downto 0));
    
    end component;
    signal sel : std_logic_vector(1 downto 0);
    signal sw : std_logic_vector(3 downto 0);
    signal digit1 : std_logic_vector(3 downto 0) := "0001";
    signal digit2 : std_logic_vector(3 downto 0)  := "0101";
    signal digit3 : std_logic_vector(3 downto 0)  := "0111";
    signal digit4 : std_logic_vector(3 downto 0)  := "1001";
begin
    T : timer port map(sel, an);
    M : mux port map(digit1, digit2, digit3, digit4, sel, sw);
    SS : seven_segment port map(sw, seg);

end Structural;
