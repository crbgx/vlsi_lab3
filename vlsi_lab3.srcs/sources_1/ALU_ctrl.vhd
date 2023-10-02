library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_ctrl is
   port ( clk     : in  std_logic;
          reset   : in  std_logic;
          enter   : in  std_logic;
          sign    : in  std_logic;
          FN      : out std_logic_vector (3 downto 0);   -- ALU functions
          RegCtrl : out std_logic_vector (1 downto 0)   -- Register update control bits [A B]
        );
end ALU_ctrl;

architecture behavioral of ALU_ctrl is

    -- Define enumeration type for the FSM
    type state_type is (operand_A, operand_B, sum_unsigned, sum_signed, minus_unsigned, minus_signed, mod3_unsigned, mod3_signed);
    
    -- SIGNAL DEFINITIONS HERE IF NEEDED
    signal current_state, next_state: state_type;



begin
    
    -- DEVELOPE YOUR CODE HERE
    registers: process (clk, reset)
    begin
        if reset = '1' then
            current_state <= operand_A;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    combinational: process (enter, sign, current_state)
    begin
        -- set default value
        next_state <= current_state;
        regCtrl <= "00";    -- Not writing into any registers
        
        case current_state is
            when operand_A =>
                FN <= "0000";
                RegCtrl <= "10";    -- Writing into register A
                if enter = '1' then 
                    next_state <= operand_B;
                end if;
                
            when operand_B =>
                FN <= "0001";
                RegCtrl <= "01";    -- Writing into register B
                if enter = '1' then 
                    next_state <= sum_unsigned;
                end if;
                
            when sum_unsigned =>
                FN <= "0010";
                if enter = '1' then 
                    next_state <= minus_unsigned;
                elsif sign = '1' then
                    next_state <= sum_signed;
                end if;
                
            when minus_unsigned =>
                FN <= "0011";
                if enter = '1' then 
                    next_state <= mod3_unsigned;
                elsif sign = '1' then
                    next_state <= minus_signed;
                end if;
                
            when mod3_unsigned =>
                FN <= "0100";
                if enter = '1' then 
                    next_state <= sum_unsigned;
                elsif sign = '1' then
                    next_state <= mod3_signed;
                end if;
                
            when sum_signed =>
                FN <= "1010";
                if enter = '1' then 
                    next_state <= minus_signed;
                elsif sign = '1' then
                    next_state <= sum_unsigned;
                end if;

            when minus_signed =>
                FN <= "1011";
                if enter = '1' then 
                    next_state <= mod3_signed;
                elsif sign = '1' then
                    next_state <= minus_unsigned;
                end if;
                
            when mod3_signed =>
                FN <= "1100";
                if enter = '1' then 
                    next_state <= sum_signed;
                elsif sign = '1' then
                    next_state <= mod3_unsigned;
                end if;
        end case;
    end process;

end behavioral;
