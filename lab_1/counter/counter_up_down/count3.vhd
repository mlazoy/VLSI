library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity count3 is
port (
clk, resetn, count_en, up_or_down: in std_logic;
sum: out std_logic_vector(2 downto 0);
cout: out std_logic
);
end;
architecture rtl_limit of count3 is
signal count: std_logic_vector(2 downto 0);
begin
process(clk, resetn)
begin
if resetn='0' then
count <= (others=>'0');
elsif clk'event and clk='1' then
if count_en='1' then
case up_or_down is
when '0' =>
if count/=0 then count <= count - 1;
else count <= (others=>'1');
end if;
when '1' =>
if count/=7 then count <= count + 1;
else count <= (others=>'0');
end if;
when others => null;
end case;
end if;
end if;
end process;
sum <= count;
cout <= '1' when (count = 7 and count_en='1' and up_or_down='1')
or (count = 0 and count_en='1' and up_or_down='0') else '0';
end rtl_limit;