library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.PXL_GRID.all; 
use std.textio.all;
use ieee.std_logic_textio.all;

entity debayering_filter_tb is
end debayering_filter_tb;

architecture sim of debayering_filter_tb is

constant N_bits : integer := 5;

component debayering_filter is
    port (
        clk, rst_n : in std_logic;
        new_image, valid_in: in std_logic;
        pixel : in std_logic_vector(7 downto 0);
        image_finished, valid_out : out std_logic;
        R, G, B : out std_logic_vector(7 downto 0)
    );
end component;

signal clk_tb, rst_tb, new_image_tb, valid_in_tb, image_finished_tb, valid_out_tb : std_logic;
signal pixel_tb, R_tb, G_tb, B_tb : std_logic_vector(7 downto 0);

file pixels_sample: text open read_mode is "sample_image.txt";
shared variable line_buff: line;
shared variable pixel_from_file: std_logic_vector(7 downto 0);

begin

total_filter : debayering_filter port map (
    clk => clk_tb,
    rst_n => rst_tb,
    new_image => new_image_tb,
    valid_in => valid_in_tb,
    pixel => pixel_tb,
    image_finished => image_finished_tb,
    valid_out => valid_out_tb,
    R => R_tb,
    G => G_tb,
    B => B_tb
);

testing: process
begin

rst_tb<='0';
clk_tb<='0';
wait for 10ns;
clk_tb<='1';
wait for 10ns;

rst_tb<='1';
wait for 10ns;

new_image_tb <= '1';
valid_in_tb <= '1';

while not endfile(pixels_sample) loop
    readline(pixels_sample, line_buff);
    read(line_buff,pixel_from_file); 
    pixel_tb<=pixel_from_file;
    clk_tb<='0';
    wait for 10ns;
    clk_tb<='1';
    wait for 10ns;
end loop;

valid_in_tb <= '0';

for i in 0 to 65 loop
    clk_tb<='0';
    wait for 10ns;
    clk_tb<='1';
    wait for 10ns;
end loop;

wait;
end process testing;

end sim;