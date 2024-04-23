library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Control_unit is 
    generic (N: integer:=8);
    port (clk, rst, valid_in: in std_logic;
          rom_address, ram_address: out std_logic_vector(2 downto 0);
          mac_init, ram_init, freeze: out std_logic);
end Control_unit;

architecture Behavioral of Control_unit is
signal up_counter: std_logic_vector(2 downto 0):= (others=>'0');
signal wait_to_write: std_logic;

begin
    process(clk, rst) 
    begin
        if rst = '1' then
            up_counter <= (others=>'0');
            freeze<='1';
        elsif clk'event and clk='1' then
            if valid_in='1' and up_counter=0 then 
                ram_init<='1';
                mac_init<='0';
                freeze<='1';
            elsif valid_in='0' and up_counter=0 then
                ram_init<='0';
                mac_init<='0';
                freeze<='0';
            elsif up_counter=1 then 
                ram_init<='0';
                mac_init<='1';
            else 
                ram_init<='0';
                mac_init<='0';
            end if;
            
            if up_counter/=N-1 then 
                up_counter<=up_counter+1;
            else
                up_counter<=(others=>'0');
            end if; 
          
            rom_address <= up_counter;
            ram_address <= up_counter;
            
        end if;

    end process;


end Behavioral;
