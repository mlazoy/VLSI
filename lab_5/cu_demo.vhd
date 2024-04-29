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
signal current_valid_ins, prev_valid_ins: std_logic_vector (7 downto 0);
signal rising_valid_in : std_logic;

component dff8 is
    port (
        D : in std_logic_vector(7 downto 0);
        clk, rst: in std_logic;
        Q: out std_logic_vector(7 downto 0)
    );
end component;

begin
    current_valid_ins <= prev_valid_ins(6 downto 0) & valid_in;
    valid_in_buffer : dff8
    port map (
        D => current_valid_ins,
        clk => clk,
        rst => rst,
        Q => prev_valid_ins
    );
    rising_valid_in <= (valid_in and not prev_valid_ins(0)) or (prev_valid_ins(0) and not prev_valid_ins(1)) or (prev_valid_ins(1) and not prev_valid_ins(2)) or (prev_valid_ins(2) and not prev_valid_ins(3)) or (prev_valid_ins(3) and not prev_valid_ins(4)) or (prev_valid_ins(4) and not prev_valid_ins(5)) or (prev_valid_ins(5) and not prev_valid_ins(6)) or (prev_valid_ins(6) and not prev_valid_ins(7));
    
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
            elsif rising_valid_in = '1' and up_counter=1 then 
                ram_init<='0';
                mac_init<='1';
            elsif rising_valid_in = '0' and up_counter=1 then 
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


end Behavioral;
