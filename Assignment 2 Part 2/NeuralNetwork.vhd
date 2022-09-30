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

entity NeuralNet is 
    Port(
        clk : in std_logic;
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0)
    );
end entity;

architecture Structural of NeuralNet is
    component DataPath is
        port(
            clk : in std_logic;
            state : in integer;
    
            write_addr_ram : in unsigned(11 downto 0);
            read_act_addr_ram : in unsigned(11 downto 0);
            read_weight_addr_ram : in unsigned(11 downto 0);
    
    
            write_addr_local : in unsigned(11 downto 0);
            read_act_addr_local : in unsigned(11 downto 0);
            read_weight_addr_local : in unsigned(11 downto 0);
    
    
            read_enable_rom : in std_logic;
            addr_rom : in unsigned(15 downto 0);
    
    
            mac_ctrl : in std_logic := '0';
    
    
            comparator_enable : in std_logic;
    
            image_type : out integer := 0
        );
    end component;

    component fsm is 
        Port (
            clk : in std_logic;
            state : out integer;

            write_addr_ram : out unsigned(11 downto 0);
            read_act_addr_ram : out unsigned(11 downto 0);
            read_weight_addr_ram : out unsigned(11 downto 0) := x"000";

            write_addr_local : out unsigned(11 downto 0);
            read_act_addr_local : out unsigned(11 downto 0);
            read_weight_addr_local : out unsigned(11 downto 0);

            read_enable_rom : out std_logic := '0';
            addr_rom : out unsigned(15 downto 0);

            mac_ctrl : out std_logic := '0';

            comparator_enable : out std_logic := '0'
        );
    end component;

    component seven_segment is
        Port  ( 
            sw  :  in unsigned (3  downto  0 ) ;
            seg :  out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;
signal state : integer;
signal write_addr_ram : unsigned(11 downto 0);
signal read_act_addr_ram : unsigned(11 downto 0);
signal read_weight_addr_ram : unsigned(11 downto 0);


signal write_addr_local : unsigned(11 downto 0);
signal read_act_addr_local : unsigned(11 downto 0);
signal read_weight_addr_local : unsigned(11 downto 0);


signal read_enable_rom : std_logic;
signal addr_rom : unsigned(15 downto 0);


signal mac_ctrl : std_logic;


signal comparator_enable : std_logic;

signal image_type : integer;
signal sw : unsigned(3 downto 0);
begin 
    an <= "1110";
    sw <= to_unsigned(image_type, sw'length);

    NN_DATAPATH : DataPath port map(clk, state, write_addr_ram, read_act_addr_ram, read_weight_addr_ram, write_addr_local, read_act_addr_local, read_weight_addr_local, read_enable_rom, addr_rom, mac_ctrl, comparator_enable, image_type);
    NN_FSM : fsm port map(clk, state, write_addr_ram, read_act_addr_ram, read_weight_addr_ram, write_addr_local, read_act_addr_local, read_weight_addr_local, read_enable_rom, addr_rom, mac_ctrl, comparator_enable);
    NN_SS : seven_segment port map(sw, seg);
end architecture;