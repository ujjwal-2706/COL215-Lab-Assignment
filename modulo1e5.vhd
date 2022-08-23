library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter1e5 is
    Port ( 
        clock : in std_logic;
        count : inout integer := 1
    );
end counter1e5;

architecture Behavioral of counter1e5 is
begin
    process(clock) is
    begin
        if(rising_edge(clock)) then
            if(count = 100000) then 
                count <= 1;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
end Behavioral;
