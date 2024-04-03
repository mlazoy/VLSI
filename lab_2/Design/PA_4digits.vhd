library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity digital4_adder is
    port (A1,A2,A3,A4,
          B1,B2,B3,B4 : in std_logic_vector(3 downto 0);
          S1,S2,S3,S4 : out std_logic_vector(3 downto 0);
          C_total: out std_logic);    
end digital4_adder;

architecture digital4_adder_structural of digital4_adder is
signal dig1_carry, dig2_carry, dig3_carry: std_logic;

component BCD_adder is
    port (
          Ain, Bin: in std_logic_vector(3 downto 0);
          Cin: in std_logic;
          S_units: out std_logic_vector(3 downto 0);
          C_bcd: out std_logic);
end component;


begin

BCD1: BCD_adder port map (Ain=>A1,
                          Bin=>B1,
                          Cin=>'0',
                          S_units=>S1,
                          C_bcd=>dig1_carry
                          );
                         
BCD2: BCD_adder port map (Ain=>A2,
                          Bin=>B2,
                          Cin=>dig1_carry,
                          S_units=>S2,
                          C_bcd=>dig2_carry
                          );
                         
BCD3: BCD_adder port map (Ain=>A3,
                          Bin=>B3,
                          Cin=>dig2_carry,
                          S_units=>S3,
                          C_bcd=>dig3_carry
                          );  
                                                 
BCD4: BCD_adder port map (Ain=>A4,
                          Bin=>B4,
                          Cin=>dig3_carry,
                          S_units=>S4,
                          C_bcd=>C_total
                          );

end digital4_adder_structural;
