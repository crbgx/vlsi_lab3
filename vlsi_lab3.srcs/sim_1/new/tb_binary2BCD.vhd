library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_binary2BCD is
end tb_binary2BCD;

architecture behavioral of tb_binary2BCD is

    component binary2BCD
    port (    binary_in     : in  std_logic_vector(7 downto 0);
              BCD_out   : out  std_logic_vector(9 downto 0)
            );
    end component;

    signal binary_in       : std_logic_vector(7 downto 0);
    signal BCD_out         : std_logic_vector(9 downto 0);
   
    constant period : time := 2500 ns;

begin   -- behavioral

    DUT: binary2BCD
    port map (  binary_in        => binary_in,
                BCD_out      => BCD_out
    );

   -- *************************
   -- User test data pattern
   -- ************************* 
    
    --clk <= not(clk) after period/2;
                
    binary_in <= "11110000",
                "00000000" after 1 * period,
                "00001110" after 2 * period,
                "11111111" after 3 * period,
                "11100111" after 4 * period,
                "00011011" after 5 * period,
                "10101010" after 6 * period,
                "01010101" after 7 * period,
                "11001101" after 8 * period,
                "01010010" after 9 * period,
                "00001100" after 10 * period;

end behavioral;
