library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIR_tb is
end FIR_tb;

architecture fir_test of FIR_tb is
component FIR is
    generic (N: integer:= 8);
    port (valid_in, clk, rst: in std_logic;
          x: std_logic_vector(N-1 downto 0);
          valid_out: out std_logic;
          y: out std_logic_vector(2*N downto 0));
end component;
constant N : integer := 8; 
signal valid_in_tb, clk_tb, rst_tb, valid_out_tb : std_logic;
signal x_tb : std_logic_vector(N-1 downto 0);
signal y_tb : std_logic_vector(2*N downto 0);

begin

uut: FIR 
port map (
    valid_in => valid_in_tb,
    clk => clk_tb,
    rst => rst_tb,
    x => x_tb,
    valid_out => valid_out_tb,
    y => y_tb
);

testing: process
begin
    valid_in_tb <= '1';
    rst_tb <= '1';
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;
    rst_tb <= '0';
    
    x_tb <= "00001000";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "00000100";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "00100010";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "10110010";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "10000010";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "01101010";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "10001110";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "01000010";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "10101111";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "00110101";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    rst_tb <= '1';
    wait for 10 ns;
    rst_tb <= '0';

    x_tb <= "00110101";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    x_tb <= "01110101";
    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;
    
        valid_in_tb<='0';
        x_tb <= "01110111";
        for i in 0 to 9 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;
    
    valid_in_tb<='1';

    for i in 0 to 7 loop
        clk_tb <= '0';
        wait for 10 ns;
        clk_tb <= '1';
        wait for 10 ns;
    end loop;

    wait;
end process testing;
end fir_test;
