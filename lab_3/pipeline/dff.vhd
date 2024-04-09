library ieee;
use ieee.std_logic_1164.all;

entity dff is 
    port (D,clk: in std_logic;
          Q: out std_logic);
end dff;

architecture Behavioral of dff is
begin
    process(clk) begin
        if rising_edge(clk) then
            Q<=D;
        end if;
    end process;

end Behavioral;
