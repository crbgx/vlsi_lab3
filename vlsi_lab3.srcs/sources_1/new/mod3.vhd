----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.09.2023 15:50:04
-- Design Name: 
-- Module Name: mod3 - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod3 is
    port ( x        : in std_logic_vector(7 downto 0);  -- Signal to check
           c        : in std_logic_vector(7 downto 0);  -- Control signal
           output   : out std_logic_vector(7 downto 0)
    );
end mod3;

architecture Behavioral of mod3 is

    -- Temporal signals
    signal temp_x, temp_b : std_logic_vector(7 downto 0);
    
begin
    
    output <= std_logic_vector(unsigned(temp_x) - unsigned(temp_b));
    temp_x <= x;
    process ( x, c )
    begin
        if x > c then
            temp_b <= c;
        else 
            temp_b <= (others => '0');
        end if;
    end process;

end Behavioral;
