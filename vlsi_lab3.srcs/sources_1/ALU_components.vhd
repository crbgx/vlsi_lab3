library ieee;
use ieee.std_logic_1164.all;

package ALU_components_pack is

   -- Button debouncing 
   component debouncer   
   port ( clk        : in  std_logic;
          reset      : in  std_logic;
          button_in  : in  std_logic;
          button_out : out std_logic
        );
   end component;
   
   -- D-flipflop
   component dff
   generic ( W : integer );
   port ( clk     : in  std_logic;
          reset   : in  std_logic;
          d       : in  std_logic_vector(W-1 downto 0);
          q       : out std_logic_vector(W-1 downto 0)
        );
   end component;
   
   -- ADD MORE COMPONENTS HERE IF NEEDED
   -- mod3
    component mod3
    port (  x   : in std_logic_vector (7 downto 0);     -- Signal to check
            minus    : in std_logic_vector(7 downto 0);
            output  : out std_logic_vector(7 downto 0)
        );
    end component;
   
    -- dd_shift
    component dd_shift
    port (  input_binary : in std_logic;
            input_bcd    : in std_logic_vector(9 downto 0);  -- Signal to shift
            output_bcd   : out std_logic_vector(9 downto 0)
    );
    end component;
   
end ALU_components_pack;

-------------------------------------------------------------------------------
-- ALU component pack body
-------------------------------------------------------------------------------
package body ALU_components_pack is

end ALU_components_pack;

-------------------------------------------------------------------------------
-- debouncer component: There is no need to use this component, thogh if you get 
--                      unwanted moving between states of the FSM because of pressing
--                      push-button this component might be useful.
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
   port ( clk        : in  std_logic;
          reset      : in  std_logic;
          button_in  : in  std_logic;
          button_out : out std_logic
        );
end debouncer;

architecture behavioral of debouncer is

   signal count      : unsigned(19 downto 0);  -- Range to count 20ms with 50 MHz clock
   signal button_tmp : std_logic;
   
begin

process ( clk )
begin
   if clk'event and clk = '1' then
      if reset = '1' then
         count <= (others => '0');
      else
         count <= count + 1;
         button_tmp <= button_in;
         
         if (count = 0) then
            button_out <= button_tmp;
         end if;
      end if;
  end if;
end process;

end behavioral;

------------------------------------------------------------------------------
-- component dff - D-FlipFlop 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity dff is
   generic ( W : integer
           );
   port ( clk     : in  std_logic;
          reset   : in  std_logic;
          d       : in  std_logic_vector(W-1 downto 0);
          q       : out std_logic_vector(W-1 downto 0)
        );
end dff;

architecture behavioral of dff is

begin

   process ( clk )
   begin
      if clk'event and clk = '1' then
         if reset = '1' then
            q <= (others => '0');
         else
            q <= d;
         end if;
      end if;
   end process;              

end behavioral;

------------------------------------------------------------------------------
-- BEHAVORIAL OF THE ADDED COMPONENETS HERE
-------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- component mod3 - Mod 3
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mod3 is
    port ( x        : in std_logic_vector(7 downto 0);  -- Signal to check
           minus    : in std_logic_vector(7 downto 0);
           output   : out std_logic_vector(7 downto 0)
    );
end mod3;


architecture behavioral of mod3 is

    signal temp_x, temp_output : std_logic_vector(7 downto 0);
    
begin
    
    process (temp_x, x)
    begin
        temp_output <= temp_x;
        if temp_x >= minus then
            temp_output <= std_logic_vector(unsigned(temp_x) - unsigned(minus));
        end if;

    end process;       

    temp_x <= x;
    output <= temp_output;

end behavioral;


------------------------------------------------------------------------------
-- component doubledabble - Double Dabble
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dd_shift is
    port ( input_binary : in std_logic;
           input_bcd    : in std_logic_vector(9 downto 0);  -- Signal to shift
           output_bcd   : out std_logic_vector(9 downto 0)
    );
end dd_shift;


architecture behavioral of dd_shift is

    signal temp_bcd : std_logic_vector(9 downto 0) := (others => '0');

begin
    
    process (input_bcd)
    begin
        temp_bcd <= input_bcd;
        if temp_bcd(7 downto 4) >= "0101" then      -- Check TENS >= 5
            temp_bcd <= std_logic_vector(unsigned(temp_bcd) + "0000110000");    -- 48
        end if;
        if temp_bcd(3 downto 0) >= "0101" then      -- Check ONES >= 5
            temp_bcd <= std_logic_vector(unsigned(temp_bcd) + "0000000011");    -- 3
        end if;
        output_bcd <= temp_bcd(8 downto 0) & input_binary;  -- TODO Warning

    end process;       

end behavioral;