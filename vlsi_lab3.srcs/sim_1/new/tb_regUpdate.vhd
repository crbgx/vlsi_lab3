library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_regUpdate is
end tb_regUpdate;

architecture behavioral of tb_regUpdate is

    component regUpdate
    port (  clk        : in  std_logic;
            reset      : in  std_logic;
            RegCtrl    : in  std_logic_vector (1 downto 0);   -- Register update control from ALU controller
            input      : in  std_logic_vector (7 downto 0);   -- Switch inputs
            A          : out std_logic_vector (7 downto 0);   -- Input A
            B          : out std_logic_vector (7 downto 0)    -- Input B
        );
    end component;

    signal clk      : std_logic := '1';
    signal reset    : std_logic;
    signal RegCtrl  : std_logic_vector(1 downto 0);
    signal input    : std_logic_vector(7 downto 0);
    signal A        : std_logic_vector(7 downto 0);
    signal B        : std_logic_vector(7 downto 0);
   
    constant period : time := 2500 ns;

begin   -- behavioral

    DUT: regUpdate
    port map (  clk        => clk,
                reset      => reset,
                RegCtrl    => RegCtrl,   -- 
                input      => input,
                A          => A,
                B          => B
    );

   -- *************************
   -- User test data pattern
   -- ************************* 
    
    clk <= not(clk) after period/2;
    
    reset <=    '1',
                '0' after 1 * period;
                
    RegCtrl <=  "00",
                "10" after 1 * period,
                "01" after 2 * period,
                "00" after 3 * period;
                
    input <=    "11111111",
                "11110000" after 2 * period;

end behavioral;
