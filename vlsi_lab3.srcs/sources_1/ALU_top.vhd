library ieee;
use ieee.std_logic_1164.all;

library work;
use work.ALU_components_pack.all;

entity ALU_top is
   port ( clk        : in  std_logic;
          reset      : in  std_logic;
          b_Enter    : in  std_logic;
          b_Sign     : in  std_logic;
          input      : in  std_logic_vector(7 downto 0);
          seven_seg  : out std_logic_vector(6 downto 0);
          anode      : out std_logic_vector(3 downto 0);
          anode_off  : out std_logic_vector(3 downto 0);
          state      : out std_logic_vector(3 downto 0);
          enter_led  : out std_logic;
          sign_led   : out std_logic
    );
end ALU_top;

architecture structural of ALU_top is
 
    component ALU_ctrl is
        port (  clk     : in  std_logic;
                reset   : in  std_logic;
                enter   : in  std_logic;
                sign    : in  std_logic;
                FN      : out std_logic_vector (3 downto 0);    -- ALU functions
                RegCtrl : out std_logic_vector (1 downto 0)     -- Register update control bits [A B]
        );
    end component;
   
    component debouncer is
      port (    clk        : in  std_logic;
                reset      : in  std_logic;
                button_in  : in  std_logic;
                button_out : out std_logic
        );
    end component;
      
    component seven_seg_driver is
        port (  clk           : in  std_logic;
                reset         : in  std_logic;
                BCD_digit     : in  std_logic_vector(9 downto 0);          
                sign          : in  std_logic;
                overflow      : in  std_logic;
                DIGIT_ANODE   : out std_logic_vector(3 downto 0);
                SEGMENT       : out std_logic_vector(6 downto 0)
        );
    end component;
            
    component ALU is
        port (  A          : in  std_logic_vector (7 downto 0);     -- Input A
                B          : in  std_logic_vector (7 downto 0);     -- Input B
                FN         : in  std_logic_vector (3 downto 0);     -- ALU functions provided by the ALU_Controller (see the lab manual)
                result     : out std_logic_vector (7 downto 0);     -- ALU output (unsigned binary)
                overflow   : out std_logic;                         -- '1' if overflow ocurres, '0' otherwise 
                sign       : out std_logic                          -- '1' if the result is a negative value, '0' otherwise
        );
    end component;
        
    component binary2BCD is
        port (  binary_in : in  std_logic_vector(7 downto 0);       -- binary input width
                BCD_out   : out std_logic_vector(9 downto 0)        -- BCD output, 10 bits [2|4|4] to display a 3 digit BCD value when input has length 8
        );
    end component;

    component regUpdate is
        port (  clk        : in  std_logic;
                reset      : in  std_logic;
                RegCtrl    : in  std_logic_vector (1 downto 0);     -- Register update control from ALU controller
                input      : in  std_logic_vector (7 downto 0);     -- Switch inputs
                A          : out std_logic_vector (7 downto 0);     -- Input A
                B          : out std_logic_vector (7 downto 0)      -- Input B
            );
    end component;
        
        
   -- SIGNAL DEFINITIONS
   signal Enter, Sign : std_logic;  -- Clean signals (debounced)
   signal FN_signal : std_logic_vector(3 downto 0);
   signal RegCtrl_signal : std_logic_vector(1 downto 0);
   signal A_signal, B_signal : std_logic_vector(7 downto 0);
   signal result_signal : std_logic_vector(7 downto 0);
   signal OF_signal, sign_signal : std_logic;
   signal BCD_signal : std_logic_vector(9 downto 0);
   signal reset_negated : std_logic;
   

begin

    reset_negated <= not(reset);
    
   ---- to provide a clean signal out of a bouncy one coming from the push button
   ---- input(b_Enter) comes from the pushbutton; output(Enter) goes to the FSM 
   debouncer1: debouncer
   port map ( clk          => clk,
              reset        => reset_negated,
              button_in    => b_Enter,
              button_out   => Enter
    );

    debouncer2: debouncer
    port map (  clk          => clk,
                reset        => reset_negated,
                button_in    => b_Sign,
                button_out   => Sign
    );
    -- ***************************************
    -- DEVELOPE THE STRUCTURE OF ALU_TOP HERE
    -- ***************************************
    ALUcontroller: ALU_ctrl
    port map (  clk     => clk,
                reset   => reset_negated,
                enter   => Enter,
                sign    => Sign,
                FN      => FN_signal,
                RegCtrl => RegCtrl_signal
    );
    
    RegUpdater: regUpdate
    port map (  clk        => clk,
                reset      => reset_negated,
                RegCtrl    => RegCtrl_signal,   -- Register update control from ALU controller
                input      => input,   -- Switch inputs
                A          => A_signal,  -- Input A
                B          => B_signal   -- Input B
    );
 
    ALUn: ALU
        port map ( A        => A_signal,
                   B        => B_signal,
                   FN       => FN_signal,
                   result   => result_signal,
                   overflow => OF_signal,
                   sign     => sign_signal  
        );
        
    binary2BCDn : binary2BCD
         port map ( binary_in    => result_signal,      
                    BCD_out      => BCD_signal    
           );

    seven_seg_drivern : seven_seg_driver
        port map (clk           => clk,
                  reset         => reset_negated,
                  BCD_digit     => BCD_signal,          
                  sign          => sign_signal,
                  overflow      => OF_signal,
                  DIGIT_ANODE   => anode,
                  SEGMENT       => seven_seg
            );

    anode_off <= (others => '1');
    
    
    state <= FN_signal;
    enter_led <= Enter;
    sign_led <= Sign;
    
end structural;
