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

   -- COMPONENT IMPORT
   component dd_shift
   port ( input_binary    : in std_logic;
          input_bcd    : in std_logic_vector(9 downto 0);  -- Signal to shift
          output_bcd   : out std_logic_vector(9 downto 0)
       );
    end component;
    
-- SIGNAL DEFINITIONS HERE IF NEEDED
    signal bcd_temp_1, bcd_temp_2, bcd_temp_3, bcd_temp_4, bcd_temp_5, bcd_temp_6, bcd_temp_7, bcd_temp_8 : std_logic_vector(9 downto 0) := (others => '0');

begin  

    -- COMPONENT DELCARATION
    bcd_temp_1 <= "0000000000";
    
    dd_shift_1 : dd_shift
    port map(
        input_binary => binary_in(7),
        input_bcd => bcd_temp_1,
        output_bcd => bcd_temp_2
    );
    
    dd_shift_2 : dd_shift
    port map(
        input_binary => binary_in(6),
        input_bcd => bcd_temp_2,
        output_bcd => bcd_temp_3
    );
    
    dd_shift_3 : dd_shift
    port map(
        input_binary => binary_in(5),
        input_bcd => bcd_temp_3,
        output_bcd => bcd_temp_4
    );
    
    dd_shift_4 : dd_shift
    port map(
        input_binary => binary_in(4),
        input_bcd => bcd_temp_4,
        output_bcd => bcd_temp_5
    );

    dd_shift_5 : dd_shift
    port map(
        input_binary => binary_in(3),
        input_bcd => bcd_temp_5,
        output_bcd => bcd_temp_6
    );

    dd_shift_6 : dd_shift
    port map(
        input_binary => binary_in(2),
        input_bcd => bcd_temp_6,
        output_bcd => bcd_temp_7
    );

    dd_shift_7 : dd_shift
    port map(
        input_binary => binary_in(1),
        input_bcd => bcd_temp_7,
        output_bcd => bcd_temp_8
    );

    dd_shift_8 : dd_shift
        port map(
            input_binary => binary_in(0),
            input_bcd => bcd_temp_8,
            output_bcd => BCD_out
        );
    
-- DEVELOP YOUR CODE HERE
end structural;
