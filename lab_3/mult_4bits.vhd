library ieee;
use ieee.std_logic_1164.all;

entity mult_4bits is
    port (num_A, num_B: in std_logic_vector(3 downto 0);
            Ci, pulse: std_logic;
            Co, prod: out std_logic_vector(7 downto 0));
end mult_4bits;

architecture Systolic of mult_4bits is

component full_adder is
    port (A,B,Cin,clk: in std_logic;
          Cout, Sum: out std_logic);
end component;

signal a3b0, a2b0, a1b0, a0b0,
        a3b1, a2b1, a1b1, a0b1,
        a3b2, a2b2, a1b2, a0b2,
        a3b3, a2b3, a1b3, a0b3 : std_logic;


signal buffer_A0, buffer_A1, buffer_A2, buffer_A3,
        buffer_B0, buffer_B1, buffer_B2, buffer_B3: std_logic_vector(9 downto 0);

signal tmp_prod_0: std_logic_vector(9 downto 0);
signal tmp_prod_1: std_logic_vector(6 downto 0);
signal tmp_prod_2: std_logic_vector(4 downto 0);
signal tmp_prod_3: std_logic_vector(2 downto 0);
signal tmp_prod_4: std_logic_vector(1 downto 0);
signal tmp_prod_5: std_logic;

signal p_sum_1, p_sum_5: std_logic;
signal p_sum_2, p_sum_4: std_logic_vector(1 downto 0);
signal p_sum_3: std_logic_vector(2 downto 0);

signal carry_row_0, carry_row_1, carry_row_2, carry_row_3: std_logic_vector(3 downto 0);

begin
--A0*B0
a0b0 <= num_A(0) and num_B(0);
FA_00: full_adder port map (
    A=>a0b0,
    B=>'0', 
    Cin=>'0',
    clk=>pulse,
    Sum=>tmp_prod_0(0),
    Cout=>carry_row_0(0)
);

--A1*B0
a1b0 <= buffer_A1(0) and buffer_B0(0);
FA_10: full_adder port map (
    A=>a1b0,
    B=>'0',
    Cin=>carry_row_0(0),
    clk=>pulse,
    Sum=>p_sum_1,
    Cout=>carry_row_0(1)
);

--A2*B0
a2b0 <= buffer_A2(1) and buffer_B0(1)
FA_20: full_adder port map (
    A=>a2b0,
    B=>'0',
    Cin=>carry_row_0(1),
    clk=>pulse,
    Sum=>p_sum_2(0),
    Cout=>carry_row_0(2)
);

--A3*B0
a2b0 <= buffer_A3(2) and buffer_B0(2)
FA_30: full_adder port map (
    A=>a3b0,
    B=>'0',
    Cin=>carry_row_0(2),
    clk=>pulse,
    Sum=>p_sum_3(0),
    Cout=>carry_row_0(3)
);

--A0*B1
a0b1 <= buffer_A0(1) and buffer_B1(1);
FA_01: full_adder port map (
    A=>a0b1,
    B=>p_sum_1,
    Cin=>'0',
    clk=>pulse,
    Sum=>tmp_prod_1(0),
    Cout=>carry_row_1(0)
);

--A1*B1
a1b1 <= buffer_A1(2) and buffer_B1(2);
FA_11: full_adder port map (
    A=>a1b1,
    B=>p_sum_2(0),
    Cin=>carry_row_1(0),
    clk=>pulse,
    Sum=>p_sum_2(1),
    Cout=>carry_row_1(1)
);

--A2*B1
a2b1 <= buffer_A2(3) and buffer_B1(3);
FA_21: full_adder port map (
    A=>a2b1,
    B=>p_sum_3(0),
    Cin=>carry_row_1(1),
    clk=>pulse,
    Sum=>p_sum_3(1),
    Cout=>carry_row_1(2)
);

--A3*B1
a3b1 <= buffer_A3(4) and buffer_B1(4);
FA_31: full_adder port map (
    A=>a3b1,
    B=>carry_row_0(3),
    Cin=>carry_row_1(2),
    clk=>pulse,
    Sum=>p_sum_4(0),
    Cout=>carry_row_1(3)
);

--A0*B2
a0b2 <= buffer_A0(2) and buffer_B2(2)
FA_02: full_adder port map (
    A=>a0b2,
    B=>p_sum_2(1), 
    Cin=>'0',
    clk=>pulse,
    Sum=>tmp_prod_2(0),
    Cout=>carry_row_2(0)
);

--A1*B2
a1b2 <= buffer_A1(3) and buffer_B2(3)
FA_12: full_adder port map (
    A=>a1b2,
    B=>p_sum_3(1),
    Cin=>carry_row_2(0),
    clk=>pulse,
    Sum=>p_sum_3(2),
    Cout=>carry_row_2(1)
);

--A2*B2
a2b2 <= buffer_A2(4) and buffer_B2(4)
FA_30: full_adder port map (
    A=>a2b2,
    B=>p_sum_4(0),
    Cin=>carry_row_2(1),
    clk=>pulse,
    Sum=>p_sum_4(1),
    Cout=>carry_row_2(2)
);

--A3*B2
a3b2 <= buffer_A3(5) and buffer_B2(5)
FA_32: full_adder port map (
    A=>a3b2,
    B=>carry_row_1(3),
    Cin=>carry_row_2(2),
    clk=>pulse,
    Sum=>p_sum_5,
    Cout=>carry_row_2(3)
);

--A0*B3
a0b3 <= buffer_A0(4) and buffer_B3(4)
FA_03: full_adder port map (
    A=>a0b3,
    B=>p_sum_3(2),
    Cin=>'0',
    clk=>pulse,
    Sum=>tmp_prod_3(0),
    Cout=>carry_row_3(0)
);

--A1*B3
a1b3 <= buffer_A1(5) and buffer_B3(5)
FA_13: full_adder port map (
    A=>a1b3,
    B=>p_sum_4(1),
    Cin=>carry_row_3(0),
    clk=>pulse,
    Sum=>tmp_prod_4(0),
    Cout=>carry_row_3(1)
);

--A2*B3
a2b3 <= buffer_A2(6) and buffer_B3(6)
FA_23: full_adder port map (
    A=>a2b3,
    B=>p_sum_5,
    Cin=>carry_row_3(1),
    clk=>pulse,
    Sum=>tmp_prod_5(0),
    Cout=>carry_row_3(2)
);

--A3*B3
a3b3 <= buffer_A3(7) and buffer_B3(7)
FA_33: full_adder port map (
    A=>a3b3,
    B=>carry_row_2(3),
    Cin=>carry_row_3(2),
    clk=>pulse,
    Sum=>prod(6),
    Cout=>prod(7)
);

if rising_edge(pulse) then

    --result
    prod(5 downto 0)<=tmp_prod_0(9) & tmp_prod_1(6) & tmp_prod_2(4) & tmp_prod_3(2) & tmp_prod_4(1);

    --shift all buffers and tmp_prod signals right
    buffer_A0(9 downto 1)<=buffer_A0(8 downto 0);
    buffer_A1(9 downto 1)<=buffer_A1(8 downto 0);
    buffer_A2(9 downto 1)<=buffer_A2(8 downto 0);
    buffer_A3(9 downto 1)<=buffer_A3(8 downto 0);

    buffer_B0(9 downto 1)<=buffer_B0(8 downto 0);
    buffer_B1(9 downto 1)<=buffer_B1(8 downto 0);
    buffer_B2(9 downto 1)<=buffer_B2(8 downto 0);
    buffer_B3(9 downto 1)<=buffer_B3(8 downto 0);

    tmp_prod_0(9 downto 1)<=tmp_prod(8 downto 0);
    tmp_prod_1(6 downto 1)<=tmp_prod(5 downto 0);
    tmp_prod_2(4 downto 1)<=tmp_prod(3 downto 0);
    tmp_prod_3(2 downto 1)<=tmp_prod(1 downto 0);
    tmp_prod_4(1)<=tmp_prod(0);


end if;

end Systolic;