library ieee;
use ieee.std_logic_1164.all;

entity tb_mod3 is
end tb_mod3;

architecture structural of tb_mod3 is

   component mod3
   port ( x          : in  std_logic_vector(7 downto 0);
          c          : in  std_logic_vector(7 downto 0);
          output   : out std_logic_vector(7 downto 0)
        );
   end component;

   signal x          : std_logic_vector(7 downto 0);
   signal c          : std_logic_vector(7 downto 0);
   signal output     : std_logic_vector(7 downto 0);
   
   constant period   : time := 2500 ns;

begin  -- structural
   
   DUT: mod3
   port map ( x         => x,
              c         => c,
              output    => output
            );
   
   -- *************************
   -- User test data pattern
   -- *************************
   
   x <= "00000101",                    -- A = 5
        "00001001" after 1 * period,   -- A = 9
        "00010001" after 2 * period,   -- A = 17
        "10010001" after 3 * period,   -- A = 145
        "10010100" after 4 * period,   -- A = 148
        "11010101" after 5 * period,   -- A = 213
        "00100011" after 6 * period,   -- A = 35
        "11110010" after 7 * period,   -- A = 242
        "00110001" after 8 * period,   -- A = 49
        "01010101" after 9 * period;   -- A = 85
  
   c <= "11000000",                    -- B = 192
        "01100000" after 1 * period,   -- B = 96
        "00110000" after 2 * period,   -- B = 48
        "00011000" after 3 * period,   -- B = 24
     
   
end structural;