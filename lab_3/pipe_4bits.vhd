library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity pipe_4bits is
    port (num_A, num_B: in std_logic_vector(3 downto 0);
          Carry_in: in std_logic;
          Sum_AB: out std_logic_vector(3 downto 0);
          Carry_out: out std_logic);
end pipe_4bits;

architecture Pipeline of pipe_4bits is
component full_adder is 
    port (Ain,Bin,Cin,clk,rst: in std_logic;
          Sum, Cout: out std_logic);
end component;  

-- clock and rst
signal pulse, reset: std_logic;

--input registers
signal buffer_A1, buffer_B1: std_logic;
signal buffer_A2, buffer_B2: std_logic_vector(1 downto 0);
signal buffer_A3, buffer_B3: std_logic_vector(2 downto 0);

--carry registers
signal tmp_cout, tmp_cin: std_logic_vector(2 downto 0);

--sum registers
signal tmp_S0: std_logic_vector(3 downto 0);
signal tmp_S1: std_logic_vector(2 downto 0);
signal tmp_S2: std_logic_vector(1 downto 0);


begin

FA_0: full_adder port map (Ain=>num_A(0),
                           Bin=>num_B(0),
                           Cin=>Carry_in,
                           clk=>pulse,
                           rst=>reset,
                           Sum=>tmp_S0(3),
                           Cout=>tmp_cout(0));
                           
FA_1: full_adder port map (Ain=>buffer_A1,
                          Bin=>buffer_B1,
                          Cin=>tmp_cin(0),
                          clk=>pulse,
                          rst=>reset,
                          Sum=>tmp_S1(2),
                          Cout=>tmp_cout(1));    
    
 FA_2: full_adder port map ( Ain=>buffer_A2(0),
                             Bin=>buffer_B2(0),
                             Cin=>tmp_cin(1),
                             clk=>pulse,
                             rst=>reset,
                             Sum=>tmp_S2(1),
                             Cout=>tmp_cout(2));   
                               
 FA_3: full_adder port map ( Ain=>buffer_A3(0),
                             Bin=>buffer_B3(0),
                             Cin=>tmp_cin(2),
                             clk=>pulse,
                             rst=>reset,
                             Sum=>Sum_AB(3),
                             Cout=>Carry_out);   
                              
-- renew input buffers when LSB goes for calc                             
buffer_A1<=num_A(1);
buffer_B1<=num_B(1);      

buffer_A2<=num_A(2) & buffer_A2(1);
buffer_B2<=num_B(2) & buffer_B2(1);

buffer_A3<=num_A(3) & buffer_A3(2) & buffer_A3(1);
buffer_B3<=num_B(3) & buffer_B3(2) & buffer_B3(1);

tmp_cin<=tmp_cout(2) & tmp_cout(1) & tmp_cout(0);

--result has been shifted to LSB through pipeline
Sum_AB(2 downto 0)<=tmp_S2(0) & tmp_S1(0) & tmp_S0(0);

-- shift sum registers to make space for next calc in MSB
tmp_S0<='0' & tmp_S0(3 downto 1);
tmp_S1<='0' & tmp_S1(2 downto 1);
tmp_S2<='0' & tmp_S2(1);


end Pipeline;
