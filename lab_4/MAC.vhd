library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MAC is 
    port (rom_out, ram_out: in std_logic_vector(7 downto 0);
          clk, init: in std_logic;
          accumulator: out std_logic_vector(16 downto 0)); -- 8 bits + 8 bits + 1 
end MAC;

architecture Behavioral of MAC is
begin
    process(clk, init)
    begin 
        if clk'event and clk = '1' then
            if init = '1' then
                accumulator <= (others=>'0');
            end if;
            accumulator <= accumulator + rom_out*ram_out;
        end if;

    end process;

end Behavioral;
