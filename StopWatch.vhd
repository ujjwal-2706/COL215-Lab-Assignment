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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity StopWatch is
    Port ( 
        btnC : in std_logic;
        btnU : in std_logic;
        btnL : in std_logic;
        clk : in std_logic;
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0);
        dp : out std_logic);
end StopWatch;


architecture Structural of StopWatch is

    component timer is
        Port (
        clock : in std_logic;
        sel : inout std_logic_vector (1 downto 0) := "11";
        anode : out std_logic_vector (3 downto 0) := "1110");
    end component;
    
    component mux is
        Port ( digit1 : in unsigned(3 downto 0);
        digit2 : in unsigned(3 downto 0);
        digit3 : in unsigned(3 downto 0);
        digit4 : in unsigned(3 downto 0);
        sel : in std_logic_vector (1 downto 0);
        digit_out : out unsigned(3 downto 0) := "0000";
        dp : out std_logic);
    end component;
    
    component seven_segment is
        Port  ( sw  :  in unsigned (3  downto  0 ) ;
        seg :  out STD_LOGIC_VECTOR(6 downto 0)
--        -- reduntant
--        clk : in std_logic;
--        an : out std_logic_vector (3 downto 0)
        );
    
    end component;

    component modulo1 is
        Port ( 
        clock : in std_logic;
        enable_watch : in std_logic;
        reset_watch : in std_logic;
        digit : inout unsigned (3 downto 0) := x"0"
    );
    end component;

    component modulo2 is
        Port ( 
        clock : in std_logic;
        enable_watch : in std_logic;
        reset_watch : in std_logic;
        digit : inout unsigned (3 downto 0) := x"0"
    );
    end component;

    component modulo3 is
        Port ( 
        clock : in std_logic;
        enable_watch : in std_logic;
        reset_watch : in std_logic;
        digit : inout unsigned (3 downto 0) := x"0"
    );
    end component;

    component modulo4 is
        Port ( 
        clock : in std_logic;
        enable_watch : in std_logic;
        reset_watch : in std_logic;
        digit : inout unsigned (3 downto 0) := x"0"
    );
    end component;

    -- left one is digit1 and right one is digit4

    signal sel : std_logic_vector(1 downto 0) ;
    signal sw : unsigned(3 downto 0);
    signal digit1,digit2,digit3,digit4 : unsigned(3 downto 0);
    signal enable_watch, reset_watch : std_logic := '0';
    signal counter : unsigned(19 downto 0) := x"00001";

begin
    process(clk) is
        begin
            if (rising_edge(clk)) then 
                if (counter = x"186A0") then 
                    counter <= x"00001";
                     if (btnC='1') then
                        enable_watch <= '1';
                        reset_watch <= '0';
                     elsif (btnU='1') then 
                        enable_watch <= '0';
                        reset_watch <= '0';
                     elsif (btnL='1') then 
                        reset_watch <= '1';
                     end if;
                else 
                    counter <= counter + 1;
                end if;
            end if;
    end process;
    T : timer port map(clk, sel, an);
    M : mux port map(digit1, digit2, digit3, digit4, sel, sw, dp);
    SS : seven_segment port map(sw, seg);
    modu1 : modulo1 port map (clk,enable_watch,reset_watch,digit1);
    modu2 : modulo2 port map (clk,enable_watch,reset_watch,digit2);
    modu3 : modulo3 port map (clk,enable_watch,reset_watch,digit3);
    modu4 : modulo4 port map (clk,enable_watch,reset_watch,digit4);
end Structural;


