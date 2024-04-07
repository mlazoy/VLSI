library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity full_adder is
    port ( Ain, Bin, Cin, clk: in std_logic;
           Sum, Cout: out std_logic);
end full_adder;

architecture Behavioral of full_adder is
signal input: std_logic_vector(2 downto 0);
signal output: std_logic_vector(1 downto 0);

begin
process (clk) begin
    input(2)<=Ain;
    input(1)<=Bin;
    input(0)<=Cin;
    
    if rising_edge(clk) then
        case (input) is
            when "000" => 
                output<="00";
            when "001" =>
                output<="10";
            when "010" =>
                output<="10";
            when "011" =>
                output<="01";
            when "100" =>
                output<="10";
            when "101" =>
                output<="01";
            when "110" =>
                output<="01";
            when "111" =>
                output<="11";
            when others =>
                null;     
        end case;  
    end if;
end process;
     
Sum<=output(1);
Cout<=output(0); 

end Behavioral;