library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ddshift is
end tb_ddshift;

architecture behavioral of tb_ddshift is

    component dd_shift
    port (    input_binary  : in std_logic;
              input_bcd     : in  std_logic_vector(9 downto 0);
              output_bcd   : out  std_logic_vector(9 downto 0)
            );
    end component;

    signal input_binary    : std_logic;
    signal input_bcd       : std_logic_vector(9 downto 0);
    signal output_bcd      : std_logic_vector(9 downto 0);
   
    constant period : time := 2500 ns;

begin   -- behavioral

    DUT: dd_shift
    port map (  input_binary   => input_binary,
                input_bcd      => input_bcd,
                output_bcd     => output_bcd
    );

   -- *************************
   -- User test data pattern
   -- ************************* 
    
    --clk <= not(clk) after period/2;
    
    input_binary <= '1',--,
                    '0' after 1 * period,
                    '1' after 2 * period,
                    '0' after 3 * period;
                
    input_bcd <= "0000000000",
                "0100100110" after 1 * period,
                "0001011001" after 2 * period,
                "0001110100" after 3 * period,
                "0000000000" after 4 * period,
                "0000000001" after 5 * period,
                "0000000000" after 6 * period;

end behavioral;
