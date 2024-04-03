library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity dec3x8 is
Port (Enc : in STD_LOGIC_VECTOR (2 downto 0);
Dec : out STD_LOGIC_VECTOR (7 downto 0));
end dec3x8;
architecture dataflow of dec3x8 is
begin
Dec(0) <= (not Enc(0)) and (not Enc(1)) and (not Enc(2));
Dec(1) <= Enc(0) and (not Enc(1)) and (not Enc(2));
Dec(2) <= (not Enc(0)) and Enc(1) and (not Enc(2));
Dec(3) <= Enc(0) and Enc(1) and (not Enc(2));
Dec(4) <= (not Enc(0)) and (not Enc(1)) and Enc(2);
Dec(5) <= Enc(0) and (not Enc(1)) and Enc(2);
Dec(6) <= (not Enc(0)) and Enc(1) and Enc(2);
Dec(7) <= Enc(0) and Enc(1) and Enc(2);
end dataflow;