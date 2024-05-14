library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity finite_state_machine is
    generic (N_bits:integer:=5);
    port(
        clk, rst_n, new_img,vld_in: in std_logic;
        pxl_case: out std_logic_vector(1 downto 0);
        ready_img, vld_out: out std_logic;
        row_counter_out, pixel_counter_out : out std_logic_vector(N_bits-1 downto 0)
    );      
end finite_state_machine;

architecture Behavioral of finite_state_machine is

component counter is
    port (clk,rst_n, stall: in std_logic;
          cnt: out std_logic_vector(N_bits-1 downto 0);
          up: out std_logic);
end component;

signal row_cnt, pixel_cnt, row_cnt_prev, pixel_cnt_prev: std_logic_vector(N_bits-1 downto 0):=(others=>'0');
signal pixel_case: std_logic_vector(1 downto 0);
signal row_stall, pixel_stall, row_up, pixel_up, wait_for_img: std_logic;
signal all_bits : std_logic_vector(N_bits-1 downto 0) := (others => '1');

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
                                 
pxl_case <= pixel_case;
pixel_stall<=not vld_in or wait_for_img;
row_stall<=not pixel_up;
ready_img<=(row_up and pixel_up);
row_counter_out <= row_cnt;
pixel_counter_out <= pixel_cnt;
                                 
process(row_cnt, pixel_cnt)
begin
        if row_cnt(0)='0' then -- GB row
            if pixel_cnt(0)='0' then -- G pixel
                 pixel_case<="01";     -- case ii
            elsif pixel_cnt(0)='1' then -- B pixel
                 pixel_case<="11";     --case iv
            end if;
            
        elsif row_cnt(0)='1' then -- RG row
            if pixel_cnt(0)='0' then -- R pixel
                 pixel_case<="10";     --case iii
            elsif pixel_cnt(0)='1' then -- G pixel
                 pixel_case<="00";     --case i
            end if; 
        end if; 
end process;

process(row_cnt, row_cnt_prev, pixel_cnt, pixel_cnt_prev)
begin
    --if now i am on the first pixel and before i was waiting the do vld_out = '1'
    if conv_integer(pixel_cnt) = 1 and conv_integer(pixel_cnt_prev) = 0 and conv_integer(row_cnt) = 0 and conv_integer(row_cnt_prev) = 0 then
        vld_out <= '1';
    elsif conv_integer(pixel_cnt) = 0 and conv_integer(pixel_cnt_prev) = all_bits and conv_integer(row_cnt) = 0 and conv_integer(row_cnt_prev) = all_bits then
        vld_out <= '0';
    end if;
end process;

process(new_img, row_cnt, pixel_cnt) 
begin
    if new_img='1' and conv_integer(row_cnt)=0 and conv_integer(pixel_cnt)=0 then
        wait_for_img<='0';
    elsif new_img='0' and conv_integer(row_cnt)=0 and conv_integer(pixel_cnt)=0 then
        wait_for_img<='1';
    end if;
end process;

process(clk, rst_n)
begin
    if rst_n='1' then 
        if clk'event and clk='1' then
            pixel_cnt_prev <= pixel_cnt;
            row_cnt_prev <= row_cnt;

        end if;
    end if;
end process;
                                                     
end Behavioral;
