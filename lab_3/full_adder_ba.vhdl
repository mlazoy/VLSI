library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port (
        A, B, Cin, clk : in std_logic;
        Sum, Cout : out std_logic
    );
end full_adder;

architecture full_adder_behavioural of full_adder is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (((A xor B) xor Cin) = '1') then
                Sum <= '1';
            else 
                Sum <= '0';
            end if;
            
            if (((A and B) or (Cin and (A xor B))) = '1') then
                Cout <= '1';
            else 
                Cout <= '0';
            end if;
        end if;
    end process;
end full_adder_behavioural;
