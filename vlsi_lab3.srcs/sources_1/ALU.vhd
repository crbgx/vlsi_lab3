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
    signal temp_A, temp_B : std_logic_vector(8 downto 0);
    signal output : std_logic_vector(8 downto 0);
    signal temp_output : std_logic_vector(7 downto 0);
    

begin
    mod3_unsigned_inst : mod3 
    port map (
    x => A,
    output => temp_output
    );
    
    process ( FN, A, B, temp_A, temp_B , temp_output, output)
    begin
    sign <= '0';
    overflow <= '0';
    temp_A <= '0' & A;
    temp_B <= '0' & B;
    output(8) <= '0';
    
    
    case FN is
        when "0000" =>   -- Input A
            output(7 downto 0) <= A;
            
        when "0001" =>   -- Input B
            output(7 downto 0) <= B;
            
        when "0010" =>   -- Unsigned(A + B)
       -- temptemp_A <= '0' &
            output <= std_logic_vector(unsigned(temp_A) + unsigned(temp_B));
            overflow <= output(8);
            
        when "0011" =>   -- Unisgned(A - B)
            output <= std_logic_vector(unsigned(temp_A) - unsigned(temp_B));
            overflow <= output(8);
            
        when "0100" =>   -- Unsigned(A) mod 3 
            output(7 downto 0) <= temp_output;          
            
            
        when "1010" =>   -- Signed(A + B)       -- TODO simply into one-liner
            output <= std_logic_vector(signed(temp_A) + signed(temp_B));
            sign <= output(7);      -- TODO
            if A(7) = B(7) and A(7) /= output(7) then   -- TODO
                overflow <= '1';
            end if;

        when "1011" =>   -- Signed(A - B)
            output <= std_logic_vector(signed(temp_A) - signed(temp_B));
            sign <= output(7);      -- TODO
            overflow <= output(8);  -- TODO

        when "1100" =>   -- Signed(A) mod 3
            if a(7) = '1' then    -- Correction for negative numbers
                if temp_output = "00000000" then
                    output(7 downto 0) <= "00000010";   -- Value 2
                elsif temp_output = "00000001" then
                    output(7 downto 0) <= "00000000";
                else    
                    output(7 downto 0) <= "00000001";  -- Lower value by 1
                end if;
             else
                output(7 downto 0) <= temp_output;   
            end if;
            
        when others =>
            output(7 downto 0) <= "11111111";    -- TODO maybe change to another default
            
    end case;
       
    -- DEVELOPE YOUR CODE HERE
    result <= output(7 downto 0);
    end process;

end behavioral;
