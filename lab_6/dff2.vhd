library ieee;
use ieee.std_logic_1164.all;

entity dff2 is 
    port (clk, rst: in std_logic;
          D: in std_logic_vector(1 downto 0);
          Q: out std_logic_vector(1 downto 0));
end dff2;

architecture Behavioral of dff2 is
begin
    process(clk, rst) 
    begin
        if rst = '1' then
            Q <= "00";
        elsif rising_edge(clk) then
            Q<=D;
        end if;
    end process;

end Behavioral;

