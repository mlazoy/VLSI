library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MAC is 
    port (rom_out, ram_out: in std_logic_vector(7 downto 0);
          init: in std_logic;
          accumulator: out std_logic_vector(16 downto 0)); -- 8 bits + 8 bits + 1 
end MAC;

architecture Behavioral of MAC is
begin

end Behavioral;
