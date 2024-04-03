library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity bcd_tb is
end bcd_tb;

architecture TestBench of bcd_tb is

component BCD_adder is
    port (
      Ain, Bin: in std_logic_vector(3 downto 0);
      Cin: in std_logic;
      S_units: out std_logic_vector(3 downto 0);
      C_bcd: out std_logic);
end component;

signal Ain_tb, Bin_tb ,S_units_tb: std_logic_vector(3 downto 0);
signal Cin_tb, C_bcd_tb: std_logic;

begin
uut: BCD_adder port map (Ain=>Ain_tb,
                         Bin=>Bin_tb,
                         Cin=>Cin_tb,
                         S_units=>S_units_tb,
                         C_bcd=>C_bcd_tb
                         );
  testing:process
 variable add: integer;
  begin
    for i in 0 to 9 loop
        for j in 0 to 9 loop
            add:= i+j;
            for c in std_logic range '0' to '1' loop
                if c='1' then
                    add:= add+1;
                end if;
                Ain_tb<=std_logic_vector(to_unsigned(i,4));
                Bin_tb<=std_logic_vector(to_unsigned(j,4));
                Cin_tb<=c;
                assert (S_units_tb=add mod 10) report "Incorrect bcd sum" severity error;
                if add>9 then
                    assert C_bcd='1' report "Incorrect Decimals" severity error;
                else
                    assert C_bcd='0' report "Incorrect Decimals" severity error;
                end if;
                wait for 10ns;
            end loop;
        end loop;
    end loop;    
  end process;                    

end TestBench;