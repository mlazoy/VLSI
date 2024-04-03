library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity count3_tb is
end count3_tb;
architecture sim of count3_tb is
component count3 is
port (
clk, resetn, count_en: in std_logic;
limit: in std_logic_vector(2 downto 0);
sum: out std_logic_vector(2 downto 0);
cout: out std_logic
);
end component;
signal clk_tb, resetn_tb, count_en_tb: std_logic := '0';
signal limit_tb : std_logic_vector(2 downto 0);
signal sum_tb : std_logic_vector(2 downto 0);
signal cout_tb: std_logic;
begin
uut: count3
port map(
clk => clk_tb,
resetn => resetn_tb,
count_en => count_en_tb,
limit => limit_tb,
sum => sum_tb,
cout => cout_tb
);
stimulus_process: process
begin
clk_tb <= '0'; --we start with the reset
resetn_tb <= '0';
count_en_tb <= '1';
wait for 10ns;
clk_tb<='1';
resetn_tb<='1';
for j in 1 to 7 loop
limit_tb <= std_logic_vector(to_unsigned(j, 3));
resetn_tb<='0';
clk_tb<=not clk_tb;
wait for 10ns;
resetn_tb<='1';
clk_tb<=not clk_tb;
for i in 0 to 4*j+2 loop
clk_tb <= not clk_tb; --toggle clock;
wait for 10ns;
end loop;
end loop;
end process stimulus_process;
end sim;