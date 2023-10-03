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
            output  : out std_logic_vector(7 downto 0)
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
           output   : out std_logic_vector(7 downto 0)
    );
end mod3;


architecture behavioral of mod3 is

    signal temp_x_192, temp_x_96, temp_x_48, temp_x_24, temp_x_12, temp_x_6, temp_x_3 : std_logic_vector(7 downto 0);
    signal temp_x : std_logic_vector(7 downto 0);
    
begin
    
    
    process (temp_x_192, temp_x_96, temp_x_48, temp_x_24, temp_x_12, temp_x_6, temp_x_3, temp_x, x)
    
    begin   -- TODO think as cyclic
        temp_x <= x;
        temp_x_192 <= temp_x;
        temp_x_96 <= temp_x_192;
        temp_x_48 <= temp_x_96;
        temp_x_24 <= temp_x_48;
        temp_x_12 <= temp_x_24;
        temp_x_6 <= temp_x_12;
        temp_x_3 <= temp_x_6;
        output <= temp_x_3;
        if temp_x >= "11000000" then
            temp_x_192 <= std_logic_vector(unsigned(temp_x) - "11000000");
        end if;
        if temp_x_192 >= "01100000" then
            temp_x_96 <= std_logic_vector(unsigned(temp_x_192) - "01100000");
        end if;
        if temp_x_96 >= "00110000" then
            temp_x_48 <= std_logic_vector(unsigned(temp_x_96) - "00110000");
        end if;
        if temp_x_48 >= "00011000" then
            temp_x_24 <= std_logic_vector(unsigned(temp_x_48) - "00011000");
        end if;
        if temp_x_24 >= "00001100" then
            temp_x_12 <= std_logic_vector(unsigned(temp_x_24) - "00001100");
        end if;
        if temp_x_12 >= "00000110" then
            temp_x_6 <= std_logic_vector(unsigned(temp_x_12) - "00000110");
        end if;
        if temp_x_6 >= "00000011" then
            temp_x_3 <= std_logic_vector(unsigned(temp_x_6) - "00000011");
        end if;
   
    end process;       

end behavioral;