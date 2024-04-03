library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PA_4bits is
    port (
          Ain, Bin: in std_logic_vector(3 downto 0);
          Cin: in std_logic;
          Sum: out std_logic_vector(3 downto 0);
          Carry_out: out std_logic);
end PA_4bits;

architecture PA_4bits_structural of PA_4bits is

signal p_sum, f1_carry, f2_carry, f3_carry: std_logic;

component full_adder is
    port(A,B,Cin: in std_logic;
         S, Cout: out std_logic);
end component;

begin

a1: full_adder port map (A => Ain(0),
                         B => Bin(0),
                         Cin => Cin,
                         S => Sum(0),
                         Cout => f1_carry
                         );                        

a2: full_adder port map (A => Ain(1),
                      B => Bin(1),
                      Cin => f1_carry,
                      S => Sum(1),
                      Cout => f2_carry
                      );                    
                                           
a3: full_adder port map (A => Ain(2),
                         B => Bin(2),
                         Cin => f2_carry,
                         S => Sum(2),
                         Cout => f3_carry
                         );                        
                         
a4: full_adder port map (A => Ain(3),
                         B => Bin(3),
                         Cin => f3_carry,
                         S => Sum(3),
                         Cout => Carry_out
                         );                                                  

end PA_4bits_structural;
