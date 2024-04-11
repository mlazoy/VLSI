library ieee;
use ieee.STD_LOGIC_1164.all;

entity multiplier4_bits is
    port (
        num_A, num_B : in std_logic_vector(3 downto 0);
        pulse: in std_logic;
        result : out std_logic_vector(7 downto 0)
    );
end multiplier4_bits;

architecture multiplier of multiplier4_bits is
component full_adder is
    port (
        Ain, Ain2, Bin, Cin, clk : in std_logic;
        Sum, Cout : out std_logic
    );
end component;

signal reg1 : std_logic_vector(7 downto 0);
signal reg2 : std_logic_vector(8 downto 0);
signal reg3 : std_logic_vector(8 downto 0);
signal reg4 : std_logic_vector(9 downto 0);
signal reg5 : std_logic_vector(10 downto 0);
signal reg6 : std_logic_vector(11 downto 0);
signal reg7 : std_logic_vector(12 downto 0);
signal reg8 : std_logic_vector(13 downto 0);
signal reg9 : std_logic_vector(15 downto 0);
signal reg10 : std_logic_vector(16 downto 0);
signal f1_carry, f2_carry, f3_1_carry, f3_2_carry, f4_1_carry, f4_2_carry, f5_1_carry, f5_2_carry, f6_1_carry, f6_2_carry, f7_1_carry, f7_2_carry, f8_1_carry, f8_2_carry, f9_carry : std_logic;
signal sum2, sum3, sum4_1, sum4_2, sum5, sum6_1, sum6_2, sum7, sum8 : std_logic;

begin
--a0*b0
FA_1 : full_adder port map (
    Ain => num_A(0),
    Ain2 => num_B(0),
    Bin => '0',
    Cin => '0',
    clk => pulse,
    Sum => reg2(8),
    Cout => f1_carry
);

--a1*b0
FA_2 : full_adder port map (
    Ain => reg1(1),
    Ain2 => reg1(4),
    Bin => '0',
    Cin => f1_carry,
    clk => pulse,
    Sum => sum2,
    Cout => f2_carry
);

--a2*b0
FA_3_1 : full_adder port map (
    Ain => reg2(2),
    Ain2 => reg2(4),
    Bin => '0',
    Cin => f2_carry,
    clk => pulse,
    Sum => sum3,
    Cout => f3_1_carry
);

--a0*b1
FA_3_2 : full_adder port map (
    Ain => reg2(0),
    Ain2 => reg2(5),
    Bin => sum2,
    Cin => '0',
    clk => pulse,
    Sum => reg4(9),
    Cout => f3_2_carry
);

--a3*b0
FA_4_1 : full_adder port map (
    Ain => reg3(3),
    Ain2 => reg3(4),
    Bin => '0',
    Cin => f3_1_carry,
    clk => pulse,
    Sum => sum4_1,
    Cout => reg5(10)
);

--a1*b1
FA_4_2 : full_adder port map (
    Ain => reg3(1),
    Ain2 => reg3(5),
    Bin => sum3,
    Cin => f3_2_carry,
    clk => pulse,
    Sum => sum4_2,
    Cout => f4_2_carry
);

--a2*b1
FA_5_1: full_adder port map (
    Ain => reg4(2),
    Ain2 => reg4(5),
    Bin => sum4_1,
    Cin => f4_2_carry,
    clk => pulse,
    Sum => sum5,
    Cout => f5_1_carry
);

--a0*b2
FA_5_2 : full_adder port map (
    Ain => reg4(0),
    Ain2 => reg4(6),
    Bin => sum4_2,
    Cin => '0',
    clk => pulse,
    Sum => reg6(11),
    Cout => f5_2_carry
);

--a3*b1
FA_6_1: full_adder port map (
    Ain => reg5(3),
    Ain2 => reg5(5),
    Bin => reg5(10),
    Cin => f5_1_carry,
    clk => pulse,
    Sum => sum6_1,
    Cout => reg7(12)
);

--a1*b2
FA_6_2: full_adder port map (
    Ain => reg5(1),
    Ain2 => reg5(6),
    Bin => sum5,
    Cin => f5_2_carry,
    clk => pulse,
    Sum => sum6_2,
    Cout => f6_2_carry
);

--a2*b2
FA_7_1: full_adder port map (
    Ain => reg6(2),
    Ain2 => reg6(6),
    Bin => sum6_1,
    Cin => f6_2_carry,
    clk => pulse,
    Sum => sum7,
    Cout => f7_1_carry
);

--a0*b3
FA_7_2: full_adder port map (
    Ain => reg6(0),
    Ain2 => reg6(7),
    Bin => sum6_2,
    Cin => '0',
    clk => pulse,
    Sum => reg8(13),
    Cout => f7_2_carry
);

--a3*b2
FA_8_1: full_adder port map (
    Ain => reg7(3),
    Ain2 => reg7(6),
    Bin => reg7(12),
    Cin => f7_1_carry,
    clk => pulse,
    Sum => sum8,
    Cout => reg9(15)
);

--a1*b3
FA_8_2: full_adder port map (
    Ain => reg7(1),
    Ain2 => reg7(7),
    Bin => sum7,
    Cin => f7_2_carry,
    clk => pulse,
    Sum => reg9(14),
    Cout => f8_2_carry
);

--a2*b3
FA_9: full_adder port map (
    Ain => reg8(2),
    Ain2 => reg8(7),
    Bin => sum8,
    Cin => f8_2_carry,
    clk => pulse,
    Sum => reg10(16),
    Cout => f9_carry
);

--a3*b3
FA_10: full_adder port map (
    Ain => reg9(3),
    Ain2 => reg9(7),
    Bin => reg9(15),
    Cin => f9_carry,
    clk => pulse,
    Sum => result(6),
    Cout => result(7)
);

process(pulse) begin
    if rising_edge(pulse) then
        result(0) <= reg10(8);
        result(1) <= reg10(9);
        result(2) <= reg10(11);
        result(3) <= reg10(13);
        result(4) <= reg10(14);
        result(5) <= reg10(16);

        --update registers
        reg10(0) <= reg9(0);
        reg10(1) <= reg9(1);
        reg10(2) <= reg9(2);
        reg10(3) <= reg9(3);
        reg10(4) <= reg9(4);
        reg10(5) <= reg9(5);
        reg10(6) <= reg9(6);
        reg10(7) <= reg9(7);
        reg10(8) <= reg9(8);
        reg10(9) <= reg9(9);
        reg10(10) <= reg9(10);
        reg10(11) <= reg9(11);
        reg10(12) <= reg9(12);
        reg10(13) <= reg9(13);
        reg10(14) <= reg9(14);
        reg10(15) <= reg9(15);

        reg9(0) <= reg8(0);
        reg9(1) <= reg8(1);
        reg9(2) <= reg8(2);
        reg9(3) <= reg8(3);
        reg9(4) <= reg8(4);
        reg9(5) <= reg8(5);
        reg9(6) <= reg8(6);
        reg9(7) <= reg8(7);
        reg9(8) <= reg8(8);
        reg9(9) <= reg8(9);
        reg9(10) <= reg8(10);
        reg9(11) <= reg8(11);
        reg9(12) <= reg8(12);
        reg9(13) <= reg8(13);

        reg8(0) <= reg7(0);
        reg8(1) <= reg7(1);
        reg8(2) <= reg7(2);
        reg8(3) <= reg7(3);
        reg8(4) <= reg7(4);
        reg8(5) <= reg7(5);
        reg8(6) <= reg7(6);
        reg8(7) <= reg7(7);
        reg8(8) <= reg7(8);
        reg8(9) <= reg7(9);
        reg8(10) <= reg7(10);
        reg8(11) <= reg7(11);
        reg8(12) <= reg7(12);

        reg7(0) <= reg6(0);
        reg7(1) <= reg6(1);
        reg7(2) <= reg6(2);
        reg7(3) <= reg6(3);
        reg7(4) <= reg6(4);
        reg7(5) <= reg6(5);
        reg7(6) <= reg6(6);
        reg7(7) <= reg6(7);
        reg7(8) <= reg6(8);
        reg7(9) <= reg6(9);
        reg7(10) <= reg6(10);
        reg7(11) <= reg6(11);

        reg6(0) <= reg5(0);
        reg6(1) <= reg5(1);
        reg6(2) <= reg5(2);
        reg6(3) <= reg5(3);
        reg6(4) <= reg5(4);
        reg6(5) <= reg5(5);
        reg6(6) <= reg5(6);
        reg6(7) <= reg5(7);
        reg6(8) <= reg5(8);
        reg6(9) <= reg5(9);
        reg6(10) <= reg5(10);

        reg5(0) <= reg4(0);
        reg5(1) <= reg4(1);
        reg5(2) <= reg4(2);
        reg5(3) <= reg4(3);
        reg5(4) <= reg4(4);
        reg5(5) <= reg4(5);
        reg5(6) <= reg4(6);
        reg5(7) <= reg4(7);
        reg5(8) <= reg4(8);
        reg5(9) <= reg4(9);

        reg4(0) <= reg3(0);
        reg4(1) <= reg3(1);
        reg4(2) <= reg3(2);
        reg4(3) <= reg3(3);
        reg4(4) <= reg3(4);
        reg4(5) <= reg3(5);
        reg4(6) <= reg3(6);
        reg4(7) <= reg3(7);
        reg4(8) <= reg3(8);

        reg3 <= reg2;

        reg2(0) <= reg1(0);
        reg2(1) <= reg1(1);
        reg2(2) <= reg1(2);
        reg2(3) <= reg1(3);
        reg2(4) <= reg1(4);
        reg2(5) <= reg1(5);
        reg2(6) <= reg1(6);
        reg2(7) <= reg1(7);

        reg1 <= num_B(3) & num_B(2) & num_B(1) & num_B(0) & num_A(3) & num_A(2) & num_A(1) & num_A(0);

    end if;
end process;

end multiplier;