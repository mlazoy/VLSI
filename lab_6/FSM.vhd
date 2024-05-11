library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity finite_state_machine is
    generic (N_bits:integer:=5);
    port(clk, rst_n, new_img,vld_in: in std_logic;
     pxl_case_in, pxl_case_out: out std_logic_vector(1 downto 0);
     ready_img, vld_out, avg_stall: out std_logic);      
end finite_state_machine;

architecture Behavioral of finite_state_machine is

component counter is
    port (clk,rst_n, stall: in std_logic;
          cnt: out std_logic_vector(N_bits-1 downto 0);
          up: out std_logic);
end component;

component dff2 is 
    port (clk, rst: in std_logic;
          D: in std_logic_vector(1 downto 0);
          Q: out std_logic_vector(1 downto 0));
end component;

signal row_cnt, pixel_cnt: std_logic_vector(N_bits-1 downto 0):=(others=>'0');
signal pxl_case, prev_case: std_logic_vector(1 downto 0);
signal row_stall, pixel_stall, row_up, pixel_up: std_logic;

begin

row_counter: counter port map (clk=>clk,
                               rst_n=>rst_n,
                               stall=>row_stall,
                               cnt=>row_cnt,
                               up=>row_up);
                               
pixel_counter: counter port map (clk=>clk,
                                 rst_n=>rst_n,
                                 stall=>pixel_stall,
                                 cnt=>pixel_cnt,
                                 up=>pixel_up);   

prev_case_buffer: dff2 port map (clk=>clk,
                                rst=>rst_n,
                                D=>pxl_case,
                                Q=>prev_case
                                ); 
                                 
pxl_case_in<=pxl_case;
pxl_case_out<=prev_case;
pixel_stall<=not vld_in;
row_stall<=not pixel_up;
ready_img<=(row_up and pixel_up);
                                 
process(row_cnt, pixel_cnt)
begin
        if row_cnt(0)='0' then -- GB row
            if pixel_cnt(0)='0' then -- G pixel
                pxl_case<="01";     -- case ii
            elsif pixel_cnt(0)='1' then -- B pixel
                pxl_case<="11";     --case iv
            end if;
            
        elsif row_cnt(0)='1' then -- RG row
            if pixel_cnt(0)='0' then -- R pixel
                pxl_case<="10";     --case iii
            elsif pixel_cnt(0)='1' then -- G pixel
                pxl_case<="00";     --case i
            end if; 
        end if; 
end process;
                                                     
end Behavioral;
