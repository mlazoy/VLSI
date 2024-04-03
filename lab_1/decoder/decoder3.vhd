library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity decoder3 is
Port (enc : in STD_LOGIC_VECTOR (2 downto 0);
dec : out STD_LOGIC_VECTOR (7 downto 0));
end decoder3;
architecture Behavioral of decoder3x8 is
begin
process (enc)
begin
case enc is
when "000" =>
dec <= "00000001";
when "001" =>
dec <= "00000010";
when "010" =>
dec <= "00000100";
when "011" =>
dec <= "00001000";
when "100" =>
dec <= "00010000";
when "101" =>
dec <= "00100000";
when "110" =>
dec <= "01000000";
when "111" =>
dec <= "10000000";
when others =>
dec <= "00000000";
end case;
end process;
end Behavioral;