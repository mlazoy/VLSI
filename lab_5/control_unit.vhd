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
signal rising_valid_in, prev_valid_in, prev_rising_valid_in, not_used_valid_in, not_used_D, rst_dff: std_logic;

component dff is 
    port (D,clk, rst: in std_logic;
          Q: out std_logic);
end component;

begin
                            
valid_in_dff: dff port map (clk=>clk,
                          rst=>rst,
                          D=>valid_in,
                          Q=>prev_valid_in
                          );
                          
rising_edge_dff: dff port map (clk=>clk,
                               rst=>rst,
                               D=>rising_valid_in,
                               Q=>prev_rising_valid_in
                               );
                               
rst_dff<= rst or (up_counter(0) and not up_counter(1) and not up_counter(2));                         
not_used_D<=(valid_in or not_used_valid_in);                             
not_used_dff: dff port map(clk=>clk,
                           rst=>rst_dff,
                           D=>not_used_D,
                           Q=>not_used_valid_in
                           );
                                                
    process(clk, rst) 
    begin
        if rst = '1' then
            up_counter <= (others=>'0');
            freeze<='1';      
        elsif clk'event and clk='1' then
            if rising_valid_in = '1' and up_counter=0 then 
                ram_init<='1';
                mac_init<='0';
                freeze<='1';
            elsif rising_valid_in = '0' and up_counter=0 then
                ram_init<='0';
                mac_init<='0';
            elsif prev_rising_valid_in = '1' and up_counter=1 then 
                ram_init<='0';
                mac_init<='1';
            elsif prev_rising_valid_in = '0' and up_counter=1 then 
                ram_init<='0';
                mac_init<='1';
                freeze <= '0';
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
    
    process(clk,rst)
    begin
    if clk'event and clk='1' then 
        if ((valid_in='1' and prev_valid_in='0') or not_used_valid_in='1') then
            rising_valid_in<='1';
        else 
            rising_valid_in<='0';
        end if;
    end if;
    
    end process;



end Behavioral;
