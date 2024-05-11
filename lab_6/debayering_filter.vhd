library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.PXL_GRID.all; 

entity debayering_filter is
    generic (N_bits:integer:=5);                            --N_bits = log2(N)
    port (clk, rst_n: in std_logic;                         --rst_n: inverse logic
          new_image, valid_in: in std_logic;
          pixel: in std_logic_vector(7 downto 0);
          image_finished, valid_out: out std_logic;
          R,G,B: out std_logic_vector(7 downto 0));   
end debayering_filter;

architecture Structural of debayering_filter is

component average_unit is 
    port (
    clk, rst_n, en: in std_logic;
    pixel_case_in, pixel_case_out: in std_logic_vector(1 downto 0); 
    pixel_grid : in grid3x3;
    R_avg, G_avg, B_avg: out std_logic_vector(7 downto 0));
end component;

component finite_state_machine is
    port(clk, rst_n, new_img, vld_in: in std_logic;
     pxl_case_in, pxl_case_out: out std_logic_vector(1 downto 0);
     ready_img, vld_out, avg_stall: out std_logic);   
end component;

signal fsm_case_in, fsm_case_out: std_logic_vector(1 downto 0);
signal fsm_to_avg_en: std_logic;
signal s2p_grid: grid3x3;

begin

AVG: average_unit port map (clk=>clk,
                            rst_n=>rst_n,
                            pixel_case_in=>fsm_case_in,
                            pixel_case_out=>fsm_case_out,
                            en=>fsm_to_avg_en,
                            pixel_grid=>s2p_grid,
                            R_avg=>R,
                            G_avg=>G,
                            B_avg=>B);

                                                       
FSM: finite_state_machine port map(clk=>clk,
                                   rst_n=>rst_n,
                                   new_img=>new_image,
                                   vld_in=>valid_in,
                                   pxl_case_in=>fsm_case_in,
                                   pxl_case_out=>fsm_case_out,
                                   avg_stall=>fsm_to_avg_en,
                                   vld_out=>valid_out,
                                   ready_img=>image_finished
                                   );

end Structural;
