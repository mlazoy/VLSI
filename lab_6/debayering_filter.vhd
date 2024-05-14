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
    clk, rst_n, valid_grid: in std_logic;
    pixel_case: in std_logic_vector(1 downto 0); 
    pixel_grid : in grid3x3;
    R_avg, G_avg, B_avg: out std_logic_vector(7 downto 0));
end component;

component finite_state_machine is
    port(clk, rst_n, new_img, vld_in: in std_logic;
     pxl_case: out std_logic_vector(1 downto 0);
     ready_img, vld_out: out std_logic;
     row_counter_out, pixel_counter_out : out std_logic_vector(N_bits-1 downto 0));   
end component;

component s2p_converter is 
port (clk, rst: in std_logic; 
  row_number, pixel_number : in std_logic_vector(N_bits-1 downto 0);
  pixel_in: in std_logic_vector(7 downto 0);
  grid_out: out grid3x3;
  valid_grid : out std_logic);
end component;

signal fsm_case: std_logic_vector(1 downto 0);
signal fsm_valid_grid: std_logic;

signal s2p_grid: grid3x3;
signal s2p_rst: std_logic;
signal s2p_row_counter, s2p_pixel_counter : std_logic_vector(N_bits-1 downto 0);

begin

AVG: average_unit port map (clk=>clk,
                            rst_n=>rst_n,
                            pixel_case=>fsm_case,
                            valid_grid=>fsm_valid_grid,
                            pixel_grid=>s2p_grid,
                            R_avg=>R,
                            G_avg=>G,
                            B_avg=>B);
                                                       
FSM: finite_state_machine port map(clk=>clk,
                                   rst_n=>rst_n,
                                   new_img=>fsm_valid_grid,
                                   vld_in=>fsm_valid_grid,
                                   pxl_case=>fsm_case,
                                   ready_img=>image_finished,
                                   vld_out=>valid_out,
                                   row_counter_out => s2p_row_counter,
                                   pixel_counter_out => s2p_pixel_counter
                                   );

s2p_rst<=not rst_n;

S2P: s2p_converter port map (clk=>clk,
                             rst=>s2p_rst,
                             row_number=>s2p_row_counter,
                             pixel_number=>s2p_pixel_counter,
                             pixel_in=>pixel,
                             grid_out=>s2p_grid,
                             valid_grid =>fsm_valid_grid
                             );

end Structural;
