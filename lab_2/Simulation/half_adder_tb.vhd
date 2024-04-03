library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity half_adder_tb is
end half_adder_tb;

architecture TestBench of half_adder_tb is

component half_adder is
    port (a,b: in std_logic;
          sum, carry: out std_logic);
end component;

signal a_tb, b_tb, sum_tb, carry_tb: std_logic;

begin

uut: half_adder port map (a=>a_tb,
                          b=>b_tb,
                          sum=>sum_tb,
                          carry=>carry_tb
                          );
testbench: process
begin                          

    for i in std_logic range in '0' to '1'loop
        for j in std_logic range in '0' to '1' loop
            a_tb<=i;
            b_tb<=j;
            assert sum_tb='0' and carry_tb='0';
            report "sum or carry is incorrect for input bits:" &a_tb'image(a_tb) &b_tb'image(b_tb) severity error;
            wait for 10ns;
        end loop;
    end loop;

end process;



end TestBench;