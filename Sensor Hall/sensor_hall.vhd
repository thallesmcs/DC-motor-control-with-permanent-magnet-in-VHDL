library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity sensor_hall_1 is
  port (
    	clk       	:  	in  std_logic;
    	val_hall  	:  	in  std_logic;
	clk_50 		: 	out std_logic;
    	rpm       	:  	out std_logic_vector(7 downto 0));
	
end sensor_hall_1;

architecture rpm of sensor_hall_1 is

    	signal cont      	:  	std_logic_vector(7 downto 0) := "00000000";
    	signal val_pos   	:  	std_logic_vector(7 downto 0);
	signal count_f		:  	std_logic_vector (15 downto 0); --integer range 0 to 49999;
	signal clk_ms 		: 	std_logic := '0';
	constant f_clk		:	std_logic_vector (15 downto 0) := "1100001101001111"; --integer := 49999;

begin

clk_50<= clk_ms;

process(clk)
begin
	
	if (rising_edge(clk)) then
		count_f <= count_f + "0000000000000001";
	
		if (count_f = f_clk) then
			count_f <= "0000000000000000";
			clk_ms <= not clk_ms;
		
		elsif (val_hall = '0') then
		  	cont <= cont + "00000001";
		
		elsif (val_hall = '1') then 
			if (cont > "00000000") then
		    		val_pos <= cont;
			end if; 
		  	cont <= "00000000";
		end if;
	end if;
end process;

rpm <= f_clk / val_pos; --Arrumar com modulo de binary divider

end rpm;
