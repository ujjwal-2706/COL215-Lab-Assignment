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
        state : inout integer := 0;

        write_addr_ram : out unsigned(11 downto 0);
        write_enable_ram : out std_logic := '0';
        read_act_addr_ram : out unsigned(11 downto 0);
        read_weight_addr_ram : out unsigned(11 downto 0) := x"000";

        write_addr_local : out unsigned(11 downto 0);
        write_enable_local : out std_logic := '0';
        read_act_addr_local : out unsigned(11 downto 0);
        read_weight_addr_local : out unsigned(11 downto 0);

        read_enable_rom : out std_logic := '0';
        addr_rom : out unsigned(15 downto 0);

        mac_ctrl : out std_logic := '0';

        comparator_enable : out std_logic := '0'
    );
end fsm;

architecture Behavioral of fsm is
signal write_addr_ram_counter : unsigned(11 downto 0) := x"000" ;
signal write_addr_local_counter : unsigned(11 downto 0) := x"000"; 
signal read_addr_rom : unsigned(15 downto 0) := x"0000";
signal read_addr_ram_counter : unsigned(11 downto 0) := x"000" ;
signal read_act_addr_local_counter : unsigned(11 downto 0) := x"000";
signal read_weight_addr_local_counter : unsigned(11 downto 0) := x"310"; -- 784 value
begin
process(clk) is
begin
    if(rising_edge(clk)) then
        if state = 0  then -- state 0 involves loading of image, weights, and bias files onto ROM
            read_enable_rom <= '1';
            state <= 1;
            write_enable_local <= '1';
            addr_rom <= read_addr_rom;
            read_addr_rom <= read_addr_rom + 1;
        elsif state = 1 then -- state 1 involves loading of image from ROM into local memory, remember to extend the image to 16 bits
            addr_rom <= read_addr_rom;
            write_addr_local <= write_addr_local_counter;
            write_addr_local_counter <= write_addr_local_counter + 1;
            if read_addr_rom = x"0310" then
                addr_rom <= x"0400";
                read_addr_rom <= x"0401";
                state <= 2;
            else
                read_addr_rom <= read_addr_rom + 1;
            end if;
        elsif state = 2 then -- this state involves loading of a column of the weight matrix from the ROM into local memory
            addr_rom <= read_addr_rom;
            write_enable_ram <= '0';
    
            write_addr_local_counter <= write_addr_local_counter + 1;
            write_addr_local <= write_addr_local_counter;
    
            if write_addr_local_counter = x"61F" then -- 1567 (2*784-1)
                write_addr_local_counter <= x"310"; -- 784
                state <= 3;
            else 
                read_addr_rom <= read_addr_rom + 1; 
            end if;
        elsif state = 3 then -- this state involves multiplication of the image matrix with the previously loaded column of the weight matrix
            write_enable_local <= '0';
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
                write_enable_ram <= '1';
                write_enable_local <= '1';
                write_addr_ram <= write_addr_ram_counter;
                read_act_addr_ram <= read_addr_ram_counter;
                if write_addr_ram_counter = x"03F" then
                    state <= 4;
                    read_addr_ram_counter <= x"000";
                    write_addr_local_counter <= x"61F";
                    
                    read_weight_addr_local_counter <= x"040";
                else 
                    write_addr_ram_counter <= write_addr_ram_counter + 1;
                    read_addr_ram_counter <= read_addr_ram_counter + 1;
                    write_addr_local_counter <= write_addr_local_counter-1;
                    addr_rom <= read_addr_rom;
                    state <= 2;
                end if;

            else
                read_act_addr_local_counter <= read_act_addr_local_counter + 1;
                read_weight_addr_local_counter <= read_weight_addr_local_counter + 1;
            end if;
    
        elsif state = 4 then -- this state involves loading the bias into local memory
            write_enable_ram <= '0';
            
            write_addr_local <= write_addr_local_counter;
            write_addr_local_counter <= write_addr_local_counter + 1;
           
            if read_addr_rom /= x"c841" then 
                addr_rom <= read_addr_rom;
            end if;
            
            if write_addr_local_counter = x"660" then
                state <= 10; -- state 10 involves adding bias
                read_addr_ram_counter <= x"000";
                write_addr_ram_counter <= x"000";
                write_enable_local <= '0';
                read_act_addr_local_counter <= x"620";
            else
                read_addr_rom <= read_addr_rom + 1;
            end if; 
        
        elsif state = 5 then -- this state writes the computed values back into the local memory from the RAM
            read_addr_ram_counter <= read_addr_ram_counter + 1;
            read_act_addr_ram <= read_addr_ram_counter;
            write_addr_local <= write_addr_local_counter;
            if write_addr_local_counter = x"040" then
                write_addr_ram_counter <= x"000";
                write_enable_local <= '1';
                state <= 6;
                read_addr_ram_counter <= x"000";
            else 
                write_addr_local_counter <= write_addr_local_counter + 1;
            end if;
        elsif state = 6 then -- this state loads weights for second layer
            write_enable_ram <= '0';
            addr_rom <= read_addr_rom;
            
            write_addr_local_counter <= write_addr_local_counter + 1;
            write_addr_local <= write_addr_local_counter;
            
            if write_addr_local_counter = x"07F" then -- 127 (2*64-1)
                write_addr_local_counter <= x"040"; -- 64
                write_enable_local <= '0';
                read_act_addr_local_counter <= x"000";
                state <= 7;
            else
                read_addr_rom <= read_addr_rom + 1;
            end if;
       elsif state = 7 then -- this state involves multiplication of the image matrix with the previously loaded column of the weight matrix
             write_enable_local <= '0';
             if read_act_addr_local_counter = x"000" then 
                 mac_ctrl <= '1';
             else 
                 mac_ctrl <= '0';
             end if;
     
             read_act_addr_local <= read_act_addr_local_counter;
             read_weight_addr_local <= read_weight_addr_local_counter;
     
             if read_act_addr_local_counter = x"03F" then
                 read_act_addr_local_counter <= x"000";
                 read_weight_addr_local_counter <= x"040"; -- 64
                 write_enable_ram <= '1';
                 write_enable_local <= '1';
                 write_addr_ram <= write_addr_ram_counter;
                 if write_addr_ram_counter = x"009" then
                     state <= 8;
                     read_addr_ram_counter <= x"000";
                     write_addr_local_counter <= x"07F";
                 else 
                     write_addr_ram_counter <= write_addr_ram_counter + 1;
                     write_addr_local_counter <= write_addr_local_counter-1;
                     addr_rom <= read_addr_rom;
                     write_enable_local <= '1';
                     state <= 6;
                 end if;
             else
                 read_act_addr_local_counter <= read_act_addr_local_counter + 1;
                 read_weight_addr_local_counter <= read_weight_addr_local_counter + 1;
             end if;
        elsif state = 8 then -- this state involves loading the bias into local memory
             write_enable_ram <= '0';
             
             write_addr_local <= write_addr_local_counter;
             write_addr_local_counter <= write_addr_local_counter + 1;
             
             read_addr_rom <= read_addr_rom+1;
             addr_rom <= read_addr_rom;
             
             if write_addr_local_counter = x"08a" then
                 state <= 11; -- state 11 involves adding bias
                 read_addr_ram_counter <= x"000";
                 write_addr_ram_counter <= x"000";
                 write_enable_local <= '0';
                 read_act_addr_local_counter <= x"080";
             end if; 
        elsif state = 9 then-- this state computes the maximum over the final values computed by the neural network
            if read_addr_ram_counter /= x"00A" then
                comparator_enable <= '1';
                read_addr_ram_counter <= read_addr_ram_counter + 1;
                read_act_addr_ram <= read_addr_ram_counter;
            else
                comparator_enable <= '0';
            end if;
        elsif state = 10 then -- this state adds the bias back into RAM itself
            write_enable_ram <= '1';
            write_addr_ram <= write_addr_ram_counter;
            write_addr_ram_counter <= write_addr_ram_counter + 1;
            
            read_act_addr_ram <= read_addr_ram_counter;
            read_addr_ram_counter <= read_addr_ram_counter + 1;
            
            read_act_addr_local <= read_act_addr_local_counter;
            read_act_addr_local_counter <= read_act_addr_local_counter + 1;
            if write_addr_ram_counter = x"040" then 
                state <= 12; -- state 12 does the shifting
                write_addr_ram_counter <= x"000";
                read_addr_Ram_counter <= x"000";
            end if;
        elsif state = 11 then
            write_enable_ram <= '1';
            write_addr_ram <= write_addr_ram_counter;
            write_addr_ram_counter <= write_addr_ram_counter + 1;
            
            read_act_addr_ram <= read_addr_ram_counter;
            read_addr_ram_counter <= read_addr_ram_counter + 1;
            
            read_act_addr_local <= read_act_addr_local_counter;
            read_act_addr_local_counter <= read_act_addr_local_counter + 1;
            if write_addr_ram_counter = x"00a" then 
                write_addr_ram_counter <= x"000";
                state <= 13; -- state 13 does the shifting
                read_addr_ram_counter <= x"000";
            end if;
        elsif state = 12 then
            write_addr_ram <= write_addr_ram_counter;
            write_addr_ram_counter <= write_addr_ram_counter + 1;
            
            read_act_addr_ram <= read_addr_ram_counter;
            read_addr_ram_counter <= read_addr_ram_counter + 1;
            if write_addr_ram_counter = x"040" then 
                state <= 5; -- state 5 loads back into local memory from ram
                write_addr_ram_counter <= x"000";
                read_addr_ram_counter <= x"000";
                write_addr_local_counter <= x"000";
                write_enable_ram <= '0';
                write_enable_local <= '1';
            end if;
        else
            write_addr_ram <= write_addr_ram_counter;
            write_addr_ram_counter <= write_addr_ram_counter + 1;
            
            read_act_addr_ram <= read_addr_ram_counter;
            read_addr_ram_counter <= read_addr_ram_counter + 1;
            if write_addr_ram_counter = x"00a" then 
                state <= 9; -- state 9 does the final evaluation
                write_addr_ram_counter <= x"000";
                read_addr_ram_counter <= x"000";
                write_enable_ram <= '0';
            end if;        
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
