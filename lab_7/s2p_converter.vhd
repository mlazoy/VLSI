library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.PXL_GRID.all; 

entity s2p_converter is
    generic(N_bits:integer:=4);
    port (clk, rst, en: in std_logic; --here rst positive logic because of s2p srst
          row_number, pixel_number : in std_logic_vector(N_bits-1 downto 0);
          pixel_in: in std_logic_vector(7 downto 0);
          grid_out: out grid3x3);
end s2p_converter;

architecture Behavioral of s2p_converter is

component fifo_generator_0 is
  port (
  clk : IN STD_LOGIC;
  srst : IN STD_LOGIC;
  din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
  wr_en : IN STD_LOGIC;
  rd_en : IN STD_LOGIC;
  dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
  full : OUT STD_LOGIC;
  --wr_ack : OUT STD_LOGIC;
  empty : OUT STD_LOGIC;
  valid : OUT STD_LOGIC;
  data_count : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
);
end component;

signal wr_ram_1, wr_ram_2, wr_ram_3: std_logic;
signal rd_ram_1, rd_ram_2, rd_ram_3: std_logic;

signal full_ram_1, full_ram_2, full_ram_3, empty_ram_1, empty_ram_2, empty_ram_3: std_logic;
--signal ack_ram_1, ack_ram_2, ack_ram_3: std_logic;
signal vld_1, vld_2, vld_3 : std_logic;

signal data_cnt_1, data_cnt_2, data_cnt_3: std_logic_vector(9 downto 0);

signal dout_fifo_1, dout_fifo_2, dout_fifo_3: std_logic_vector(7 downto 0);

signal grid_map: grid3x3;

signal all_bits: std_logic_vector(N_bits-1 downto 0):= (others=>'1');
signal N : integer := 2**N_bits;


begin

RAM_FIFO_1: fifo_generator_0 port map(clk=>clk,
                                      srst=>rst,
                                      din=>pixel_in,
                                      wr_en=>wr_ram_1,
                                      rd_en=>rd_ram_1,
                                      dout=>dout_fifo_1,
                                      full=>full_ram_1,
                                      --wr_ack=>ack_ram_1,
                                      empty=>empty_ram_1,
                                      valid=>vld_1,
                                      data_count=>data_cnt_1
                                      );
                                      
RAM_FIFO_2: fifo_generator_0 port map(clk=>clk,
                                        srst=>rst,
                                        din=>dout_fifo_1,
                                        wr_en=>wr_ram_2,
                                        rd_en=>rd_ram_2,
                                        dout=>dout_fifo_2,
                                        full=>full_ram_2,
                                        --wr_ack=>ack_ram_2,
                                        empty=>empty_ram_2,
                                        valid=>vld_2,
                                        data_count=>data_cnt_2
                                        );                                      

RAM_FIFO_3: fifo_generator_0 port map(clk=>clk,
                                      srst=>rst,
                                      din=>dout_fifo_2,
                                      wr_en=>wr_ram_3,
                                      rd_en=>rd_ram_3,
                                      dout=>dout_fifo_3,
                                      full=>full_ram_3,
                                      --wr_ack=>ack_ram_3,
                                      empty=>empty_ram_3,
                                      valid=>vld_3,
                                      data_count=>data_cnt_3
                                      );

wr_ram_1<=en;
wr_ram_2<=en;
wr_ram_3<=en;                             
process(clk, rst)
begin
    if rst = '1' then 
        grid_map<=(others=>(others=>'0'));
    elsif clk'event and clk='1' then
        if conv_integer(data_cnt_1)>=N-2 then         
            rd_ram_1<='1';
            rd_ram_2<='1';
            rd_ram_3<='1';  
        else
            rd_ram_1<='0';
            rd_ram_2<='0';
            rd_ram_3<='0';
--          valid_grid<='0';
        end if;
        
        if rd_ram_1 = '1' then
            grid_map(8)<=dout_fifo_1;
            grid_map(7)<=grid_map(8);
            grid_map(6)<=grid_map(7);
            grid_map(5)<=dout_fifo_2;
            grid_map(4)<=grid_map(5);
            grid_map(3)<=grid_map(4);
            grid_map(2)<=dout_fifo_3;
            grid_map(1)<=grid_map(2);
            grid_map(0)<=grid_map(1);
        end if;
        
    end if;
end process;  

--adjust for pixel in edges
process(row_number, pixel_number, grid_map)
    begin

    if (conv_integer(row_number) = 0 or conv_integer(pixel_number) = 0) then grid_out(0) <= (others => '0');
    else grid_out(0) <= grid_map(0);
    end if;
    if (conv_integer(row_number) = 0) then grid_out(1) <= (others => '0');
    else grid_out(1) <= grid_map(1);
    end if;
    if (conv_integer(row_number) = 0 or conv_integer(pixel_number) = N-1) then grid_out(2) <= (others => '0');
    else grid_out(2) <= grid_map(2);
    end if;
    if (conv_integer(pixel_number) = 0) then grid_out(3) <= (others => '0');
    else grid_out(3) <= grid_map(3);
    end if;
    grid_out(4) <= grid_map(4);
    if (conv_integer(pixel_number) = N-1) then grid_out(5) <= (others => '0');
    else grid_out(5) <= grid_map(5);
    end if;
    if (conv_integer(row_number) = N-1 or conv_integer(pixel_number) = 0) then grid_out(6) <= (others => '0');
    else grid_out(6) <= grid_map(6);
    end if;
    if (conv_integer(row_number) = N-1) then grid_out(7) <= (others => '0');
    else grid_out(7) <= grid_map(7);
    end if;
    if (conv_integer(row_number) = N-1 or conv_integer(pixel_number) = N-1) then grid_out(8) <= (others => '0');
    else grid_out(8) <= grid_map(8);
    end if;
end process;
                                    
end Behavioral;
