entity decoder3_tb is
end decoder3_tb;
architecture decoder3_tb_architecture of decoder3_tb is
component decoder3
port(
enc: in std_logic_vector(2 downto 0);
dec: out std_logic_vector(7 downto 0)
);
end component;
signal enc_tb: std_logic_vector(2 downto 0);
signal dec_tb: std_logic_vector(7 downto 0);
begin
uut: decoder3
port map (
enc => enc_tb,
dec => dec_tb
);
testing: process
begin
for i in 0 to 7 loop
enc_tb <= std_logic_vector(to_unsigned(i, 3));
wait for 10 ns;
--assertion to check output
assert dec_tb =
std_logic_vector(unsigned(std_logic_vector(to_unsigned(1, 8))) sll i)
report "Output mismatch for input " & integer'image(i)
severity error;
end loop;
end process testing;
end decoder3_tb_architecture;