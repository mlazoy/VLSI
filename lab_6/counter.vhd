library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity counter is
    generic(N_bits:integer:=5);
    port (clk,rst_n: in std_logic;
          cnt: out std_logic_vector(N_bits-1 downto 0));          
end counter;

architecture Behavioral of counter is

signal up_limit: std_logic_vector(N_bits-1 downto 0):=(others=>'1');
signal up_count: std_logic_vector(N_bits-1 downto 0);

begin
    process(clk,rst_n)
    begin
        if rst_n='1' then
            cnt<=(others=>'0');
        elsif clk'event and clk='1' then
            if up_count/=conv_integer(up_limit) then 
                up_count<=up_count+1;
            else
                up_count<=(others=>'0');
            end if;
        end if;       
    end process;

cnt<=up_count;

end Behavioral;
