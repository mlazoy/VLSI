library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity multiplier4_bits_tb is
end multiplier4_bits_tb;

architecture multiplier_tb of multiplier4_bits_tb is
component multiplier4_bits is
    port (
        num_A, num_B : in std_logic_vector(3 downto 0);
        pulse : in std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end component;

signal num_A_tb, num_B_tb : std_logic_vector(3 downto 0);
signal pulse_tb : std_logic;
signal result_tb : std_logic_vector(7 downto 0);

begin

uut: multiplier4_bits
port map(
    num_A => num_A_tb,
    num_B => num_B_tb,
    pulse => pulse_tb,
    result => result_tb
);

testing : process
begin
    pulse_tb <= '0';

    num_A_tb <= "0111";
    num_B_tb <= "1110";
    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    num_A_tb <= "1001";
    num_B_tb <= "1011";
    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    num_A_tb <= "0010";
    num_B_tb <= "1011";
    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    num_A_tb <= "0101";
    num_B_tb <= "1111";
    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    pulse_tb <= '0';
    wait for 10 ns;
    pulse_tb <= '1';
    wait for 10 ns;

    wait;
end process testing;
end multiplier_tb;