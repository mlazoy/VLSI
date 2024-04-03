library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD_adder is
    port (
          Ain, Bin: in std_logic_vector(3 downto 0);
          Cin: in std_logic;
          S_units: out std_logic_vector(3 downto 0);
          C_bcd: out std_logic);
end BCD_adder;

architecture bcd_structural of BCD_adder is
signal binary_result: std_logic_vector(3 downto 0);
signal PA1_carry,PA2_carry,correct_value: std_logic;

component PA_4bits is
    port (Ain, Bin: in std_logic_vector(3 downto 0);
          Cin : in std_logic;
          Sum: out std_logic_vector(3 downto 0);
          Carry_out: out std_logic);
end component;

begin

PA1: PA_4bits port map (Ain=> Ain,
                        Bin=> Bin,
                        Cin=>Cin,
                        Sum=>binary_result,
                        Carry_out=>PA1_carry
                        );
                       
correct_value<='1' when ((binary_result(3) and binary_result(2))
                        or (binary_result(3) and binary_result(1))
                        or PA1_carry)='1'
                      else '0';                        
                       
PA2: PA_4bits port map (Ain=>binary_result,
                        Bin(0)=>'0',
                        Bin(1)=>correct_value,
                        Bin(2)=>correct_value,
                        Bin(3)=>'0',
                        Cin=>'0',
                        Sum=>S_units,
                        Carry_out=>PA2_carry
                        );  
                         
C_bcd<=(PA1_carry or PA2_carry);  
                                 
end bcd_structural;




