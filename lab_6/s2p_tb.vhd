library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.PXL_GRID.all; 
use std.textio.all;
use ieee.std_logic_textio.all;

entity s2p_tb is
end s2p_tb;

architecture Behavioral of s2p_tb is

constant N_bits: integer:=5;

component s2p_converter is
port (clk, rst: in std_logic;
      --row_number, pixel_number : in std_logic_vector(N_bits-1 downto 0);
      pixel_in: std_logic_vector(7 downto 0);
      grid_out: out grid3x3);
--      valid_grid: out std_logic);
end component;

signal clk_tb, rst_tb, valid_grid_tb: std_logic;
signal pixel_in_tb: std_logic_vector(7 downto 0);
signal grid_out_tb: grid3x3;

file pixels_sample: text open read_mode is "sample_image.txt";
shared variable line_buff: line;
shared variable pixel_from_file: std_logic_vector(7 downto 0);

begin

tst: s2p_converter port map(clk=>clk_tb,
                            rst=>rst_tb,
                            pixel_in=>pixel_in_tb,
                            grid_out=>grid_out_tb);
--                            valid_grid=>valid_grid_tb);

testing: process
begin

rst_tb<='1';
clk_tb<='0';
wait for 10ns;
clk_tb<='1';
wait for 10ns;

rst_tb<='0';
wait for 10ns;

--for i in 0 to 32 loop
--    for j in 0 to 32 loop
--        pixel_in_tb<="10101010";
--        clk_tb<='0';
--        wait for 10ns;
--        clk_tb<='1';
--        wait for 10ns;
--    end loop;
--end loop;

while not endfile(pixels_sample) loop
    readline(pixels_sample, line_buff);
    read(line_buff,pixel_from_file); 
    pixel_in_tb<=pixel_from_file;
    clk_tb<='0';
    wait for 10ns;
    clk_tb<='1';
    wait for 10ns;
end loop;
wait;
end process testing;

end Behavioral;
