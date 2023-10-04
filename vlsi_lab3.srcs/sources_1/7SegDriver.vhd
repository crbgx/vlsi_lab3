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
    signal reg : std_logic_vector(9 downto 0);
    
begin

-- DEVELOPE YOUR CODE HERE

    combinational_display: process (reg_digit_counter, reg, current_state_display) -- fill out the sensitivity list     
    begin
       
        next_state_display <= current_state_display;
        next_reg_digit_counter <= reg_digit_counter + 1;
        case current_state_display is
        when dis0 =>
            DIGIT_ANODE <= "1110";
            SEGMENT <= reg(3 downto 0);
            if reg_digit_counter = "0" then
                next_state_display <= dis1;
            end if;
        when dis1 =>
            DIGIT_ANODE <= "1101";
            SEGMENT <= reg(7 downto 4);
            if reg_digit_counter = "0" then
                next_state_display <= dis2;
            end if;
        when dis2 =>
            DIGIT_ANODE <= "1011";
            SEGMENT <= "00" & reg(9 downto 8);
            if reg_digit_counter = "0" then
               next_state_display <= dis3;
            end if;       
        when dis3 =>
            DIGIT_ANODE <= "0111";
            -- SEGMENT <= reg(31 downto 24);
            if reg_digit_counter = "0" then
                next_state_display <= dis0;
             end if;
        end case;
    end process;
    
end behavioral;
