library ieee;
use ieee.std_logic_1164.all;

package custom_types_pkg_tb is
    -- Define the custom type
    type grid3x3 is array (8 downto 0) of std_logic_vector(7 downto 0);
end package custom_types_pkg_tb;

-- Use the package in your entity
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.PXL_GRID.all; -- Use your package here

entity average_unit_tb is
end average_unit_tb;

architecture average_unit_sim of average_unit_tb is

--type grid3x3 is array (8 downto 0) of std_logic_vector(7 downto 0);

component average_unit is
    port (
        clk, rst_n, valid_grid: in std_logic;
        pixel_case: in std_logic_vector(1 downto 0);
        pixel_grid : in grid3x3;
        R_avg, G_avg, B_avg : out std_logic_vector(7 downto 0)
    );
end component;

signal clk_tb, rst_n_tb, valid_grid_tb : std_logic;
signal pixel_case_tb: std_logic_vector(1 downto 0);
signal pixel_grid_tb : grid3x3;
signal R_avg_tb, B_avg_tb, G_avg_tb : std_logic_vector(7 downto 0);

begin
    pixel_average_unit_test : average_unit port map (
        clk => clk_tb,
        rst_n => rst_n_tb,
        valid_grid => valid_grid_tb,
        pixel_case => pixel_case_tb,
        pixel_grid => pixel_grid_tb,
        R_avg => R_avg_tb,
        G_avg => G_avg_tb,
        B_avg => B_avg_tb
    );

    testbench : process
    begin
    valid_grid_tb <= '0';
    rst_n_tb <= '0';
    clk_tb <= '0';
    wait for 50 ns;
    clk_tb <= '1';
    wait for 50 ns;

    rst_n_tb <= '1';

    --1st example
    clk_tb <= '0';
    wait for 50 ns;
    -- 99  69 148
    --153 241  39
    --203 211 152
    pixel_grid_tb <= (
    "01100011", "01000101", "10010100",
    "10011001", "11110001", "00100111",
    "11001011", "11010011", "10011000"
    );
    valid_grid_tb <= '1';
    pixel_case_tb <= "00";
    clk_tb <= '1';
    wait for 50 ns;

    for i in 1 to 3 loop
        clk_tb <= '0';
        wait for 50 ns;
        pixel_case_tb <= std_logic_vector(to_unsigned(i, 2));
        clk_tb <= '1';
        wait for 50 ns;
    end loop;
    valid_grid_tb <= '0';

    --2nd example
    clk_tb <= '0';
    wait for 50 ns;
    -- 28  75  14
    -- 83 254  44
    --127  21 125
    pixel_grid_tb <= (
    "00011100", "01001011", "00001110",
    "01010011", "11111110", "00101100",
    "01111111", "00010101", "01111101"
    );
    valid_grid_tb <= '1';
    pixel_case_tb <= "00";
    clk_tb <= '1';
    wait for 50 ns;

    for i in 1 to 3 loop
        clk_tb <= '0';
        wait for 50 ns;
        pixel_case_tb <= std_logic_vector(to_unsigned(i, 2));
        clk_tb <= '1';
        wait for 50 ns;
    end loop;
    valid_grid_tb <= '0';
    
    for i in 0 to 2 loop
        clk_tb <= '0';
        wait for 50 ns;
        clk_tb <= '1';
        wait for 50 ns;
    end loop;

    wait;
    end process;
end average_unit_sim;