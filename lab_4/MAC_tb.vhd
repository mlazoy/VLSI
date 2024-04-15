library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity MAC_tb is
end MAC_tb;

architecture Behavioral of MAC_tb is
component MAC is 
    port (rom_out, ram_out: in std_logic_vector(7 downto 0);
          clk, init: in std_logic;
          accumulator: out std_logic_vector(16 downto 0));
end component;

signal clk_tb,init_tb: std_logic;
signal rom_tb, ram_tb: std_logic_vector(7 downto 0);
signal accum_tb: std_logic_vector(16 downto 0);

begin

tst_unit: MAC port map (rom_out=>rom_tb,
                        ram_out=>ram_tb,
                        clk=>clk_tb,
                        init=>init_tb,
                        accumulator=>accum_tb
                        );
tst: process
variable fake_init_sig: integer;
begin
    fake_init_sig:= 1;
    init_tb <= '1';
    for i in 1 to 255 loop
        for j in 1 to 255 loop
            rom_tb <= std_logic_vector(to_unsigned(i,8));
            ram_tb <= std_logic_vector(to_unsigned(j,8));

            clk_tb <= '0';
            wait for 10ns;
            clk_tb <= '1';
            wait for 10ns;
                                  
            if (fake_init_sig mod 8) = 0 then 
                init_tb <= '1';
            else
                init_tb <= '0';
            end if;
            
            fake_init_sig:= fake_init_sig + 1;
            
        end loop;
    end loop;

end process;

end Behavioral;
