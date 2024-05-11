library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity finite_state_machine is
    generic (N_bits:integer:=5);
    port(clk, rst_n, new_img, vld_in: in std_logic;
         pxl_case_in, pxl_case_out: out std_logic_vector(1 downto 0);
         ready_img, vld_out, avg_stall: out std_logic);   
end finite_state_machine;

architecture Behavioral of finite_state_machine is

component counter is
    port (clk,rst_n, stall: in std_logic;
          cnt: out std_logic_vector(N_bits-1 downto 0));
end component;

component dff2 is 
    port (clk, rst: in std_logic;
          D: in std_logic_vector(1 downto 0);
          Q: out std_logic_vector(1 downto 0));
end component;

signal row_cnt, pixel_cnt: std_logic_vector(N_bits-1 downto 0):=(others=>'0');
signal counter_stall: std_logic:='0';
signal pxl_case, prev_case: std_logic_vector(1 downto 0);
constant all_bits: std_logic_vector(N_bits-1 downto 0):=(others=>'1');

begin

row_counter: counter port map (clk=>clk,
                               rst_n=>rst_n,
                               stall=>counter_stall,
                               cnt=>row_cnt);
                               
pixel_counter: counter port map (clk=>clk,
                                 rst_n=>rst_n,
                                 stall=>counter_stall,
                                 cnt=>pixel_cnt);   

prev_case_buffer: dff2 port map (clk=>clk,
                                rst=>rst_n,
                                D=>pxl_case,
                                Q=>prev_case
                                ); 
                                 
process(clk, rst_n)
begin
    if rst_n='1' then 
        if clk'event and clk='1' then 
            counter_stall<=(not vld_in);
            pxl_case_in<=pxl_case;
            pxl_case_out<=prev_case;
        end if;
    end if;    

end process;

                                 
process(row_cnt, pixel_cnt)
begin
    if row_cnt(0)='0' then -- GB row
        if pixel_cnt(0)='0' then -- G pixel
            pxl_case<="00";     -- case i
        elsif pixel_cnt(0)='1' then -- B pixel
            pxl_case<="11";     --case iv
        end if;
        
    elsif row_cnt(0)='1' then -- RG row
        if pixel_cnt(0)='0' then -- R pixel
            pxl_case<="10";     --case iii
        elsif pixel_cnt(0)='1' then -- G pixel
            pxl_case<="01";     --case ii
        end if; 
    end if; 
    
    if (row_cnt=all_bits and pixel_cnt=all_bits) then
        ready_img<='1';
    else
        ready_img<='0';
    end if;

end process;

                                                            
end Behavioral;
