library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pixel_adder_new is
    port(
        pixel_1, pixel_2, pixel_3, pixel_4: in std_logic_vector(7 downto 0);
        sum: out std_logic_vector(9 downto 0)); -- 2 more bit to avoid overflow here 
end pixel_adder_new;

architecture Behavioral_new of pixel_adder_new is

begin
process(pixel_1, pixel_2, pixel_3, pixel_4)
begin
sum <= (("00" & pixel_1) + ("00" & pixel_2)) + (("00" & pixel_3) + ("00" & pixel_4));
end process;

end Behavioral_new;
