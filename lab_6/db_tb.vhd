library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.PXL_GRID.all; 
use std.textio.all;
use ieee.std_logic_textio.all;

entity db_tb is
end db_tb;

architecture Behavioral of db_tb is

component debayering_filter is
port (clk, rst_n: in std_logic;                         --rst_n: inverse logic
      new_image, valid_in: in std_logic;
      pixel: in std_logic_vector(7 downto 0);
      image_finished, valid_out: out std_logic;
      R,G,B: out std_logic_vector(7 downto 0));   
end component;

file pixels_sample: text open read_mode is "sample_image.txt";
shared variable line_buff: line;
shared variable pixel_from_file: std_logic_vector(7 downto 0);

signal clk_tb, rst_n_tb, new_img_tb, vld_in_tb: std_logic;
signal pixel_tb, R_tb, G_tb, B_tb: std_logic_vector(7 downto 0);
signal img_fin_tb, vld_out_tb: std_logic;

begin

tbu: debayering_filter port map (clk=>clk_tb,
                                 rst_n=>rst_n_tb,
                                 new_image=>new_img_tb,
                                 valid_in=>vld_in_tb,
                                 pixel=>pixel_tb,
                                 image_finished=>img_fin_tb,
                                 valid_out=>vld_out_tb,
                                 R=>R_tb,
                                 G=>G_tb,
                                 B=>B_tb
                                 );

            
tb: process
begin

rst_n_tb<='0';
clk_tb<='0';
wait for 10ns;
clk_tb<='1';
wait for 10ns;

rst_n_tb<='1';
new_img_tb<='1';
vld_in_tb<='1';

    while not endfile(pixels_sample) loop
        readline(pixels_sample, line_buff);
        read(line_buff,pixel_from_file); 
        pixel_tb<=pixel_from_file;
        clk_tb<='0';
        wait for 10ns;
        clk_tb<='1';
        wait for 10ns;
    end loop;
    wait;
end process;


end Behavioral;
