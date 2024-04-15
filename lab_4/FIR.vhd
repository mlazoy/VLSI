library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIR is
    port (valid_in, clk, rst: in std_logic;
        x: std_logic_vector(7 downto 0);
        valid_out: out std_logic
        y: out std_logic_vector(16 downto 0) -- accumulator value of last step
    );
end FIR;

architecture Structural of FIR is
begin

end Structural;