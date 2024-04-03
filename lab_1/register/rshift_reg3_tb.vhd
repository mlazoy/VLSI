library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
entity test_reg3_shift is
end test_reg3_shift;
architecture TestBench of test_reg3_shift is
component rshift_reg3 is
port ( clk, en, rst, si, pl, rot: in std_logic;
din: in std_logic_vector(3 downto 0);
so: out std_logic);
end component;
signal clk_tb, en_tb, rst_tb, si_tb, pl_tb, rot_tb: std_logic;
signal din_tb: std_logic_vector(3 downto 0);
signal so_tb: std_logic;
begin
uut: rshift_reg3
port map ( clk => clk_tb,
en => en_tb,
rst => rst_tb,
si => si_tb,
pl => pl_tb,
rot => rot_tb,
din => din_tb,
so => so_tb );
simulation: process
begin
--initialise inputs to parallel load data at first
en_tb<='1'; -- change this to check enable
rst_tb<='1'; -- change this to check reset
pl_tb<='1';
clk_tb<='0';
din_tb<="1100";
wait for 10ns;
clk_tb<='1';
--check right shifting
wait for 10ns;
pl_tb<='0';
rot_tb<='1';
si_tb<='1';
clk_tb<='0';
for i in 0 to 7 loop -- 4 shifts should give 0011
clk_tb<=not clk_tb;
wait for 10ns;
end loop; -- by this point din should be 1111
--check left shifting
rot_tb<='0';
si_tb<='0';
for i in 0 to 9 loop -- loop once more to see if zero finally
passed to output
clk_tb<=not clk_tb;
wait for 10ns;
end loop;
end process simulation;
end TestBench;