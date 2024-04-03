library IEEE;
use IEEE.std_logic_1164.all;
entity count3_tb is
end count3_tb;
architecture sim of count3_tb is
component count3 is
port (
clk, resetn, count_en, up_or_down: in std_logic;
sum: out std_logic_vector(2 downto 0);
cout: out std_logic
);
end component;
signal clk_tb, resetn_tb, count_en_tb, up_or_down_tb:
std_logic := '0';
signal sum_tb : std_logic_vector(2 downto 0);
signal cout_tb: std_logic;
begin
uut: count3
port map(
clk => clk_tb,
resetn => resetn_tb,
count_en => count_en_tb,
up_or_down => up_or_down_tb,
sum => sum_tb,
cout => cout_tb
);
stimulus_process: process
begin
clk_tb <= '0';
--we start with the reset and then not use it
resetn_tb <= '0';
count_en_tb <= '1';
up_or_down_tb <= '1';
for i in 0 to 70 loop
if i = 10 then resetn_tb <='1';
elsif i = 40 then up_or_down_tb <='0';
end if;
clk_tb <= not clk_tb; --toggle clock;
wait for 10ns;
end loop;
end process stimulus_process;
end sim;