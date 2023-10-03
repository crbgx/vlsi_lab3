library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALU_components_pack.all;

entity binary2BCD is
   generic ( WIDTH : integer := 8   -- 8 bit binary to BCD
           );
   port ( binary_in : in  std_logic_vector(WIDTH-1 downto 0);  -- binary input width
          BCD_out   : out std_logic_vector(9 downto 0)        -- BCD output, 10 bits [2|4|4] to display a 3 digit BCD value when input has length 8
        );
end binary2BCD;

architecture structural of binary2BCD is 

-- SIGNAL DEFINITIONS HERE IF NEEDED
    signal binary_reg : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal bcd_reg : std_logic_vector(9 downto 0) := (others => '0');
    signal counter, next_counter : std_logic_vector(3 downto 0) := (others => '0');
    

begin  

-- DEVELOP YOUR CODE HERE
    combinational: process (binary_in, binary_reg, bcd_reg)
    begin
    
end structural;
