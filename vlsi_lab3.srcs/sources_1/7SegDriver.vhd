library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity seven_seg_driver is
   port ( clk           : in  std_logic;
          reset         : in  std_logic;
          BCD_digit     : in  std_logic_vector(9 downto 0);          
          sign          : in  std_logic;
          overflow      : in  std_logic;
          DIGIT_ANODE   : out std_logic_vector(3 downto 0);
          SEGMENT       : out std_logic_vector(6 downto 0)
        );
end seven_seg_driver;

architecture behavioral of seven_seg_driver is

    -- SIGNAL DEFINITIONS HERE IF NEEDED
    type state_type_display is (dis0, dis1, dis2, dis3);
    
    signal current_state_display, next_state_display: state_type_display;
    signal reg_digit_counter, next_reg_digit_counter: unsigned(16 downto 0):= (others => '0');
    signal temp_SEGMENT : std_logic_vector(27 downto 0);
    signal overFlow_Sign : std_logic_vector(1 downto 0) := (others => '0');
    
begin

    registers: process (clk, reset)
    begin     
        if rising_edge(clk) then
            if reset = '1' then
                reg_digit_counter <= (others => '0');
                current_state_display <= dis0;
            else
                current_state_display <= next_state_display;
                reg_digit_counter <= next_reg_digit_counter;
            end if;
        end if;
    end process;

    -- DISPLAY FSM
    combinational_display: process (reg_digit_counter, current_state_display, temp_segment) -- fill out the sensitivity list     
    begin
        
        next_state_display <= current_state_display;
        next_reg_digit_counter <= reg_digit_counter + 1;
        case current_state_display is
        when dis0 =>
            DIGIT_ANODE <= "1110";
            SEGMENT <= temp_segment(6 downto 0);
            if reg_digit_counter = "0" then
                next_state_display <= dis1;
            end if;
        when dis1 =>
            DIGIT_ANODE <= "1101";
            SEGMENT <= temp_segment(13 downto 7);
            if reg_digit_counter = "0" then
                next_state_display <= dis2;
            end if;
        when dis2 =>
            DIGIT_ANODE <= "1011";
            SEGMENT <= temp_segment(20 downto 14);
            if reg_digit_counter = "0" then
               next_state_display <= dis3;
            end if;       
        when dis3 =>
            DIGIT_ANODE <= "0111";
            SEGMENT <= temp_segment(27 downto 21);
            if reg_digit_counter = "0" then
                next_state_display <= dis0;
             end if;
        end case;  
    end process;
    
    overFlow_Sign <= overflow & sign;
    
    combinational: process(BCD_digit, overFlow_Sign)
    begin
        -- The order of the LEDs from 6 downto 0 is:
        -- [g, f, e, d, c, b, a]    (No dp)
        case BCD_digit(3 downto 0) is
            when "0000" =>
                temp_SEGMENT(6 downto 0) <= "1000000";      -- 0
            when "0001" =>
                temp_SEGMENT(6 downto 0) <= "1111001";      -- 1
            when "0010" =>
                temp_SEGMENT(6 downto 0) <= "0100100";      -- 2
            when "0011" =>
                temp_SEGMENT(6 downto 0) <= "0110000";      -- 3
            when "0100" =>
                temp_SEGMENT(6 downto 0) <= "0011001";      -- 4
            when "0101" =>
                temp_SEGMENT(6 downto 0) <= "0010010";      -- 5         
            when "0110" =>
                temp_SEGMENT(6 downto 0) <= "0000010";      -- 6
            when "0111" =>
                temp_SEGMENT(6 downto 0) <= "1111000";      -- 7
            when "1000" =>
                temp_SEGMENT(6 downto 0) <= "0000000";      -- 8
            when "1001" =>
                temp_SEGMENT(6 downto 0) <= "0011000";      -- 9
            when "1101" =>
                temp_SEGMENT(6 downto 0) <= "1111111";      -- Beginning state, empty register
            when others =>
                temp_SEGMENT(6 downto 0) <= "0000110";      -- E (Probably not needed anymore)
            end case;
            
         case BCD_digit(7 downto 4) is
            when "0000" =>
                temp_SEGMENT(13 downto 7) <= "1000000";      -- 0
            when "0001" =>
                temp_SEGMENT(13 downto 7) <= "1111001";      -- 1
            when "0010" =>
                temp_SEGMENT(13 downto 7) <= "0100100";      -- 2
            when "0011" =>
                temp_SEGMENT(13 downto 7) <= "0110000";      -- 3
            when "0100" =>
                temp_SEGMENT(13 downto 7) <= "0011001";      -- 4
            when "0101" =>
                temp_SEGMENT(13 downto 7) <= "0010010";      -- 5         
            when "0110" =>
                temp_SEGMENT(13 downto 7) <= "0000010";      -- 6
            when "0111" =>
                temp_SEGMENT(13 downto 7) <= "1111000";      -- 7
            when "1000" =>
                temp_SEGMENT(13 downto 7) <= "0000000";      -- 8
            when "1001" =>
                temp_SEGMENT(13 downto 7) <= "0011000";      -- 9
            when others =>
                temp_SEGMENT(13 downto 7) <= "0000110";      -- E (Probably not needed anymore)
            end case;
            
        case BCD_digit(9 downto 8) is
            when "00" =>
                temp_SEGMENT(20 downto 14) <= "1000000";      -- 0
            when "01" =>
                temp_SEGMENT(20 downto 14) <= "1111001";      -- 1
            when "10" =>
                temp_SEGMENT(20 downto 14) <= "0100100";      -- 2
            when "11" =>
                temp_SEGMENT(20 downto 14) <= "1111111";      -- Beginning state, empty register
            when others =>
                temp_SEGMENT(20 downto 14) <= "0000110";      -- E (Probably not needed anymore)
        end case;
                    
        case overFlow_Sign is
            when "01" =>
                temp_SEGMENT(27 downto 21) <= "0111111";      -- Negative Sign (-)
            when "10" =>
                temp_SEGMENT(27 downto 21) <= "0001110";      -- F for overflow
            when "11" =>
                temp_SEGMENT(27 downto 21) <= "0001110";      -- F for overflow predominates
            when others =>
                temp_SEGMENT(27 downto 21) <= "1111111";      -- OFF
        end case;
            
    end process;
    
end behavioral;

