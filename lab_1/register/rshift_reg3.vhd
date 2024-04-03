library IEEE;
use IEEE.std_logic_1164.all;
entity rshift_reg3 is
port (
clk,rst,si,en,pl, rot: in std_logic;
din: in std_logic_vector(3 downto 0);
so: out std_logic);
end rshift_reg3;
architecture rtl of rshift_reg3 is
signal dff: std_logic_vector(3 downto 0);
begin
edge: process (clk,rst,rot)
begin
if rst='0' then
dff<=(others=>'0');
elsif clk'event and clk='1' then
if pl='1' then
dff<=din;
elsif en='1' then
case rot is
when '1' => --assuming right shift
dff<=si&dff(3 downto 1);
when '0' =>
dff<=dff(2 downto 0)&si; --assuming left
shift
when others =>
null;
end case;
end if;
end if;
case rot is
when '1' => --keeps LSB
so <= dff(0);
when '0' =>
so <= dff(3); --keeps MSB
when others =>
null;
end case;
end process;
end rtl;