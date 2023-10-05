library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regUpdate is
    port ( clk        : in  std_logic;
          reset      : in  std_logic;
          RegCtrl    : in  std_logic_vector (1 downto 0);   -- Register update control from ALU controller
          input      : in  std_logic_vector (7 downto 0);   -- Switch inputs
          A          : out std_logic_vector (7 downto 0);   -- Input A
          B          : out std_logic_vector (7 downto 0)   -- Input B
    );
end regUpdate;

architecture behavioral of regUpdate is

    -- SIGNAL DEFINITIONS HERE IF NEEDED    
    signal reg_A, reg_B, next_reg_A, next_reg_B: std_logic_vector(7 downto 0) := (others => '0');
    
begin

    -- DEVELOP YOUR CODE HERE
    registers: process (clk, reset)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    reg_A <= (others => '0');
                    reg_B <= (others => '0');
                else
                    reg_A <= next_reg_A;
                    reg_B <= next_reg_B;
                end if;
            end if;
        end process;
    
    -- Output logic
    A <= reg_A;
    B <= reg_B;
    
    combinational: process (reg_A, reg_B, RegCtrl, input)    
    begin
        --set default value
        next_reg_A <= reg_A;
        next_reg_B <= reg_B;
    
        if RegCtrl = "10" then
            next_reg_A <= input;
        elsif RegCtrl = "01" then
            next_reg_B <= input;
        end if;
    end process;
    
end behavioral;
