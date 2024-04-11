library ieee;
use ieee.std_logic_1164.all;

entity mult_4bits is
    port (num_A, num_B: in std_logic_vector(3 downto 0);
            pulse: std_logic;
            prod: out std_logic_vector(7 downto 0));
end mult_4bits;

architecture Systolic of mult_4bits is

component full_adder is
    port (A,B,Cin,clk: in std_logic;
          Cout, Sum: out std_logic);
end component;

component dff is
   port (D,clk: in std_logic;
         Q: out std_logic);
end component;

signal a3b0, a2b0, a1b0, a0b0,
        a3b1, a2b1, a1b1, a0b1,
        a3b2, a2b2, a1b2, a0b2,
        a3b3, a2b3, a1b3, a0b3 : std_logic;


signal buffer_A0, buffer_A1, buffer_A2, buffer_A3, 
        buffer_B0, buffer_B1, buffer_B2, buffer_B3: std_logic_vector(8 downto 0);

signal tmp_prod_0: std_logic_vector(9 downto 0);
signal tmp_prod_1: std_logic_vector(7 downto 0);
signal tmp_prod_2: std_logic_vector(5 downto 0);
signal tmp_prod_3: std_logic_vector(3 downto 0);
signal tmp_prod_4: std_logic_vector(2 downto 0);
signal tmp_prod_5: std_logic_vector(1 downto 0);

signal p_sum_1, p_sum_5: std_logic;
signal p_sum_2, p_sum_4: std_logic_vector(1 downto 0);
signal p_sum_3: std_logic_vector(2 downto 0);

signal carry_row_0, carry_row_1, carry_row_2, carry_row_3: std_logic_vector(2 downto 0);
signal forward_carry_0, forward_carry_1, forward_carry_2: std_logic_vector(1 downto 0);

begin
--A0*B0
a0b0 <= num_A(0) and num_B(0);
FA_00: full_adder port map (
    A=>a0b0,
    B=>'0', 
    Cin=>'0',
    clk=>pulse,
    Sum=>tmp_prod_0(0),
    Cout=>carry_row_0(0)
);

--A1*B0
a1b0 <= buffer_A1(0) and buffer_B0(0);
FA_10: full_adder port map (
    A=>a1b0,
    B=>'0',
    Cin=>carry_row_0(0),
    clk=>pulse,
    Sum=>p_sum_1,
    Cout=>carry_row_0(1)
);

--A2*B0
a2b0 <= buffer_A2(1) and buffer_B0(1);
FA_20: full_adder port map (
    A=>a2b0,
    B=>'0',
    Cin=>carry_row_0(1),
    clk=>pulse,
    Sum=>p_sum_2(0),
    Cout=>carry_row_0(2)
);

--A3*B0
a3b0 <= buffer_A3(2) and buffer_B0(2);
FA_30: full_adder port map (
    A=>a3b0,
    B=>'0',
    Cin=>carry_row_0(2),
    clk=>pulse,
    Sum=>p_sum_3(0),
    Cout=>forward_carry_0(0)
);

--A0*B1
a0b1 <= buffer_A0(1) and buffer_B1(1);
FA_01: full_adder port map (
    A=>a0b1,
    B=>p_sum_1,
    Cin=>'0',
    clk=>pulse,
    Sum=>tmp_prod_1(0),
    Cout=>carry_row_1(0)
);

--A1*B1
a1b1 <= buffer_A1(2) and buffer_B1(2);
FA_11: full_adder port map (
    A=>a1b1,
    B=>p_sum_2(0),
    Cin=>carry_row_1(0),
    clk=>pulse,
    Sum=>p_sum_2(1),
    Cout=>carry_row_1(1)
);

--A2*B1
a2b1 <= buffer_A2(3) and buffer_B1(3);
FA_21: full_adder port map (
    A=>a2b1,
    B=>p_sum_3(0),
    Cin=>carry_row_1(1),
    clk=>pulse,
    Sum=>p_sum_3(1),
    Cout=>carry_row_1(2)
);

--A3*B1
a3b1 <= buffer_A3(4) and buffer_B1(4);
FA_31: full_adder port map (
    A=>a3b1,
    B=>forward_carry_0(1), 
    Cin=>carry_row_1(2),
    clk=>pulse,
    Sum=>p_sum_4(0),
    Cout=>forward_carry_1(0)
);

--A0*B2
a0b2 <= buffer_A0(3) and buffer_B2(3);
FA_02: full_adder port map (
    A=>a0b2,
    B=>p_sum_2(1), 
    Cin=>'0',
    clk=>pulse,
    Sum=>tmp_prod_2(0),
    Cout=>carry_row_2(0)
);

--A1*B2
a1b2 <= buffer_A1(4) and buffer_B2(4);
FA_12: full_adder port map (
    A=>a1b2,
    B=>p_sum_3(1),
    Cin=>carry_row_2(0),
    clk=>pulse,
    Sum=>p_sum_3(2),
    Cout=>carry_row_2(1)
);

--A2*B2
a2b2 <= buffer_A2(5) and buffer_B2(5);
FA_22: full_adder port map (
    A=>a2b2,
    B=>p_sum_4(0),
    Cin=>carry_row_2(1),
    clk=>pulse,
    Sum=>p_sum_4(1),
    Cout=>carry_row_2(2)
);

--A3*B2
a3b2 <= buffer_A3(6) and buffer_B2(6);
FA_32: full_adder port map (
    A=>a3b2,
    B=>forward_carry_1(1),
    Cin=>carry_row_2(2),
    clk=>pulse,
    Sum=>p_sum_5,
    Cout=>forward_carry_2(0)
);

--A0*B3
a0b3 <= buffer_A0(5) and buffer_B3(5);
FA_03: full_adder port map (
    A=>a0b3,
    B=>p_sum_3(2),
    Cin=>'0',
    clk=>pulse,
    Sum=>tmp_prod_3(0),
    Cout=>carry_row_3(0)
);

--A1*B3
a1b3 <= buffer_A1(6) and buffer_B3(6);
FA_13: full_adder port map (
    A=>a1b3,
    B=>p_sum_4(1),
    Cin=>carry_row_3(0),
    clk=>pulse,
    Sum=>tmp_prod_4(0),
    Cout=>carry_row_3(1)
);

--A2*B3
a2b3 <= buffer_A2(7) and buffer_B3(7);
FA_23: full_adder port map (
    A=>a2b3,
    B=>p_sum_5,
    Cin=>carry_row_3(1),
    clk=>pulse,
    Sum=>tmp_prod_5(0),
    Cout=>carry_row_3(2)
);

--A3*B3
a3b3 <= buffer_A3(8) and buffer_B3(8);
FA_33: full_adder port map (
    A=>a3b3,
    B=>forward_carry_2(1),
    Cin=>carry_row_3(2),
    clk=>pulse,
    Sum=>prod(6),
    Cout=>prod(7)
);


--p0 registers
dff_p0_0: dff port map(D=>tmp_prod_0(0),
                          clk=>pulse,
                          Q=>tmp_prod_0(1)
                          );
                          
dff_p0_1: dff port map(D=>tmp_prod_0(1),
                    clk=>pulse,
                    Q=>tmp_prod_0(2)
                    );  
                    
dff_p0_2: dff port map(D=>tmp_prod_0(2),
                      clk=>pulse,
                      Q=>tmp_prod_0(3)
                      );  
                      
dff_p0_3: dff port map(D=>tmp_prod_0(3),
                    clk=>pulse,
                    Q=>tmp_prod_0(4)
                    );    
 
dff_p0_4: dff port map(D=>tmp_prod_0(4),
                        clk=>pulse,
                        Q=>tmp_prod_0(5)
                        );   
                        
dff_p0_5: dff port map(D=>tmp_prod_0(5),
                        clk=>pulse,
                        Q=>tmp_prod_0(6)
                        );    
                        
dff_p0_6: dff port map(D=>tmp_prod_0(6),
                        clk=>pulse,
                        Q=>tmp_prod_0(7)
                        );     
                        
dff_p0_7: dff port map(D=>tmp_prod_0(7),
                        clk=>pulse,
                        Q=>tmp_prod_0(8)
                        );                      
                              
dff_p0_8: dff port map(D=>tmp_prod_0(8),
                          clk=>pulse,
                          Q=>prod(0)
                          );   
                          
 --p1 registers                      
                          
dff_p1_0: dff port map(D=>tmp_prod_1(0),
                     clk=>pulse,
                     Q=>tmp_prod_1(1)
                     );      
                     
dff_p1_1: dff port map(D=>tmp_prod_1(1),
                      clk=>pulse,
                      Q=>tmp_prod_1(2)
                      );    
                      
dff_p1_2: dff port map(D=>tmp_prod_1(2),
                       clk=>pulse,
                       Q=>tmp_prod_1(3)
                       );   
                       
dff_p1_3: dff port map(D=>tmp_prod_1(3),
                        clk=>pulse,
                        Q=>tmp_prod_1(4)
                        );  
                        
dff_p1_4: dff port map(D=>tmp_prod_1(4),
                         clk=>pulse,
                         Q=>tmp_prod_1(5)
                         );   
                         
dff_p1_5: dff port map(D=>tmp_prod_1(5),
                          clk=>pulse,
                          Q=>tmp_prod_1(6)
                          );  
                          
dff_p1_6: dff port map(D=>tmp_prod_1(6),
                           clk=>pulse,
                           Q=>prod(1)
                           );   
                                                                                                                                                                                                                                                                                                                                                                                                                       
--p2 registers
dff_p2_0: dff port map(D=>tmp_prod_2(0),
                           clk=>pulse,
                           Q=>tmp_prod_2(1)
                           ); 
                            
dff_p2_1: dff port map(D=>tmp_prod_2(1),
                      clk=>pulse,
                      Q=>tmp_prod_2(2)
                      );  
                      
dff_p2_2: dff port map(D=>tmp_prod_2(2),
                    clk=>pulse,
                    Q=>tmp_prod_2(3)
                    );  
                        
dff_p2_3: dff port map(D=>tmp_prod_2(3),
                      clk=>pulse,
                      Q=>tmp_prod_2(4)
                      );  
 
 dff_p2_4: dff port map(D=>tmp_prod_2(4),
                        clk=>pulse,
                        Q=>prod(2)
                        );  
                      
--p3 registers
dff_p3_0: dff port map(D=>tmp_prod_3(0),
                      clk=>pulse,
                      Q=>tmp_prod_3(1)
                      );  

dff_p3_1: dff port map(D=>tmp_prod_3(1),
                      clk=>pulse,
                      Q=>tmp_prod_3(2)
                      );
                         
dff_p3_2: dff port map(D=>tmp_prod_3(2),
                        clk=>pulse,
                        Q=>prod(3)
                        );                        
                      
--p4 registers
dff_p4_0: dff port map(D=>tmp_prod_4(0),
                      clk=>pulse,
                      Q=>tmp_prod_4(1)
                      );   
                      
dff_p4_1: dff port map(D=>tmp_prod_4(1),
                        clk=>pulse,
                        Q=>prod(4)
                        ); 
                          
--p5 register
dff_p5_0: dff port map(D=>tmp_prod_5(0),
                        clk=>pulse,
                        Q=>prod(5)
                        );   
                                                                                                                                                                                                                                                                                                                        
--forward carries registers
dff_carry_0: dff port map (D=>forward_carry_0(0),
                           clk=>pulse,
                           Q=>forward_carry_0(1)
                           );
                           
dff_carry_1: dff port map (D=>forward_carry_1(0),
                          clk=>pulse,
                          Q=>forward_carry_1(1)
                          );
                          
dff_carry_2: dff port map (D=>forward_carry_2(0),
                         clk=>pulse,
                         Q=>forward_carry_2(1)
                         );                          

process(pulse) begin
    if rising_edge(pulse) then
        --shift all buffers and tmp_prod signals right and get new input values
        buffer_A0<=buffer_A0(7 downto 0) & num_A(0);
        buffer_A1<=buffer_A1(7 downto 0) & num_A(1);
        buffer_A2<=buffer_A2(7 downto 0) & num_A(2);
        buffer_A3<=buffer_A3(7 downto 0) & num_A(3);
        
        buffer_B0<=buffer_B0(7 downto 0) & num_B(0);
        buffer_B1<=buffer_B1(7 downto 0) & num_B(1);
        buffer_B2<=buffer_B2(7 downto 0) & num_B(2);
        buffer_B3<=buffer_B3(7 downto 0) & num_B(3);
    end if;
end process;

end Systolic;
