library ieee;
use ieee.std_logic_1164.all;

entity full_adder is 
    port (A,B,Cin,clk: in std_logic;
          Cout, Sum: out std_logic);
end full_adder;

architecture Behavioral of full_adder is
    begin
        process(clk) begin
            if clk'event and clk='1' then
               Sum<=((A xor B) xor Cin);
               Cout<=((A and B) or ((A xor B) and Cin));
            end if;   
        end process;
        
end Behavioral;
