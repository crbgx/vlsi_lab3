library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.ALU_components_pack.all;

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


   component mod3
   port ( x        : in std_logic_vector(7 downto 0);  -- Signal to check
          output   : out std_logic_vector(7 downto 0)
       );
   end component;

    -- SIGNAL DEFINITIONS HERE IF NEEDED
    signal temp_192, temp_96, temp_48, temp_24, temp_12, temp_6, temp_3 : std_logic_vector(7 downto 0); 
    signal temp_A : unsigned(7 downto 0);
    signal output : std_logic_vector(7 downto 0);
    signal temp_outty : std_logic_vector(7 downto 0);
    

begin
    mod3_unsigned_inst : mod3 
    port map (
    x => A,
    output => temp_outty
    );
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
            output <= temp_outty;          
            
            
        when "1010" =>   -- Signed(A + B)       -- TODO simply into one-liner
            output <= std_logic_vector(signed(A) + signed(B));
            sign <= output(7);
            if A(7) = '0' and B(7) = '0' and output(7) = '1' then   -- Overflows if A and B are positive and the output is negative
                overflow <= '1';
            elsif A(7) = '1' and B(7) = '1' and output(7) = '0' then    -- Overflows if A and B are negative and the output is positive
                overflow <= '1';
            end if;

        when "1011" =>   -- Signed(A - B)
            output <= std_logic_vector(signed(A) - signed(B));
            sign <= output(7);
            if A(7) = '0' and B(7) = '1' and output(7) = '1' then   -- Overflows if A is positive, B is negative and the result is negative
                overflow <= '1';
            elsif A(7) = '1' and B(7) = '0' and output(7) = '0' then    -- Overflows if A is negative, B is positive and the result is positive    
                overflow <= '1';
            end if;

        when "1100" =>   -- Signed(A) mod 3
            if A(7) = '1' then    -- Correction for negative numbers
                if temp_outty = "00000000" then
                    output <= "00000010";   -- Value 2
                elsif temp_outty = "00000001" then
                    output <= "00000000";
                else    
                    output <= "00000001";  -- Lower value by 1
                end if;
             else
                output <= temp_outty;   
            end if;
            
            when others =>
            output <= "11111111";    -- TODO maybe change to another default
            

    end case;
       
    -- DEVELOPE YOUR CODE HERE
    result <= output;
    end process;

end behavioral;
