library ieee;
use ieee.std_logic_1164.all;

entity dff8 is 
    port (
        D : in std_logic_vector(7 downto 0);
        clk, rst: in std_logic;
        Q: out std_logic_vector(7 downto 0)
    );
end dff8;

architecture Behavioral of dff8 is
begin
    process(clk, rst) 
    begin
        if rst = '1' then
            Q <= (others => '0');
        elsif rising_edge(clk) then
            Q<=D;
        end if;
    end process;

end Behavioral;
