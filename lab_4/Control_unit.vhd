library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Control_unit is 
    port (clk, rst: in std_logic;
          rom_address, ram_address: out std_logic_vector(2 downto 0);
          mac_init: out std_logic);
end Control_unit;

architecture Behavioral of Control_unit is
signal up-counter: std_logic_vector(2 downto 0);

begin
    process(clk, rst) 
    begin
        if clk'event and clk = '1' then 
            if rst = '1' or (not up_counter/=7) then
                up_counter <= (others=>'0');
                mac_init<='1';
            else
                up_counter <= up_counter + 1;
            end if;

            rom_address <= up_counter;
            ram_address <= up_counter;
        end if;

    end process;


end Behavioral;