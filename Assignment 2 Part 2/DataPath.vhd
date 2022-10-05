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

entity DataPath is
    port(
        clk : in std_logic;
        state : in integer;

        write_addr_ram : in unsigned(11 downto 0);
        write_enable_ram : in std_logic;
        read_act_addr_ram : in unsigned(11 downto 0);
        read_weight_addr_ram : in unsigned(11 downto 0);


        write_addr_local : in unsigned(11 downto 0);
        write_enable_local : in std_logic;
        read_act_addr_local : in unsigned(11 downto 0);
        read_weight_addr_local : in unsigned(11 downto 0);


        read_enable_rom : in std_logic;
        addr_rom : in unsigned(15 downto 0);


        mac_ctrl : in std_logic;


        comparator_enable : in std_logic;

        image_type : inout integer := 0
    );
end entity;

architecture Structural of DataPath is

    component mac is 
        Port (
            weight : in signed(7 downto 0);
            activation : in signed(15 downto 0);
            clk : in std_logic;
            ctrl : in std_logic;
            accum : inout signed(15 downto 0)
        );
    end component;

    component comparator is
        Port ( 
            comparator_enable : in std_logic;
            input1 : inout signed(15 downto 0);
            input2 : in signed(15 downto 0);
            address : inout integer;
            index : in integer
        );
    end component;

    component ram is
          Port ( 
            clk :in std_logic;
            write_addr : in unsigned(11 downto 0);
            write_enable : in std_logic;
            read_act_addr : in unsigned(11 downto 0);
            read_weight_addr : in unsigned(11 downto 0);
            write_input : in signed(15 downto 0);
            output_act : out signed(15 downto 0);
            output_weight : out signed(15 downto 0)
          );
    end component;
    
    component ROM_MEM is
        Port (
            clk : in std_logic;
            read_enable : in std_logic;
            addr : in unsigned(15 downto 0);
            read_out : out signed(7 downto 0)
        );
    end component;

    component shifter is
        Port ( 
            input : in signed(15 downto 0);
            output : out signed(15 downto 0)
        );
    end component;
signal input1 : signed(15 downto 0) := x"ffff";
signal shifter_out : integer;
signal rom_read : signed(7 downto 0);
signal ram_write, local_write : signed(15 downto 0);
signal ram_read_act, ram_read_weight : signed(15 downto 0);
signal local_read_act, local_read_weight : signed(15 downto 0);
signal mac_output : signed(15 downto 0);
signal shifter_output : signed(15 downto 0);
signal final_ram_write : signed(15 downto 0);

begin
    local_write <= ram_read_act when state = 5 else resize(rom_read, 16);
    final_ram_write <= mac_output when state = 4 or state = 3 or state = 2 or state = 8 or state = 7 or state = 6 else
                       ram_read_act + local_read_act when state = 10 or state = 11 else
                       shifter_output when shifter_output(15)='0' else x"0000";
                       
    
    DP_ROM : ROM_MEM port map(clk, read_enable_rom, addr_rom, rom_read);

    DP_LOCAL : ram port map(clk, write_addr_local, write_enable_local, read_act_addr_local, read_weight_addr_local, local_write, local_read_act, local_read_weight);

    DP_MAC : mac port map(local_read_weight(7 downto 0), local_read_act, clk, mac_ctrl, mac_output);
    DP_SHIFTER : shifter port map(ram_read_act, shifter_output);

    DP_RAM : ram port map(clk, write_addr_ram, write_enable_ram, read_act_addr_ram, read_weight_addr_ram, final_ram_write, ram_read_act, ram_read_weight);

    DP_COMP : comparator port map(comparator_enable, input1, ram_read_act, image_type, to_integer(read_act_addr_ram));
end architecture;