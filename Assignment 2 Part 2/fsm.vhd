----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/07/2022 03:45:11 PM
-- Design Name: 
-- Module Name: fsm - Behavioral
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

entity fsm is
  Port (
  clk : in std_logic;
  write_enable_ram : out std_logic := '1';
  write_addr_ram : out unsigned(11 downto 0);
  read_act_addr_ram : out unsigned(11 downto 0);
  read_weight_addr_ram : out unsigned(11 downto 0) : = x"000";
  write_enable_local : out std_logic := '1';
  write_addr_local : out unsigned(11 downto 0);
  read_act_addr_local : out unsigned(11 downto 0);
  read_weight_addr_local : out unsigned(11 downto 0);
  read_enable_rom : out std_logic := '0';
  addr_rom : out unsigned(15 downto 0);
  mac_ctrl : out std_logic := '0';
  comparator_enable : out std_logic := '0'
   );
end fsm;

architecture Behavioral of fsm is
signal state : integer := 0;
signal write_addr_ram_counter : unsigned(11 downto 0) := x"000" ;
signal write_addr_local_counter : unsigned(11 downto 0) := x"000"; 
signal read_addr_rom : unsigned(15 downto 0) := x"0000";
signal read_addr_ram_counter : unsigned(11 downto 0) := x"000" ;
signal read_act_addr_local_counter : unsigned(11 downto 0) := x"000";
signal read_weight_addr_local_counter : unsigned(11 downto 0) := x"310"; -- 784 value
signal counter_layer_hidden : integer := 0;
signal counter_layer_final : integer := 0;
begin
process(clk) is
begin
    if state = 0  then
        read_enable_rom <= '1';
        state <= 1;
    elsif state = 1 then
        addr_rom <= read_addr_rom;
        write_addr_local <= write_addr_local_counter;
        write_addr_local_counter <= write_addr_local_counter + 1;
        if read_addr_rom = x"30F" then 
            read_addr_rom <= x"400";
            state <= 2;
        else
            read_addr_rom <= read_addr_rom + 1;
        end if;
    elsif state = 2 then 
        addr_rom <= read_addr_rom;
        write_addr_local_counter <= write_addr_local_counter + 1;
        write_addr_local <= write_addr_local_counter;
        if write_addr_local <= x"61F" then -- 1567 (2*784-1)
            write_addr_local_counter <= x"310"; -- 784
            state <= 3;
        end if;
    elsif state = 3 then
        if read_act_addr_local_counter = x"000" then 
            mac_ctrl <= '1';
        else 
            mac_ctrl <= '0';
        end if;
        read_act_addr_local <= read_act_addr_local_counter;
        read_weight_addr_local <= read_weight_addr_local_counter;
        if read_act_addr_local_counter = x"30F" then
            read_act_addr_local_counter <= x"000";
            read_weight_addr_local_counter <= x"310"; -- 784
            read_act_addr_local <= x"000";
            read_weight_addr_local <= x"310"; -- 784
            write_addr_ram_counter <= write_addr_ram_counter + 1;
            state <= 2;
            counter_layer_hidden <= counter_layer_hidden + 1;
            if counter_layer_hidden = 127 then
                write_addr_local_counter <= x"000";
                state <= 4;
            end if;
        else
            read_act_addr_local_counter <= read_act_addr_local_counter + 1;
            read_weight_addr_local_counter <= read_weight_addr_local_counter + 1;
        end if;
        write_addr_ram <= write_addr_ram_counter;
    elsif state = 4 then
        read_addr_ram_counter <= read_addr_ram_counter + 1;
        read_addr_ram <= read_addr_ram_counter;
        write_addr_local <= write_addr_local_counter;
        if write_addr_local_counter = 127 then
            state <= 5;
        else 
            write_addr_local_counter <= write_addr_local_counter + 1;
        end if;
    elsif state = 5 then
        addr_rom <= read_addr_rom;
        write_addr_local_counter <= write_addr_local_counter + 1;
        write_addr_local <= write_addr_local_counter;
        if write_addr_local <= x"0FF" then -- 255 (2*128-1)
            write_addr_local_counter <= x"80"; -- 128
            state <= 6;
        end if;
    elsif state = 6 then
        if read_act_addr_local_counter = x"000" then 
            mac_ctrl <= '1';
        else 
            mac_ctrl <= '0';
        end if;
        read_act_addr_local <= read_act_addr_local_counter;
        read_weight_addr_local <= read_weight_addr_local_counter;
        if read_act_addr_local_counter = x"07F" then -- 127
            read_act_addr_local_counter <= x"000";
            read_weight_addr_local_counter <= x"080"; -- 128
            read_act_addr_local <= x"000";
            read_weight_addr_local <= x"080"; -- 128
            write_addr_ram_counter <= write_addr_ram_counter + 1;
            state <= 5;
            counter_layer_final <= counter_layer_final + 1;
            if counter_layer_final = 9 then
                write_addr_local_counter <= x"000";
                comparator_enable <= '1';
                read_addr_ram_counter <= x"000";
                read_addr_ram <= x"000";
                state <= 7;
            end if;
        else
            read_act_addr_local_counter <= read_act_addr_local_counter + 1;
            read_weight_addr_local_counter <= read_weight_addr_local_counter + 1;
        end if;
        write_addr_ram <= write_addr_ram_counter;
    else 
        if read_addr_ram_counter /= x"009" then
            read_addr_ram_counter <= read_addr_ram_counter + 1;
            read_addr_ram <= read_addr_ram_counter;
        end if;
    end if;
end process;
end Behavioral;

-- state 0 for initializing rom
-- state 1 for loading image
-- state 2 for loading weights first column
-- state 3 for mac computation for  single value
-- state 4 for again loading the next weights
-- state 5 jumping to other layer in neural network
-- initially read enable for rom is 0 for loading
