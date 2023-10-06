library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_7SegDriver is
end tb_7SegDriver;

architecture behavioral of tb_7SegDriver is

    component seven_seg_driver
    port (  clk           : in  std_logic;
            reset         : in  std_logic;
            BCD_digit     : in  std_logic_vector(9 downto 0);          
            sign          : in  std_logic;
            overflow      : in  std_logic;
            DIGIT_ANODE   : out std_logic_vector(3 downto 0);
            SEGMENT       : out std_logic_vector(6 downto 0)
            );
    end component;

    signal clk          : std_logic;
    signal reset        : std_logic;
    signal BCD_digit    : std_logic_vector(9 downto 0);
    signal sign         : std_logic;
    signal overflow     : std_logic;
    signal DIGIT_ANODE  : std_logic_vector(3 downto 0);
    signal SEGMENT      : std_logic_vector(6 downto 0);
   
    constant period     : time := 2500 ns;

begin   -- behavioral

    DUT: seven_seg_driver
    port map (  clk             => clk,
                reset           => reset,
                BCD_digit       => BCD_digit,          
                sign            => sign,
                overflow        => overflow,
                DIGIT_ANODE     => DIGIT_ANODE,
                SEGMENT         => SEGMENT
    );

   -- *************************
   -- User test data pattern
   -- ************************* 
    
    
    --TODO Incomplete
    clk <= not(clk) after period/2;
    
    reset <=    '1',
                '0' after 1 * period;
                
    BCD_digit <=    "0000000000",
                    "0100100110" after 1 * period,
                    "0001011001" after 2 * period,
                    "0001110100" after 3 * period,
                    "0000000000" after 4 * period,
                    "0000000001" after 5 * period,
                    "0000000000" after 6 * period;
    
    sign <= '1',
            '0' after 1 * period,
            '1' after 2 * period;
            
    overflow <= '1',
                '0' after 1 * period,
                '1' after 2 * period;
    
end behavioral;
