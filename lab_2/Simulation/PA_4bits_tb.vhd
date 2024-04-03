library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity PA_4bits_tb is
end PA_4bits_tb;

architecture TestBench of PA_4bits_tb is

component PA_4bits is
    port (
          Ain, Bin: in std_logic_vector(3 downto 0);
          Cin: in std_logic;
          Sum: out std_logic_vector(3 downto 0);
          Carry_out: out std_logic);
end component;

signal Ain_tb, Bin_tb, Sum_tb: std_logic_vector(3 downto 0);
signal Cin_tb, Carry_out_tb: std_logic;

begin

uut : PA_4bits port map (Ain=>Ain_tb,
                            Bin=>Bin_tb,
                            Cin=>Cin_tb,
                            Sum=>Sum_tb,
                            Carry_out=>Carry_out_tb
                            );

testbench: process
variable addition: integer;
begin
    for i in 0 to 15 loop
        for j in 0 to 15 loop
            for k in std_logic range '0' to '1' loop
                addition:= i+j;
                if k='1' then
                    addition:= addition + 1;
                end if;
                Ain_tb<=std_logic_vector(to_unsigned(i,4));
                Bin_tb<=std_logic_vector(to_unsigned(j,4));
                Cin_tb<=k;
                assert Sum_tb=std_logic_vector(to_unsigned(addition,4));
                if addition > 15 then
                    assert Carry_out_tb='1';
                else
                    assert Carry_out_tb='0';
                end if;
                report "Addition failed for inputs:" severity error;
                wait for 10ns;
            end loop;
        end loop;
    end loop;

end process;

end TestBench;