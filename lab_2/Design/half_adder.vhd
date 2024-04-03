library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity half_adder is
    port ( a, b: in std_logic;
           sum, carry: out std_logic);
end half_adder;

architecture dataflow of half_adder is
begin
    sum <='1' when (a='1' and b='0') or (a='0' and b='1')
              else '0';
    carry <= '1' when (a='1' and b='1')
                 else '0';
end dataflow;