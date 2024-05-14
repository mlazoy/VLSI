library ieee;
use ieee.std_logic_1164.all;

package PXL_GRID is
    -- Define custom types
    type grid3x3 is array (8 downto 0) of std_logic_vector(7 downto 0);
end package PXL_GRID;
