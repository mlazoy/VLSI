library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

package custom_types_pkg is
    -- Define the custom type
    type grid3x3 is array (0 to 8) of std_logic_vector(7 downto 0);
end package custom_types_pkg;

-- Use the package in your entity
library ieee;
use ieee.std_logic_1164.all;
use work.custom_types_pkg.all; -- Use your package here

entity average_unit is
    port (
        clk, rst_n, en: in std_logic;
        pixel_case: in std_logic_vector(1 downto 0); 
        pixel_grid : in grid3x3;
        R_avg, G_avg, B_avg: out std_logic_vector(7 downto 0));
end average_unit;

architecture Behavioral of average_unit is

--X at index 4
--combo1 => R = indexes 1+7,  G = X, B = indexes 3+5
--combo2 => R = indexes 3+5,  G = X, B = indexes 1+7
--combo3 => R = X, G = indexes 1+3+5+7, B = indexes 0+2+6+8
--combo4 => R = indexes 0+2+6+8, G = indexes 1+3+5+7, B = X 

component pixel_adder is
    port(clk,rst_n: in std_logic;
         pixel_1, pixel_2, pixel_3, pixel_4: in std_logic_vector(7 downto 0);
         sum: out std_logic_vector(9 downto 0));
end component;

signal pxl_11, pxl_12, pxl_13, pxl_14, pxl_21, pxl_22, pxl_23, pxl_24: std_logic_vector(7 downto 0);
signal tmp_sum_1, tmp_sum_2: std_logic_vector(9 downto 0);

begin

PXL_ADD1: pixel_adder port map (clk=>clk,
                                rst_n=>rst_n,
                                pixel_1=>pxl_11,
                                pixel_2=>pxl_12,
                                pixel_3=>pxl_13,
                                pixel_4=>pxl_14,
                                sum=>tmp_sum_1
                                );
                                
PXL_ADD2: pixel_adder port map (clk=>clk,
                                rst_n=>rst_n,
                                pixel_1=>pxl_21,
                                pixel_2=>pxl_22,
                                pixel_3=>pxl_23,
                                pixel_4=>pxl_24,
                                sum=>tmp_sum_2
                                );                               
process(clk,rst_n)
begin
    if rst_n='0' then 
        R_avg <= (others => '0');
        B_avg <= (others => '0');
        G_avg <= (others => '0');
        
    elsif clk'event and clk='1' and en='1' then 
    
        case pixel_case is
        when "00" => --case i
        pxl_11<=pixel_grid(1);
        pxl_12<=pixel_grid(7);
        pxl_13<=(others=>'0');
        pxl_14<=(others=>'0');
        --
        pxl_21<=pixel_grid(3);
        pxl_22<=pixel_grid(5);
        pxl_23<=(others=>'0');
        pxl_24<=(others=>'0');  

        -- /2 is 1 right shift
        R_avg<=tmp_sum_1(8 downto 1);
        G_avg<=pixel_grid(4);
        B_avg<=tmp_sum_2(8 downto 1);
        
        when "01" => --case ii
        pxl_11<=pixel_grid(3);
        pxl_12<=pixel_grid(5);
        pxl_13<=(others=>'0');
        pxl_14<=(others=>'0');
        --
        pxl_21<=pixel_grid(1);
        pxl_22<=pixel_grid(7);
        pxl_23<=(others=>'0');
        pxl_24<=(others=>'0');

        R_avg<=tmp_sum_1(8 downto 1);
        G_avg<=pixel_grid(4);
        B_avg<=tmp_sum_2(8 downto 1);

        when "10" => --case iii
        pxl_11<=pixel_grid(1);
        pxl_12<=pixel_grid(3);
        pxl_13<=pixel_grid(5);
        pxl_14<=pixel_grid(7);
        --
        pxl_21<=pixel_grid(0);
        pxl_22<=pixel_grid(2);
        pxl_23<=pixel_grid(6);
        pxl_24<=pixel_grid(8);

        -- /4 is 2 right shifts
        R_avg<=pixel_grid(4);
        G_avg<=tmp_sum_1(9 downto 2);
        B_avg<=tmp_sum_2(9 downto 2);
        
        when "11" => --case iv
        pxl_11<=pixel_grid(0);
        pxl_12<=pixel_grid(2);
        pxl_13<=pixel_grid(6);
        pxl_14<=pixel_grid(8);
        --
        pxl_21<=pixel_grid(1);
        pxl_22<=pixel_grid(3);
        pxl_23<=pixel_grid(5);
        pxl_24<=pixel_grid(7);

        R_avg<=tmp_sum_1(9 downto 2);
        G_avg<=tmp_sum_2(9 downto 2);
        B_avg<=pixel_grid(4);
        
        when others =>
        null;   
        end case;  
    end if;
end process;


end Behavioral;
