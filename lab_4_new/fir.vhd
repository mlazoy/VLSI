library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FIR is
    generic (N: integer:= 8);
    port (valid_in, clk, rst: in std_logic;
          x: std_logic_vector(N-1 downto 0);
          valid_out: out std_logic;
          y: out std_logic_vector(3*N-1 downto 0)); -- accumulator value of last step
end FIR;

architecture Structural of FIR is
component MAC is 
    port (rom_out, ram_out: in std_logic_vector(N-1 downto 0);
          clk, init, rst, en: in std_logic;
          accumulator: out std_logic_vector(3*N-1 downto 0));    
end component;

component Control_unit is
    port (clk, rst, valid_in: in std_logic;
          rom_address, ram_address: out std_logic_vector(2 downto 0);
          mac_init, ram_init, freeze: out std_logic);
end component;

component mlab_rom is 
    Port ( clk : in  std_logic;
       en : in  std_logic;             
       addr : in  std_logic_vector (2 downto 0);            
       rom_out : out  std_logic_vector (N-1 downto 0));  
end component;

component mlab_ram is
    port (clk, rst  : in std_logic;
          we   : in std_logic;						
		  en   : in std_logic;				
          addr : in std_logic_vector(2 downto 0);			
          di   : in std_logic_vector(N-1  downto 0);		
          do   : out std_logic_vector(N-1 downto 0));		
end component;

signal cu_to_mac, cu_to_ram, global_en: std_logic;
signal to_rom, to_ram: std_logic_vector(2 downto 0);
signal from_rom, from_ram: std_logic_vector(7 downto 0);

begin 


CU: Control_unit port map (clk=>clk,
                           rst=>rst,
                           valid_in=>valid_in,
                           rom_address=>to_rom,
                           ram_address=>to_ram,
                           mac_init=>cu_to_mac,
                           ram_init=>cu_to_ram,
                           freeze=>global_en
                           );   
                           
ROM: mlab_rom  port map (clk=>clk,
                          en=> global_en,
                          addr=>to_rom,
                          rom_out=>from_rom
                          );
                          
RAM : mlab_ram port map (clk=>clk,
                         rst => rst,
                         we => cu_to_ram,
                         en=>global_en,
                         addr=>to_ram,
                         di=>x,
                         do=>from_ram
                         );                          
                                                   
M: MAC port map (clk=>clk,
                 rst => rst,
                 en=>global_en,
                 rom_out=>from_rom,
                 ram_out=>from_ram,
                 init=>cu_to_mac,
                 accumulator=>y
                 );
                 
valid_out <= cu_to_mac;                 

end Structural;
