library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ALUcontroller is
end tb_ALUcontroller;

architecture behavioral of tb_ALUcontroller is

    component ALU_ctrl
    port (    clk     : in  std_logic;
              reset   : in  std_logic;
              enter   : in  std_logic;
              sign    : in  std_logic;
              FN      : out std_logic_vector (3 downto 0);
              RegCtrl : out std_logic_vector (1 downto 0)
            );
    end component;

    signal clk      : std_logic := '1';
    signal reset    : std_logic;
    signal enter    : std_logic;
    signal sign     : std_logic;
    signal FN       : std_logic_vector(3 downto 0);
    signal RegCtrl  : std_logic_vector(1 downto 0);
   
    constant period : time := 2500 ns;

begin   -- behavioral

    DUT: ALU_ctrl
    port map (  clk        => clk,
                reset      => reset,
                enter      => enter,
                sign       => sign,
                FN         => FN,
                RegCtrl    => RegCtrl
    );

   -- *************************
   -- User test data pattern
   -- ************************* 
    
    clk <= not(clk) after period/2;
    
    reset <=    '1',
                '0' after 1 * period,
                '1' after 12 * period,
                '0' after 13 * period;
                
    enter <=    '0',
                '1' after 1 * period,
                '0' after 2 * period,
                '1' after 3 * period,
                '0' after 4 * period,
                '1' after 5 * period,
                '0' after 6 * period,
                '1' after 7 * period,
                '0' after 8 * period,
                '1' after 9 * period,
                '0' after 10 * period;
    
    sign <=     '0',
                '1' after 4 * period,
                '0' after 5 * period,
                '1' after 10 * period,
                '0' after 11 * period;

end behavioral;
