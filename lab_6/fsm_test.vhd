library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity finite_state_machine is
    generic (N_bits:integer:=5);
    port(
        clk, rst_n, new_img,vld_in: in std_logic;
        pxl_case: out std_logic_vector(1 downto 0);
        ready_img, vld_out, write_enable_for_fifo, average_unit_en: out std_logic;
        row_counter_out, pixel_counter_out : out std_logic_vector(N_bits-1 downto 0)
    );      
end finite_state_machine;

architecture Behavioral of finite_state_machine is

component counter is
    port (clk,rst_n, stall: in std_logic;
          cnt: out std_logic_vector(N_bits-1 downto 0);
          up: out std_logic);
end component;

component counter2 is
    port (
        clk, rst_n, stall : in std_logic;
        cnt: out std_logic_vector(N_bits+1 downto 0);
        up : out std_logic
    );
end component;

component counter_square is
    port (
        clk, rst_n, stall : in std_logic;
        cnt : out std_logic_vector(2*N_bits-1 downto 0);
        up : out std_logic
    );
end component;

signal row_cnt, pixel_cnt: std_logic_vector(N_bits-1 downto 0):=(others=>'0');
signal n_2_cnt : std_logic_vector(N_bits+1 downto 0) := (others => '0');
signal row_stall, pixel_stall, row_up, pixel_up, wait_for_img : std_logic;
signal n_2_up, n_2_up_prev, counter2_stall: std_logic;
signal finished_counting_2n_2, finished_counting_2n_2_prev : std_logic := '0';

signal n_square_cnt : std_logic_vector(2*N_bits-1 downto 0):=(others => '0');
signal n_square_up, n_square_up_prev, n_square_stall : std_logic;
signal finished_counting_n_square : std_logic := '0';

begin

--counter to count to 2N+2, so we know that fifo is ready to give us the 3x3 grid and the stall until finished and until new image

process(clk)
begin
    if rst_n = '0' then
        n_2_up_prev <= '0';
    elsif rising_edge(clk) then
        n_2_up_prev <= n_2_up; 
        finished_counting_2n_2_prev <= finished_counting_2n_2;
    end if;
end process;

process(n_2_up, n_2_up_prev, row_cnt, pixel_cnt)
begin
    if conv_integer(row_cnt)=0 and conv_integer(pixel_cnt)=0 then
        finished_counting_2n_2 <= '0';
    elsif n_2_up = '1' and n_2_up_prev = '0' then
        finished_counting_2n_2 <= '1';
    end if;
end process;

counter2_stall <= not vld_in or finished_counting_2n_2 or wait_for_img;
average_unit_en <= vld_in and finished_counting_2n_2;
vld_out <= vld_in and finished_counting_2n_2_prev;

n_2_counter : counter2 port map (
    clk => clk,
    rst_n => rst_n,
    stall => counter2_stall,
    cnt => n_2_cnt,
    up => n_2_up
);

--counter to count to  N^2, to know when to stop reading from input 

process(clk)
begin
    if rst_n = '0' then
        n_square_up_prev <= '0';
    elsif rising_edge(clk) then
        n_square_up_prev <= n_square_up; 
    end if;
end process;

process(n_square_up, n_square_up_prev, row_cnt, pixel_cnt)
begin 
    if conv_integer(row_cnt)=0 and conv_integer(pixel_cnt)=0 then
        finished_counting_n_square <= '0';
    elsif n_square_up = '1' and n_square_up_prev = '0' then
        finished_counting_n_square <= '1';
    end if;
end process;

n_square_stall <= not vld_in or finished_counting_n_square or wait_for_img;
write_enable_for_fifo <= vld_in and finished_counting_n_square;

n_square_counter: counter_square port map (
    clk => clk,
    rst_n => rst_n,
    stall => n_square_stall,
    cnt => n_square_cnt,
    up => n_square_up
);

--counters to start counting rows and pixels(columns) after 2N+2, for N^2 to filter the whole image

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

row_counter_out <= row_cnt;
pixel_counter_out <= pixel_cnt;

process(new_img, row_cnt, pixel_cnt) 
begin
    if new_img='1' and conv_integer(row_cnt)=0 and conv_integer(pixel_cnt)=0 then
        wait_for_img<='0';
    elsif new_img='0' and conv_integer(row_cnt)=0 and conv_integer(pixel_cnt)=0 then
        wait_for_img<='1';
    end if;
end process;

--stall until 2N+2 cycles have passed
pixel_stall<=not vld_in or wait_for_img or not finished_counting_2n_2;
row_stall<=not pixel_up or not finished_counting_2n_2;
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
