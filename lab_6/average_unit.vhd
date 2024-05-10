
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity average_unit is
    port (clk, rst_n, avg_init: in std_logic;
          next_pixel: in std_logic_vector(7 downto 0);
          X_avg: out std_logic_vector(7 downto 0));
end average_unit;

architecture Behavioral of average_unit is

signal accumulator: std_logic_vector(7 downto 0);

begin


end Behavioral;
