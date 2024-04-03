library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    port(
         A,B,Cin: in std_logic;
         S,Cout: out std_logic);
end full_adder;

architecture structural of full_adder is
signal carry_out_h1, carry_out_h2, h_sum: std_logic;

component half_adder is
    port (
          a,b : in std_logic;
          sum, carry : out std_logic);
end component;

begin
u1: half_adder port map (a => A,
                         b => B,
                         sum => h_sum,
                         carry => carry_out_h1);
                                                 
u2: half_adder port map (a => h_sum,
                         b => Cin,
                         sum => S,
                         carry => carry_out_h2);  
                                 
Cout <= carry_out_h1 xor carry_out_h2;

end structural;

