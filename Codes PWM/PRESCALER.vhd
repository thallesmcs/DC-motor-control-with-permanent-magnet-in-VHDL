library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity PRESCALER is
	port ( s_CLK     	: 	in  std_logic;
			 s_RST     	: 	in  std_logic;
			 s_SEL_PR  	: 	in  std_logic_vector (2 downto 0);
			 OUT_CLK   	: 	out std_logic);
end PRESCALER;

architecture RTL of PRESCALER is
	
	signal CLK4  		: std_logic := '0';
 	signal CLK16 		: std_logic := '0'; 	
 	signal CLK32 		: std_logic := '0';

	begin
	
		process(s_CLK,s_RST)
		variable CONT4  : integer range 0 to 2;
		variable CONT16 : integer range 0 to 8;
		variable CONT32 : integer range 0 to 16;
		begin
			if( s_RST = '1' ) then
				CLK4 	<= '0';
				CLK16   <= '0';
				CONT4   :=  0;
				CONT16  :=  0;
				CONT32  :=  0;
				
			elsif( s_CLK = '1' and s_CLK'EVENT ) then

				CONT4  := CONT4  + 1;
				CONT16 := CONT16 + 1;
				CONT32 := CONT32 + 1;
				
				if( CONT4 = 2 ) then
							CLK4 <= not CLK4;
							CONT4 := 0;
				end if;
				if( CONT16 = 8 ) then
							CLK16 <= not CLK16;
							CONT16  := 0;
				end if;
				if( CONT32 = 16 ) then
							CLK32 <= not CLK32;
							CONT32  := 0;
				end if;
				
			end if;
			
			case s_SEL_PR is 
			
					when "111" => OUT_CLK <= CLK32;                    -- CLK 32	
					when "100" => OUT_CLK <= CLK16;                    -- CLK 16
					when "010" => OUT_CLK <= CLK4;                     -- CLK4
					when "001" => OUT_CLK <= s_CLK and (not s_RST);    -- CLK
					when others => OUT_CLK <= '0';
					
			end case;
			
		end process;
				  
end RTL;