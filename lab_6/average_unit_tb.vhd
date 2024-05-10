library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity average_unit_tb is
end average_unit_tb;

architecture average_unit_sim of average_unit_tb is

type grid3x3 is array (8 downto 0) of std_logic_vector(7 downto 0); --3x3 grid into 9-column array

component average_unit is
    port (
        clk, rst_n, en: in std_logic;
        pixel_case : in std_logic_vector(1 downto 0);
        pixel_grid : in grid3x3;
        R_avg, G_avg, B_avg : out std_logic_vector(7 downto 0)
    );
end component;

signal clk_tb, rst_n_tb, en_tb : std_logic;
signal pixel_case_tb : std_logic_vector(1 downto 0);
signal pixel_grid_tb : grid3x3;
signal R_avg_tb, B_avg_tb, G_avg_tb : std_logic_vector(7 downto 0);

begin
    pixel_average_unit_test : average_unit port map (
        clk => clk_tb,
        rst_n => rst_n_tb,
        en => en_tb,
        pixel_case => pixel_case_tb,
        pixel_grid => pixel_grid_tb,
        R_avg => R_avg_tb,
        G_avg => G_avg_tb,
        B_avg => B_avg_tb
    );

    testbench : process
    begin
    en_tb <= '1';
    rst_n_tb <= '0';
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    rst_n_tb <= '1';

    --1st example
    -- 99  69 148
    --153 241  39
    --203 211 152
    pixel_grid_tb(0) <= "01100011";
    pixel_grid_tb(1) <= "01000101";
    pixel_grid_tb(2) <= "10010100";
    pixel_grid_tb(3) <= "10011001";
    pixel_grid_tb(4) <= "11110001";
    pixel_grid_tb(5) <= "00100111";
    pixel_grid_tb(6) <= "11001011";
    pixel_grid_tb(7) <= "11010011";
    pixel_grid_tb(8) <= "10011000";
    
    for i in 0 to 3 loop
        pixel_case_tb <= std_logic_vector(to_unsigned(i, 2));
        clk_tb <= '0';
        wait for 50 ns;
        clk_tb <= '1';
        wait for 50 ns;
    end loop;

    --2nd example
    -- 28  75  14
    -- 83 254  44
    --127  21 125
    pixel_grid_tb(0) <= "00011100";
    pixel_grid_tb(0) <= "01001011";
    pixel_grid_tb(0) <= "00001110";
    pixel_grid_tb(0) <= "01010011";
    pixel_grid_tb(0) <= "11111110";
    pixel_grid_tb(0) <= "00101100";
    pixel_grid_tb(0) <= "01111111";
    pixel_grid_tb(0) <= "00010101";
    pixel_grid_tb(0) <= "01111101";

    for i in 0 to 3 loop
        pixel_case_tb <= std_logic_vector(to_unsigned(i, 2));
        clk_tb <= '0';
        wait for 50 ns;
        clk_tb <= '1';
        wait for 50 ns;
    end loop;

    wait;
    end process;
end average_unit_sim;