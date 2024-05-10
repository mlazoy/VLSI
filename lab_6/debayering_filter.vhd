library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity debayering_filter is
    generic (N_bits:integer:=5);                            --N_bits = log2(N)
    port (clk, rst_n: in std_logic;
          new_image, valid_in: in std_logic;
          pixel: in std_logic_vector(7 downto 0);
          image_finished, valid_out: out std_logic;
          R,G,B: out std_logic_vector(7 downto 0));   
end debayering_filter;

architecture Structural of debayering_filter is

signal RGB_map: std_logic_vector(7 downto 0);
signal FSM_avg: std_logic;

component average_unit is 
    port (clk, rst_n, avg_init: in std_logic;
      next_pixel: in std_logic_vector(7 downto 0);
      X_avg: out std_logic_vector(7 downto 0));
end component;

component finite_state_machine is
     port(clk, rst_n, new_img, vld_in: in std_logic;
          ready_img, vld_out, new_avg_block: out std_logic);  
end component;

begin

AVG: average_unit port map (clk=>clk,
                            rst_n=>rst_n,
                            avg_init=>FSM_avg,
                            next_pixel=>pixel,
                            X_avg=>RGB_map
                            );
                            
FSM: finite_state_machine port map(clk=>clk,
                                   rst_n=>rst_n,
                                   new_img=>new_image,
                                   vld_in=>valid_in,
                                   vld_out=>valid_out,
                                   ready_img=>image_finished
                                   );

end Structural;
