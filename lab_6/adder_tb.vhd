library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity pixel_adder_tb is
end pixel_adder_tb;

architecture pixel_adder_sim of pixel_adder_tb is

component pixel_adder is
    port (
        clk, rst_n : in std_logic;
        pixel_1, pixel_2, pixel_3, pixel_4 : in std_logic_vector(7 downto 0);
        sum : out std_logic_vector(9 downto 0)
    );
end component;

signal clk_tb, rst_n_tb : std_logic;
signal pixel_1_tb, pixel_2_tb, pixel_3_tb, pixel_4_tb : std_logic_vector(7 downto 0);
signal sum_tb : std_logic_vector(9 downto 0);

begin
    pixel_adder_test : pixel_adder port map (
        clk => clk_tb,
        rst_n => rst_n_tb,
        pixel_1 => pixel_1_tb,
        pixel_2 => pixel_2_tb,
        pixel_3 => pixel_3_tb,
        pixel_4 => pixel_4_tb,
        sum => sum_tb
    );

    testbench : process 
    begin
    rst_n_tb <= '0';
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    rst_n_tb <= '1';

    --1
    pixel_1_tb <= "00011100";
    pixel_2_tb <= "10101111";
    pixel_3_tb <= "01100010";
    pixel_4_tb <= "10000111";
    --expected sum = 436
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    --2
    pixel_1_tb <= "00010110";
    pixel_2_tb <= "10010001";
    pixel_3_tb <= "10001001";
    pixel_4_tb <= "11000110";
    --expected sum = 502
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    --3
    pixel_1_tb <= "11111101";
    pixel_2_tb <= "01110011";
    pixel_3_tb <= "00111111";
    pixel_4_tb <= "01000111";
    --expected sum = 502
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    --4
    pixel_1_tb <= "00100011";
    pixel_2_tb <= "00111101";
    pixel_3_tb <= "10110100";
    pixel_4_tb <= "01000101";
    --expected sum = 345
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    --5
    pixel_1_tb <= "10111000";
    pixel_2_tb <= "01100101";
    pixel_3_tb <= "10010101";
    pixel_4_tb <= "00111011";
    --expected sum = 493
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    --6
    pixel_1_tb <= "11111111";
    pixel_2_tb <= "11111111";
    pixel_3_tb <= "11111111";
    pixel_4_tb <= "11111111";
    --expected sum = 1020
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    wait;
    end process;
end pixel_adder_sim;