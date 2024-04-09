library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pipe_4bits is
    port (num_A, num_B: in std_logic_vector(3 downto 0);
          Carry_in, pulse: in std_logic;
          Sum_AB: out std_logic_vector(3 downto 0);
          Carry_out: out std_logic);
end pipe_4bits;

architecture Pipeline of pipe_4bits is
component full_adder is 
    port (
        Ain, Bin, Cin, clk : in std_logic;
        Sum, Cout : out std_logic
    );
end component;  

signal reg0 : std_logic_vector(5 downto 0);
signal reg1 : std_logic_vector(4 downto 0);
signal reg2 : std_logic_vector(3 downto 0);
signal reg3 : std_logic_vector(2 downto 0);
signal f0_carry, f1_carry, f2_carry : std_logic;

begin

FA_0: full_adder port map (Ain=>num_A(0),
                           Bin=>num_B(0),
                           Cin=>Carry_in,
                           clk=>pulse,
                           Sum=>reg1(4),
                           Cout=>f0_carry);
                           
FA_1: full_adder port map (Ain=>reg0(0),
                          Bin=>reg0(3),
                          Cin=>f0_carry,
                          clk=>pulse,
                          Sum=>reg2(3),
                          Cout=>f1_carry);    
    
 FA_2: full_adder port map ( Ain=>reg1(0),
                             Bin=>reg1(2),
                             Cin=>f1_carry,
                             clk=>pulse,
                             Sum=>reg3(2),
                             Cout=>f2_carry);   
                               
 FA_3: full_adder port map ( Ain=>reg2(0),
                             Bin=>reg2(1),
                             Cin=>f2_carry,
                             clk=>pulse,
                             Sum=>Sum_AB(3),
                             Cout=>Carry_out);   
                             
process(pulse) begin   
    if rising_edge(pulse) then
        Sum_AB(0) <= reg3(0);
        Sum_AB(1) <= reg3(1);
        Sum_AB(2) <= reg3(2);
        --update registers
        reg3(0) <= reg2(2);
        reg3(1) <= reg2(3);

        reg2(0) <= reg1(1);
        reg2(1) <= reg1(3);
        reg2(2) <= reg1(4);                           

        reg1(0) <= reg0(1);
        reg1(1) <= reg0(2);
        reg1(2) <= reg0(4);
        reg1(3) <= reg0(5);
        --input
        reg0 <= num_B(3) & num_B(2) & num_B(1) & num_A(3) & num_A(2) & num_A(1);
        
   end if;
end process;

end Pipeline;