library ieee;
use ieee.std_logic_1164.all;

entity pipe_4bits is
    port (Ain, Bin: in std_logic_vector(3 downto 0);
          Carry_in, CLK: in std_logic;
          Sum_AB: out std_logic_vector(3 downto 0);
          Carry_out: out std_logic);
end pipe_4bits;


architecture Pipeline of pipe_4bits is

component full_adder is 
    port (A,B,Cin,clk: in std_logic;
          Cout, Sum: out std_logic);
end component;

component dff is
    port (D,clk: in std_logic;
          Q: out std_logic);
end component;

--input registers, each bit corresponds to buffer stage
signal buffer_A1, buffer_B1: std_logic;
signal buffer_A2, buffer_B2: std_logic_vector(1 downto 0);
signal buffer_A3, buffer_B3: std_logic_vector(2 downto 0);

--output registers, each bit corresponds to buffer stage
signal tmp_S0: std_logic_vector(3 downto 0);
signal tmp_S1: std_logic_vector(2 downto 0);
signal tmp_S2: std_logic_vector(1 downto 0);

--carries
signal tmp_carry: std_logic_vector(2 downto 0);

begin

--define adders
FA_0: full_adder port map(  A=>Ain(0),
                            B=>Bin(0),
                            Cin=>Carry_in,
                            clk=>CLK,
                            Sum=>tmp_S0(0),
                            Cout=>tmp_carry(0));
                            
FA_1: full_adder port map(  A=>buffer_A1,
                            B=>buffer_B1,
                            Cin=>tmp_carry(0),
                            clk=>CLK,
                            Sum=>tmp_S1(0),
                            Cout=>tmp_carry(1));  
                               
FA_2: full_adder port map(  A=>buffer_A2(0),
                            B=>buffer_B2(0),
                            Cin=>tmp_carry(1),
                            clk=>CLK,
                            Sum=>tmp_S2(0),
                            Cout=>tmp_carry(2)); 
                            
FA_3: full_adder port map(  A=>buffer_A3(0),
                            B=>buffer_B3(0),
                            Cin=>tmp_carry(2),
                            clk=>CLK,
                            Sum=>Sum_AB(3),
                            Cout=>Carry_out);  

-- define input registers
reg_A1: dff port map( D=>Ain(1),
                      clk=>CLK,
                      Q=>buffer_A1);   
                                                                                                                              
reg_B1: dff port map( D=>Bin(1),
                      clk=>CLK,
                      Q=>buffer_B1); 
                      
reg_A2_0: dff port map (D=>Ain(2),
                        clk=>CLK,
                        Q=>buffer_A2(0));                      

reg_B2_0: dff port map (D=>Bin(2),
                        clk=>CLK,
                        Q=>buffer_B2(0));   
                        
reg_A2_1: dff port map (D=>buffer_A2(0),
                        clk=>CLK,
                        Q=>buffer_A2(1));                             

reg_B2_1: dff port map (D=>buffer_B2(0),
                        clk=>CLK,
                        Q=>buffer_B2(1));  

reg_A3_0: dff port map (D=>Ain(3),
                        clk=>CLK,
                        Q=>buffer_A3(0));  

reg_B3_0: dff port map (D=>Bin(3),
                        clk=>CLK,
                        Q=>buffer_B3(0));  

reg_A3_1: dff port map (D=>buffer_A3(0),
                        clk=>CLK,
                        Q=>buffer_A3(1));  
                        
reg_B3_1: dff port map (D=>buffer_B3(0),
                        clk=>CLK,
                        Q=>buffer_B3(1));  
                        
reg_A3_2: dff port map (D=>buffer_A3(1),
                        clk=>CLK,
                        Q=>buffer_A3(2));  
                                               
reg_B3_2: dff port map (D=>buffer_B3(1),
                        clk=>CLK,
                        Q=>buffer_B3(2));   
 
--define sum saving registers
--results from F0_1     
reg_S0_0: dff port map( D=>tmp_S0(0),
                        clk=>CLK,
                        Q=>tmp_S0(1));   
                                         
reg_S0_1: dff port map( D=>tmp_S0(1),
                        clk=>CLK,
                        Q=>tmp_S0(2)); 
                        
reg_S0_2: dff port map( D=>tmp_S0(2),
                        clk=>CLK,
                        Q=>tmp_S0(3));  
                        
reg_S0_3: dff port map( D=>tmp_S0(3),
                        clk=>CLK,
                        Q=>Sum_AB(0)); 
                        
--results from F0_1                        
reg_S1_0: dff port map( D=>tmp_S1(0),
                        clk=>CLK,
                        Q=>tmp_S1(1)); 
                        
reg_S1_1: dff port map( D=>tmp_S1(1),
                        clk=>CLK,
                        Q=>tmp_S1(2));
 
reg_S1_2: dff port map( D=>tmp_S1(2),
                        clk=>CLK,
                        Q=>Sum_AB(1));  

--results from F0_2
reg_S2_0: dff port map( D=>tmp_S2(0),
                        clk=>CLK,
                        Q=>tmp_S2(1));   
                                             
reg_S2_1: dff port map( D=>tmp_S2(1),
                       clk=>CLK,
                       Q=>Sum_AB(2));  
                                                                                                              
end Pipeline;
