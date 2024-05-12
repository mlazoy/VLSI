library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity counter2 is
    generic(N_bits:integer:=5);
    port (clk, rst_n, stall: in std_logic;
          --we are gonna use it to count until 2N + 2, we need n_bits + 1
          cnt: out std_logic_vector(N_bits + 1 downto 0);
          up: out std_logic);          
end counter2;

architecture Behavioral2 of counter2 is

signal N : integer := 2**N_bits;
signal up_limit: std_logic_vector(N_bits+1 downto 0):= std_logic_vector(to_unsigned(2*N + 1, N_bits+2));
signal up_count: std_logic_vector(N_bits+1 downto 0):=(others=>'0');

begin
    process(clk,rst_n)
    begin
        if rst_n='0' then                       
            up_count<=(others=>'0');
        elsif clk'event and clk='1' then
            if stall='0' then
                if up_count/=conv_integer(up_limit) then 
                    up_count<=up_count+1;
                else
                    up_count<=(others=>'0');
                end if;
            end if;
        end if;       
    end process;

cnt<=up_count;
up<='1' when up_count=up_limit else '0';

end Behavioral2;
