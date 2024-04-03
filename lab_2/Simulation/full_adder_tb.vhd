library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity full_adder_tb is
end entity full_adder_tb;

architecture TestBench of full_adder_tb is

component full_adder is
    port (A,B,Cin: in std_logic;
          S,Cout: out std_logic);
end component;

signal A_tb, B_tb, Cin_tb, S_tb, Cout_tb: std_logic;

begin

uut: full_adder port map (A=>A_tb,
                          B=>B_tb,
                          Cin=>Cin_tb,
                          S=>S_tb,
                          Cout=>Cout_tb
                          );
                         
testbench: process
begin
    for i in std_logic range '0' to '1' loop
        for j in std_logic range '0' to '1' loop
            for k in std_logic range '0' to '1' loop
                A_tb<=i;
                B_tb<=j;
                Cin_tb<=k;
                wait for 10ns;
            end loop;
        end loop;      
    end loop;

end process;

end TestBench;