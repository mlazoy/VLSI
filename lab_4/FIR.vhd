library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIR is
    generic (N: integer:= 8);
    port (valid_in, clk, rst: in std_logic;
          x: std_logic_vector(N-1 downto 0);
          valid_out: out std_logic;
          y: out std_logic_vector(2*N downto 0)); -- accumulator value of last step
end FIR;

architecture Structural of FIR is
component MAC is 
    port (rom_out, ram_out: in std_logic_vector(7 downto 0);
          clk, init: in std_logic;
          accumulator: out std_logic_vector(16 downto 0));    
end component;

component Control_unit is
    port (clk, rst: in std_logic;
          rom_address, ram_address: out std_logic_vector(2 downto 0);
          mac_init: out std_logic);
end component;

component mlab_rom is 
    generic (coeff_width : integer :=8);
    Port ( clk : in  std_logic;
       en : in  std_logic;             
       addr : in  std_logic_vector (2 downto 0);            
       rom_out : out  std_logic_vector (coeff_width-1 downto 0));  
end component;

component mlab_ram is
	 generic (
		data_width : integer :=8  				
	 );
    port (clk  : in std_logic;
          we   : in std_logic;						
		  en   : in std_logic;				
          addr : in std_logic_vector(2 downto 0);			
          di   : in std_logic_vector(data_width-1 downto 0);		
          do   : out std_logic_vector(data_width-1 downto 0));		
end component;

signal cu_to_mac: std_logic;
signal to_rom, to_ram: std_logic_vector(2 downto 0);
signal from_rom, from_ram: std_logic_vector(7 downto 0);

begin
CU: Control_unit port map (clk=>clk,
                           rst=>rst,
                           rom_address=>to_rom,
                           ram_address=>to_ram,
                           mac_init=>cu_to_mac 
                           );
                           
ROM: mlab_rom   generic map (coeff_width => 8)
                port map (clk=>clk,
                          en=> '1',
                          addr=>to_rom,
                          rom_out=>from_rom
                          );
RAM : mlab_ram port map (clk=>clk,
                         we => valid_in,
                         en=> '1',
                         addr=>to_ram,
                         di=>x,
                         do=>from_ram
                         );                          
                                                   
M: MAC port map (clk=>clk,
                 rom_out=>from_rom,
                 ram_out=>from_ram,
                 init=>cu_to_mac,
                 accumulator=>y
                 );

end Structural;