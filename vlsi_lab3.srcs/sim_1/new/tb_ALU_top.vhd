library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ALU_top is
end tb_ALU_top;

architecture behavioral of tb_ALU_top is

    component ALU_top
    port (  clk         : in std_logic;
            reset       : in std_logic;
            b_enter     : in std_logic;
            b_sign      : in std_logic;
            input       : in std_logic_vector(7 downto 0);
            seven_seg   : out std_logic_vector(6 downto 0);   
            anode       : out std_logic_vector(3 downto 0);
            anode_off   : out std_logic_vector(3 downto 0);
            state       : out std_logic_vector(3 downto 0);
            enter_led   : out std_logic;
            sign_led    : out std_logic
        );
    end component;

    signal clk          : std_logic := '1';
    signal reset        : std_logic;
    signal b_enter      : std_logic;
    signal b_sign       : std_logic;
    signal input        : std_logic_vector(7 downto 0);
    signal seven_seg    : std_logic_vector(6 downto 0);
    signal anode        : std_logic_vector(3 downto 0);
    signal anode_off    : std_logic_vector(3 downto 0);
    signal state        : std_logic_vector(3 downto 0);
    signal enter_led    : std_logic;
    signal sign_led     : std_logic;
   
    constant period : time := 2500 ns;

begin   -- behavioral

    DUT: ALU_top
    port map (  clk         => clk,
                reset       => reset,
                b_enter     => b_enter,
                b_sign      => b_sign,
                input       => input,
                seven_seg   => seven_seg,  
                anode       => anode,
                anode_off   => anode_off,
                state       => state,
                enter_led   => enter_led,
                sign_led    => sign_led
    );

   -- *************************
   -- User test data pattern
   -- ************************* 
    
    clk <= not(clk) after period/2;
    
    reset <=    '0',
                '1' after 1 * period;
    
    b_enter <=  '0',
                '1' after 1 * period,
                '0' after 2 * period,
                '1' after 3 * period,
                '0' after 4 * period,
                '1' after 5 * period,
                '0' after 6 * period,
                '1' after 7 * period,
                '0' after 8 * period,
                '1' after 9 * period,
                '0' after 10 * period,
                '1' after 13 * period,
                '0' after 14 * period,
                '1' after 15 * period;   
                
    b_sign <=   '0',
                '1' after 11 * period,
                '0' after 12 * period;
                --'1' after 15 * period;
                --'0' after 1 * period;
                
    input <=    "00000111",
                "00001101" after 2 * period;

end behavioral;
