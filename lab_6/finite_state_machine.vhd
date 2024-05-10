library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity finite_state_machine is
    generic (N_bits:integer:=5);
    port(clk, rst_n, new_img, vld_in: in std_logic;
         ready_img, vld_out, new_avg_block: out std_logic);   
end finite_state_machine;

architecture Behavioral of finite_state_machine is

component counter is
    port (clk,rst_n: in std_logic;
          cnt: out std_logic_vector(N_bits-1 downto 0));
end component;

signal row_rst, pixel_rst: std_logic;
signal row_cnt, pixel_cnt: std_logic_vector(N_bits-1 downto 0);

begin

row_counter: counter port map (clk=>clk,
                               rst_n=>row_rst,
                               cnt=>row_cnt);
                               
pixel_counter: counter port map (clk=>clk,
                                 rst_n=>pixel_rst,
                                 cnt=>pixel_cnt);                               
end Behavioral;
