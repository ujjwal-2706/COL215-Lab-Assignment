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
        clock : in std_logic;
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        dp : out STD_LOGIC := '1');

end StopWatch;


architecture Structural of StopWatch is

    component counter1e5 is
        Port ( 
            clock : in std_logic;
            count : inout integer := 1
        );
    end component;

    component counter1e7 is
        Port ( 
            clock : in std_logic;
            count : inout integer := 1
        );
    end component;

    component timer is
        Port (
            clock: in std_logic;
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

    component convert_int is
        Port (
        number : in integer;
        digits : out std_logic_vector (3 downto 0));
    end component;

    component modulo1 is
        Port ( 
            mod2 : in integer;
            count : inout integer := 0
        );
    end component;

    component modulo2 is
        Port ( 
            mod3 : in integer;
            count : inout integer := 0
        );
    end component;

    component modulo3 is
        Port ( 
            mod4 : in integer;
            count : inout integer := 0
        );
    end component;

    component modulo4 is
        Port ( 
            mod1e7 : in integer;
            count : inout integer := 0
        );
    end component;

    -- left one is digit1 and right one is digit4

    signal sel : std_logic_vector(1 downto 0);
    signal sw : std_logic_vector(3 downto 0);
    signal digit1,digit2,digit3,digit4 : std_logic_vector(3 downto 0);
    signal mod1e7,mod1,mod2,mod3,mod4,mod1e5 : integer;

begin
    T : timer port map(mod1e5, sel, an);
    M : mux port map(digit1, digit2, digit3, digit4, sel, sw);
    SS : seven_segment port map(sw, seg);
    convert1 : convert_int port map(mod1,digit1);
    convert2 : convert_int port map(mod2,digit2);
    convert3 : convert_int port map(mod3,digit3);
    convert4 : convert_int port map(mod4,digit4);
    count1e7 : counter1e7 port map(clock,mod1e7);
    count1e5 : counter1e5 port map(clock,mod1e5); 
    modu1 : modulo1 port map (mod2,mod1);
    modu2 : modulo2 port map (mod3,mod2);
    modu3 : modulo3 port map (mod4,mod3);
    modu4 : modulo4 port map (mod1e7,mod4);

end Structural;
