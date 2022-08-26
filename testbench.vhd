library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end tb;

architecture testbench of tb is
    component StopWatch is
        Port ( 
        clk : in std_logic;
        an : out std_logic_vector(3 downto 0);
        seg : out std_logic_vector(6 downto 0));
    end component;
signal clk : std_logic := '0';
signal an : std_logic_vector (3 downto 0);
signal seg : std_logic_vector ( 6 downto 0);
begin
    UUT : Stopwatch port map (clk,an,seg);
    clk <= not clk after 5 ns;
end testbench;