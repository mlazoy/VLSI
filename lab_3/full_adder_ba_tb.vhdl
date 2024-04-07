library ieee;
use ieee.std_logic_1164.all;

entity full_adder_tb is
end full_adder_tb;

architecture full_adder_tb_architecture of full_adder_tb is
component full_adder
port (
    A, B, Cin, clk : in std_logic;
    Sum, Cout : out std_logic
);
end component;

signal A_tb, B_tb, Cin_tb, clk_tb, Sum_tb, Cout_tb : std_logic;

begin

uut: full_adder
port map(
    A => A_tb,
    B => B_tb,
    Cin => Cin_tb,
    clk => clk_tb,
    Sum => Sum_tb,
    Cout => Cout_tb
);

testing : process
begin
    clk_tb <= '0';
    for i in std_logic range '0' to '1' loop
        for j in std_logic range '0' to '1' loop
            for k in std_logic range '0' to '1' loop
                A_tb <= i;
                B_tb <= j;
                Cin_tb <= k;
                for l in std_logic range '0' to '1' loop
                    clk_tb <= l;
                    wait for 10ns;
                end loop;
            end loop;
        end loop;
    end loop;
    wait;
end process testing;
end full_adder_tb_architecture;