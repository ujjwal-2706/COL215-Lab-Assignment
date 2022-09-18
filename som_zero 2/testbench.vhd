----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2022 02:13:28 PM
-- Design Name: 
-- Module Name: mac - Behavioral
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

entity tb is
end tb;

architecture testbench of tb is
component mac is
  Port (
    weight : in signed(7 downto 0);
    activation : in signed(15 downto 0);
    clk : in std_logic;
    ctrl : in std_logic;
    accum : inout signed(15 downto 0));
end component;

component ram is
  Port ( 
  clk :in std_logic;
  ctrl : in std_logic;
  write_enable : in std_logic;
  write_addr : in unsigned(12 downto 0);
  read_act_addr : in unsigned(12 downto 0);
  read_weight_addr : in unsigned(12 downto 0);
  input_mac : in signed(15 downto 0);
  input_ram : in signed(15 downto 0);
  output_act : out signed(15 downto 0);
  output_weight : out signed(15 downto 0)); 
end component;

component shifter is
  Port ( 
    input : in signed(15 downto 0);
    output : out signed(15 downto 0));
end component;

component comparator is
  Port ( 
    input1 : in signed(15 downto 0);
    input2 : in signed(15 downto 0);
    output : out signed(15 downto 0));
end component;
signal weight : signed(7 downto 0) := x"00";
signal activation : signed(15 downto 0) := x"0000";
signal clk : std_logic := '0';
signal ctrl_mac : std_logic := '1';
signal accum : signed(15 downto 0) := x"0000";
signal ctrl_ram : std_logic := '0';
signal write_enable : std_logic := '0';
signal write_addr : unsigned(12 downto 0) := "0000000000000";
signal read_act_addr : unsigned(12 downto 0) := "0000000000000";
signal read_weight_addr : unsigned(12 downto 0) := "0000000000000";
signal input_mac : signed(15 downto 0) := x"0000";
signal input_ram : signed(15 downto 0) := x"0000";
signal output_act : signed(15 downto 0) := x"0000";
signal output_weight : signed(15 downto 0) := x"0000";
signal input_shifter : signed(15 downto 0) := x"0000";
signal output_shifter : signed(15 downto 0) := x"0000";
signal input1_compare : signed(15 downto 0) := x"0000";
signal input2_compare : signed(15 downto 0) := x"0000";
signal output_compare : signed(15 downto 0) := x"0000";
begin
  mac1 : mac port map (weight,activation,clk,ctrl_mac,accum);
  ram1 : ram port map (clk,ctrl_ram,write_enable,write_addr,read_act_addr,read_weight_addr,input_mac,input_ram,output_act,output_weight);
  shifter1 : shifter port map (input_shifter,output_shifter);
  comparator1 : comparator port map (input1_compare,input2_compare,output_compare);
  clk <= not clk after 10 ns;
  process is
    begin
      weight <= x"03";
      activation <= x"0004";
      wait for 10 ns;
      -- assert accum = x"000C";
      ctrl_mac <= '0';
      weight <= x"05";
      activation <= x"0002";
      wait for 20 ns;
      -- assert accum = x"0016";
      weight <= x"0A";
      activation <= x"000B";
      wait for 20 ns;
      -- assert accum = x"0084";
      ctrl_mac <= '1';
      weight <= x"02";
      activation <= x"0005";
      wait for 20 ns;
      -- assert accum = x"000A";
      write_enable <= '1';
      ctrl_ram <= '1';
      input_mac <= x"0007";
      wait for 20 ns;
      -- assert output_weight = x"0007";
      write_addr <= "0000000000001";
      input_mac <= x"0008";
      read_weight_addr <= "0000000000001";
      wait for 20 ns;
      -- assert output_weight = x"0008";
      input_shifter <= x"0100";
      wait for 20 ns;
      -- assert output_shifter = x"0008";
      input_shifter <= x"8100";
      wait for 20 ns;
      -- assert output_shifter = x"FB04";
      input1_compare <= x"0006";
      input2_compare <= x"0000";
      wait for 20 ns;
      -- assert output_compare = x"0006";
      input1_compare <= x"8100";
      wait for 20 ns;
      -- assert output_compare = x"0000"; 

    end process;
end testbench;
