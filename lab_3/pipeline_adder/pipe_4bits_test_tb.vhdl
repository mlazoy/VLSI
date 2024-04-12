library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pipe_4bits_tb is
end pipe_4bits_tb;

architecture pipeline of pipe_4bits_tb is
component pipe_4bits
port (
    num_A, num_B: in std_logic_vector(3 downto 0);
    Carry_in, pulse: in std_logic;
    Sum_AB: out std_logic_vector(3 downto 0);
    Carry_out: out std_logic
);
end component;

signal Ain_tb, Bin_tb, Sum_tb : std_logic_vector(3 downto 0);
signal Cin_tb, Cout_tb, pulse_tb : std_logic;

begin

uut: pipe_4bits
port map(
    num_A => Ain_tb,
    num_B => Bin_tb,
    Carry_in => Cin_tb,
    pulse => pulse_tb,
    Sum_AB => Sum_tb,
    Carry_out => Cout_tb
);

testing : process
begin
    pulse_tb <= '0';
    Cin_tb <= '0';
    for i in 0 to 15 loop
        for j in 0 to 15 loop
            Ain_tb <= std_logic_vector(to_unsigned(i,4));
            Bin_tb <= std_logic_vector(to_unsigned(j,4));
            for k in std_logic range '0' to '1' loop
                pulse_tb <= k;
                wait for 10ns;
            end loop;
        end loop;
    end loop;
    wait;
end process testing;
end pipeline;