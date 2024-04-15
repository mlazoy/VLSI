library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Control_unit is 
    port (clk: in std_logic;
        rom_address, ram_address: out std_logic_vector(2 downto 0);
        mac_init: out std_logic
    );
end Control_unit;

architecture Behavioral of Control_unit is
begin


end Behavioral;