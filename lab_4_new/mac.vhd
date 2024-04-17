library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MAC is 
    generic (N : integer:=8);
    port (rom_out, ram_out: in std_logic_vector(N-1 downto 0);
          clk, init, rst, en: in std_logic;
          accumulator: out std_logic_vector(3*N-1 downto 0)); -- 8 bits + 8 bits + 1*8 
end MAC;

architecture Behavioral of MAC is
signal accum: std_logic_vector(3*N-1 downto 0);
signal mult: std_logic_vector(2*N-1 downto 0);
signal zeroes: std_logic_vector(N-1 downto 0):= (others=>'0');

begin
    process(clk, rst)
    begin 
        if rst = '1' then 
            accum <= (others=>'0');
        elsif clk'event and clk = '1' then
            if en='1' then
                mult <= rom_out*ram_out;
                if init = '1' then
                    accum <= zeroes & mult;
                else
                    accum <= accum + mult;
                end if;
            end if;
        end if;
    end process;
    accumulator <= accum;

end Behavioral;

