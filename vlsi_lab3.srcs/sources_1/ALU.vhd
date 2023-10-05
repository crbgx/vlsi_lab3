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
          minus    : in std_logic_vector(7 downto 0);
          output   : out std_logic_vector(7 downto 0)
       );
   end component;

    -- SIGNAL DEFINITIONS HERE IF NEEDED
    signal temp_A, temp_B : std_logic_vector(8 downto 0);
    signal output, output_sign : std_logic_vector(8 downto 0);
    signal temp_output_1, temp_output_2, temp_output_3, temp_output_4, temp_output_5, temp_output_6, temp_output_7 : std_logic_vector(7 downto 0);
       


begin
    mod3_1 : mod3 
    port map (
    x => A,
    minus => "11000000",    -- 192
    output => temp_output_1
    );
    
    mod3_2 : mod3 
        port map (
        x => temp_output_1,
        minus => "01100000",    -- 96
        output => temp_output_2
        );

    mod3_3 : mod3 
        port map (
        x => temp_output_2,
        minus => "00110000",    -- 48
        output => temp_output_3
        );

    mod3_4 : mod3 
        port map (
        x => temp_output_3,
        minus => "00011000",    -- 24
        output => temp_output_4
        );
    
    mod3_5 : mod3 
        port map (
        x => temp_output_4,
        minus => "00001100",    -- 12
        output => temp_output_5
        );

    mod3_6 : mod3 
        port map (
        x => temp_output_5,
        minus => "00000110",    -- 6
        output => temp_output_6
        );

    mod3_7 : mod3 
        port map (
        x => temp_output_6,
        minus => "00000011",    -- 3
        output => temp_output_7
        );

    process ( FN, A, B, temp_A, temp_B, output, temp_output_7)
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
            output(7 downto 0) <= temp_output_7;          
            
        when "1010" =>   -- Signed(A + B)       -- TODO simply into one-liner
            temp_A(8) <= temp_A(7);
            temp_B(8) <= temp_B(7);
            output <= std_logic_vector(abs(signed(std_logic_vector(signed(temp_A) + signed(temp_B)))));
            output_sign <= std_logic_vector(signed(temp_A) + signed(temp_B));
            sign <= output_sign(8);
            if temp_A(7) = temp_B(7) and temp_A(7) /= output_sign(7) then
                overflow <= '1';
            end if;

        when "1011" =>   -- Signed(A - B)
            temp_A(8) <= temp_A(7);
            temp_B(8) <= temp_B(7);
            output <= std_logic_vector(abs(signed(std_logic_vector(signed(temp_A) - signed(temp_B)))));
            output_sign <= std_logic_vector(abs(signed(std_logic_vector(signed(temp_A) - signed(temp_B)))));
            sign <= output_sign(8);
            if temp_A(7) /= temp_B(7) and temp_A(7) /= output_sign(7) then
               overflow <= '1';
            end if;
               
        when "1100" =>   -- Signed(A) mod 3
            if a(7) = '1' then    -- Correction for negative numbers
                if temp_output_7 = "00000000" then
                    output(7 downto 0) <= "00000010";   -- Value 2
                elsif temp_output_7 = "00000001" then
                    output(7 downto 0) <= "00000000";
                else    
                    output(7 downto 0) <= "00000001";  -- Lower value by 1
                end if;
             else
                output(7 downto 0) <= temp_output_7;   
            end if;
            
        when others =>
            output(7 downto 0) <= "11111111";    -- TODO maybe change to another default
            
    end case;
       
    -- DEVELOP YOUR CODE HERE
    result <= output(7 downto 0);
    end process;

end behavioral;
