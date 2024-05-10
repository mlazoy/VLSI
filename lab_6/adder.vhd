library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pixel_adder is
    port(clk,rst_n: in std_logic;
         pixel_1, pixel_2, pixel_3, pixel_4: in std_logic_vector(7 downto 0);
         sum: out std_logic_vector(9 downto 0)); -- 2 more bit to avoid overflow here 
end pixel_adder;

architecture Behavioral of pixel_adder is

begin
    process(clk, rst_n)
    begin 
        if rst_n='0' then 
            sum <= (others=>'0');
        elsif clk'event and clk='1' then 
            sum <= (("00" & pixel_1) + ("00" & pixel_2)) + (("00" & pixel_3) + ("00" & pixel_4));
        end if;
    
    end process;


end Behavioral;
