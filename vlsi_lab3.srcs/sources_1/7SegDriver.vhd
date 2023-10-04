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
    signal reg_digit_counter, next_reg_digit_counter: unsigned(13 downto 0);
    signal temp_SEGMENT : std_logic_vector(3 downto 0);
    
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
    combinational_display: process (reg_digit_counter, current_state_display) -- fill out the sensitivity list     
    begin
        
        next_state_display <= current_state_display;
        next_reg_digit_counter <= reg_digit_counter + 1;
        case current_state_display is
        when dis0 =>
            DIGIT_ANODE <= "1110";
            temp_SEGMENT <= BCD_digit(3 downto 0);
            if reg_digit_counter = "0" then
                next_state_display <= dis1;
            end if;
        when dis1 =>
            DIGIT_ANODE <= "1101";
            temp_SEGMENT <= BCD_digit(7 downto 4);
            if reg_digit_counter = "0" then
                next_state_display <= dis2;
            end if;
        when dis2 =>
            DIGIT_ANODE <= "1011";
            temp_SEGMENT <= "00" & BCD_digit(9 downto 8);
            if reg_digit_counter = "0" then
               next_state_display <= dis3;
            end if;       
        when dis3 =>
            DIGIT_ANODE <= "0111";
            if overflow = '1' then
                temp_SEGMENT <= "1110";
            elsif sign = '1' then
                temp_SEGMENT <= "1111";
            end if;
            if reg_digit_counter = "0" then
                next_state_display <= dis0;
             end if;
        end case;  
    end process;
    
    combinational: process(temp_segment)
    begin
        -- The order of the LEDs from 6 downto 0 is:
        -- [g, f, e, d, c, b, a]    (No dp)
        case temp_SEGMENT is
            when "0000" =>
                SEGMENT <= "1000000";      -- 0
            when "0001" =>
                SEGMENT <= "1111001";      -- 1
            when "0010" =>
                SEGMENT <= "0100100";      -- 2
            when "0011" =>
                SEGMENT <= "0110000";      -- 3
            when "0100" =>
                SEGMENT <= "0011001";      -- 4
            when "0101" =>
                SEGMENT <= "0010010";      -- 5         
            when "0110" =>
                SEGMENT <= "0000010";      -- 6
            when "0111" =>
                SEGMENT <= "1111000";      -- 7
            when "1000" =>
                SEGMENT <= "0000000";      -- 8
            when "1001" =>
                SEGMENT <= "0011000";      -- 9
            when "1101" =>
                SEGMENT <= "1111111";      -- Beginning state, empty register
            when "1110" =>
                SEGMENT <= "0001110";      -- F for overflow
            when "1111" =>
                SEGMENT <= "0111111";      -- Negative Sign (-)
            when others =>
                SEGMENT <= "0000110";      -- E (Probably not needed anymore)
            end case;    
    end process;
    
end behavioral;

