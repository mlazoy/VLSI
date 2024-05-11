library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FSM_tb is
end FSM_tb;

architecture Behavioral of FSM_tb is

component finite_state_machine is
    port(clk, rst_n, new_img,vld_in: in std_logic;
     pxl_case_in, pxl_case_out: out std_logic_vector(1 downto 0);
     ready_img, vld_out, avg_stall: out std_logic);   
end component;

signal clk_tb, rst_n_tb, new_img_tb, vld_in_tb, ready_img_tb, vld_out_tb, avg_stall_tb: std_logic;
signal pxl_case_in_tb, pxl_case_out_tb: std_logic_vector(1 downto 0);


begin

UUT: finite_state_machine 
                          port map (clk=>clk_tb,
                                    rst_n=>rst_n_tb,
                                    new_img=>new_img_tb,
                                    vld_in=>vld_in_tb,
                                    pxl_case_in=>pxl_case_in_tb,
                                    pxl_case_out=>pxl_case_out_tb,
                                    ready_img=>ready_img_tb,
                                    vld_out=>vld_out_tb,
                                    avg_stall=>avg_stall_tb
                                    );
testing: process
begin

vld_in_tb<='1';
rst_n_tb<='1';

new_img_tb<='0';
for i in 0 to 15 loop
    clk_tb<='0';
    wait for 10ns;
    clk_tb<='1';
    wait for 10ns;
end loop;

new_img_tb<='1';
for i in 0 to 32 loop
    for j in 0 to 32 loop
        clk_tb<='0';
        wait for 10ns;
        clk_tb<='1';
        wait for 10ns;
    end loop;
end loop;

wait;
end process;                                   

end Behavioral;
