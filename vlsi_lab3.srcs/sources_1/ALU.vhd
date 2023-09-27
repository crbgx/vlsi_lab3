library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
   port ( A          : in  std_logic_vector (7 downto 0);   -- Input A
          B          : in  std_logic_vector (7 downto 0);   -- Input B
          FN         : in  std_logic_vector (3 downto 0);   -- ALU functions provided by the ALU_Controller (see the lab manual)
          result 	 : out std_logic_vector (7 downto 0);   -- ALU output (unsigned binary)
	      overflow   : out std_logic;                       -- '1' if overflow ocurres, '0' otherwise 
          sign       : out std_logic                        -- '1' if the result is a negative value, '0' otherwise
        );
end ALU;

architecture behavioral of ALU is

-- SIGNAL DEFINITIONS HERE IF NEEDED
    signal output : std_logic_vector(7 downto 0);

begin

    process ( FN, A, B )
    begin
    sign <= '0';
    overflow <= '0';
    
    case FN is
        when "0000" =>   -- Input A
            output <= A;
        when "0001" =>   -- Input B
            output <= B;
        when "0010" =>   -- Unsigned(A + B)
            output <= std_logic_vector(unsigned(A) + unsigned(B));
            if output < A and output < B then
                overflow <= '1';        
            end if;
        when "0011" =>   -- Unisgned(A - B)
            output <= std_logic_vector(unsigned(A) - unsigned(B));
            if B > A then
               overflow <= '1';        
            end if;
        when "0100" =>   -- Unsigned(A) mod 3 
           
        when "1010" =>   -- Signed(A + B)
            output <= std_logic_vector(signed(A) + signed(B));
            if output < A and output < B then
                overflow <= '1';        
            end if;
        when "1011" =>   -- Signed(A - B)
            output <= std_logic_vector(signed(A) - signed(B));
            if output < A and output < B then
                overflow <= '1';        
            end if;
        when "1100" =>   -- Signed(A) mod 3
       
    end case;
       
    -- DEVELOPE YOUR CODE HERE
    result <= output;
   end process;

end behavioral;
