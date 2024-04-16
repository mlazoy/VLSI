library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Control_unit is 
    port (clk, rst: in std_logic;
          rom_address, ram_address: out std_logic_vector(2 downto 0);
          mac_init, ram_init: out std_logic);
end Control_unit;

architecture Behavioral of Control_unit is
signal up_counter: std_logic_vector(2 downto 0);

begin
    process(clk, rst) 
    begin
        if rst = '1' then
            up_counter <= (others=>'0');
        elsif clk'event and clk = '1' then 
            if up_counter = "000" then
                ram_init <= '1';
                mac_init <= '0';
                up_counter <= up_counter + 1;
            elsif up_counter = "001" then
                ram_init <= '0';
                mac_init <= '1';
                up_counter <= up_counter + 1;
            elsif up_counter = "111" then
                up_counter <= "000";
                ram_init <= '0';
                mac_init <= '0';
            else 
                up_counter <= up_counter + 1;
                ram_init <= '0';
                mac_init <= '0';
            end if;

            rom_address <= up_counter;
            ram_address <= up_counter;
        end if;

    end process;


end Behavioral;