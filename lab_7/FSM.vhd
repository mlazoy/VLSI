library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity finite_state_machine is
    generic (N_bits:integer:=4);
    port(
        clk, rst_n,vld_in, new_image: in std_logic;
        pxl_case: out std_logic_vector(1 downto 0);
        ready_img, vld_out, s2p_en, vld_grid: out std_logic;
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

signal input_row_stall, input_row_up, input_pixel_stall, input_pixel_up, wait_for_input : std_logic;
signal input_row_cnt, input_pixel_cnt : std_logic_vector(N_bits-1 downto 0);
signal stage, prev_stage : std_logic_vector(1 downto 0) := "00";

begin

--counter to know in which phase i am in 
input_row_counter : counter port map (
    clk => clk,
    rst_n => rst_n,
    stall => input_row_stall,
    cnt => input_row_cnt,
    up => input_row_up
);

input_pixel_counter : counter port map (
    clk => clk,
    rst_n => rst_n,
    stall => input_pixel_stall,
    cnt => input_pixel_cnt,
    up => input_pixel_up
);

input_pixel_stall <= not vld_in  or wait_for_input;
input_row_stall <= not input_pixel_up;
vld_grid<='1' when (stage="01" and vld_in='1') or stage="10" or (conv_integer(input_pixel_cnt) = 1 and conv_integer(input_row_cnt) = 2) else '0';
vld_out<='1' when (prev_stage="01" and vld_in='1') or prev_stage="10" else '0';
ready_img <= '1' when prev_stage="10" and stage="00" else '0';

process(new_image, input_row_cnt, input_pixel_cnt) 
begin
    if new_image='1' and conv_integer(input_row_cnt)=0 and conv_integer(input_pixel_cnt)=0 then
        wait_for_input<='0';
    elsif new_image='0' and conv_integer(input_row_cnt)=0 and conv_integer(input_pixel_cnt)=0 then
        wait_for_input<='1';
    end if;
end process;

process(input_pixel_cnt, input_row_cnt, row_up, pixel_up)
begin
    if (conv_integer(input_pixel_cnt) = 2 and conv_integer(input_row_cnt) = 2) then 
        stage<= "01";
    elsif input_pixel_cnt = all_bits and input_row_cnt = all_bits then 
        stage<= "10";
    elsif conv_integer(row_cnt) = 0 and conv_integer(pixel_cnt) = 0 and row_cnt_prev = all_bits and pixel_cnt_prev = all_bits then  
        stage<= "00";
    end if;
end process;


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
                                 
--stall if we are in the first phase then stall, and if we are in the second phase stall if valid_in = 0
pixel_stall<='1' when (stage="00" or (vld_in='0' and stage="01")) else '0';
row_stall<=not pixel_up;
row_counter_out <= row_cnt;
pixel_counter_out <= pixel_cnt;
pxl_case <= pixel_case;

--s2p enable
s2p_en <= '1' when ((stage="00" or stage="01") and vld_in='1') or stage="10" else '0';

                                 
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

--process(row_cnt, row_cnt_prev, pixel_cnt, pixel_cnt_prev)
--begin
--    --if now i am on the first pixel and before i was waiting the do vld_out = '1'
--    if conv_integer(pixel_cnt) = 1 and conv_integer(pixel_cnt_prev) = 0 and conv_integer(row_cnt) = 0 and conv_integer(row_cnt_prev) = 0 then
--        vld_out <= '1';
--    elsif conv_integer(pixel_cnt) = 0 and conv_integer(row_cnt) = 0 then
--        vld_out <= '0';
--    end if;
--end process;

--process(start_fsm, row_cnt, pixel_cnt) 
--begin
--    if start_fsm='1' and conv_integer(row_cnt)=0 and conv_integer(pixel_cnt)=0 then
--        wait_for_img<='0';
--    elsif start_fsm='0' and conv_integer(row_cnt)=0 and conv_integer(pixel_cnt)=0 then
--        wait_for_img<='1';
--    end if;
--end process;

process(clk, rst_n)
begin
    if rst_n='0' then
    elsif clk'event and clk='1' then
            pixel_cnt_prev <= pixel_cnt;
            row_cnt_prev <= row_cnt;
            prev_stage <= stage;
    end if;
end process;
                                                     
end Behavioral;
