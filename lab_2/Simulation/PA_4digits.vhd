


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity dig4_adder_tb is
end dig4_adder_tb;

architecture Behavioral of dig4_adder_tb is

component digital4_adder is
    port (A1,A2,A3,A4,
      B1,B2,B3,B4 : in std_logic_vector(3 downto 0);
      S1,S2,S3,S4 : out std_logic_vector(3 downto 0);
      C_total: out std_logic);  
end component;

signal A1_tb, A2_tb, A3_tb, A4_tb, B1_tb, B2_tb, B3_tb, B4_tb, S1_tb, S2_tb, S3_tb, S4_tb: std_logic_vector(3 downto 0);
signal C_total_tb: std_logic;

begin
uut: digital4_adder port map (A1=>A1_tb,
                              A2=>A2_tb,
                              A3=>A3_tb,
                              A4=>A4_tb,
                              B1=>B1_tb,
                              B2=>B2_tb,
                              B3=>B3_tb,
                              B4=>B4_tb,
                              S1=>S1_tb,
                              S2=>S2_tb,
                              S3=>S3_tb,
                              S4=>S4_tb,
                              C_total=>C_total_tb);
                           

sim: process
begin
for i in 0 to 9999 loop
    for j in 0 to 9999 loop
        A1_tb<=std_logic_vector(to_unsigned(i mod 10,4));
        B1_tb<=std_logic_vector(to_unsigned(j mod 10,4));
        A2_tb<=std_logic_vector(to_unsigned((i/10) mod 10,4));
        B2_tb<=std_logic_vector(to_unsigned((i/10) mod 10,4));
        A3_tb<=std_logic_vector(to_unsigned((i/100) mod 10,4));
        B3_tb<=std_logic_vector(to_unsigned((i/100) mod 10,4));
        A4_tb<=std_logic_vector(to_unsigned((i/1000) mod 10,4));
        B4_tb<=std_logic_vector(to_unsigned((i/1000) mod 10,4));
        
        wait for 10ns;
    end loop;
end loop;
wait;
end process;


end Behavioral;
