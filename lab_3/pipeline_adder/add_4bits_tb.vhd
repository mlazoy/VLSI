

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity pipe_4bits_tb is
end pipe_4bits_tb;

architecture testbench of pipe_4bits_tb is
component pipe_4bits is
    port (num_A, num_B: in std_logic_vector(3 downto 0);
      Carry_in, pulse: in std_logic;
      Sum_AB: out std_logic_vector(3 downto 0);
      Carry_out: out std_logic);
end component;

signal tst_clk, tst_rst: std_logic;

signal tst_A, tst_B, tst_Sum: std_logic_vector(3 downto 0);
signal tst_cin, tst_cout: std_logic;

begin

uut: pipe_4bits port map (num_A=>tst_A,
                          num_B=>tst_B,
                          Carry_in=>tst_cin,
                          pulse=>tst_clk,
                          Sum_AB=>tst_Sum,
                          Carry_out=>tst_cout);
                         
sim: process begin    
tst_rst<='0';                    
    for i in 0 to 15 loop
        for j in 0 to 15 loop
            for c in std_logic range '0' to '1' loop
                tst_A<=std_logic_vector(to_unsigned(i,4));
                tst_B<=std_logic_vector(to_unsigned(j,4));
                tst_cin<=c;
                tst_clk<='0';
                wait for 10ns;
                tst_clk<='1';
                wait for 10ns;
            end loop;
        end loop;
    end loop;                          

end process;                          


end testbench;
