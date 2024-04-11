
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity full_adder_tb is
end full_adder_tb;

architecture TestBench of full_adder_tb is

component full_adder is 
    port (Ain,Bin,Cin, clk, rst: in std_logic;
          Sum, Cout: out std_logic);
end component;

signal Ain_tb,Bin_tb,Cin_tb,Sum_tb,Cout_tb,clk_tb,rst_tb: std_logic;

begin

FA: full_adder port map (Ain=>Ain_tb,
                         Bin=>Bin_tb,
                         Cin=>Cin_tb,
                         clk=>clk_tb,
                         rst=>rst_tb,
                         Sum=>Sum_tb,
                         Cout=>Cout_tb);
                         

sim: process 
begin
--reset is on
clk_tb<='0';
rst_tb<='1';
wait for 10ns;
clk_tb<='1';
wait for 10ns;

--reset is off
rst_tb<='0';

   for a in std_logic range '0' to '1' loop
     for b in std_logic range '0' to '1' loop
        for c in std_logic range '0' to '1' loop
            Ain_tb<=a;
            Bin_tb<=b;
            Cin_tb<=c;
            clk_tb<='0';
            wait for 10ns;
            clk_tb<='1';
            if clk_tb='1' then 
                assert Sum_tb=((a xor b) xor c) report "Incorrect sum" severity error;
                assert Cout_tb=((a and b) or (a and c) or (b and c)) report "Incorrect carry" severity error;
            end if;
            wait for 10ns;
        end loop;
     end loop;
   end loop;

end process;                  


end TestBench;



