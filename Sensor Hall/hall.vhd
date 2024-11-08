library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity hall is 

    	generic (
					N : integer := 16);

    port(
            
            clk, rst, hall    : in std_logic;
            RPM         : out std_logic_vector(15 downto 0):= "0000000000000000");
            
end entity;

architecture rpm of hall is
    
--------------------- Sinais da Divisão --------------------------
	
    signal quociente1   : std_logic_vector(15 downto 0);
    signal terminou1    : std_logic;

------------------------------------------------------------------

------------------------------------ Sinais do Sensor Hall ------------------------------------

    signal      tempo       : std_logic_vector(15 downto 0) := "0000000000000000";
    signal      val_pos     : std_logic_vector(15 downto 0) := "0000000000000000";
    signal      count_f		: std_logic_vector (15 downto 0) := "0000000000000000" ;
    signal      clk_ms 		: std_logic := '0';
    constant    f_clk		: std_logic_vector (15 downto 0) := "1100001101001111"; -- Decimal = 49999;
    constant    rev_ms		:	std_logic_vector (15 downto 0) := "1110101001100000"; -- Decimal = 600000

-----------------------------------------------------------------------------------------------


------------ Divisor de bits-----------

	component divisor 
		port(
			clk,reset 	: in std_logic;
			start 	    : in std_logic;
			divisor 	: in std_logic_vector(N-1 downto 0);
			dividendo 	: in std_logic_vector(N-1 downto 0);
			terminou 	: out std_logic;
			quociente	: out std_logic_vector(N-1 downto 0);
			resto		: out std_logic_vector(N-1 downto 0));

	end component;

---------------------------------------


begin

    divisor_1: divisor 
			port map(
				clk => clk,
				reset => rst,
				start => '1',
				divisor  => val_pos,
				dividendo => rev_ms,
				terminou 	=> terminou1,
				quociente	=> quociente1);
				
process(clk)
begin
        if(rst ='1') then
            rpm <= "0000000000000000";
        
        elsif(rising_edge(clk)) then        
            if(terminou1 = '1') then
                rpm <= quociente1;
            end if;
        end if;
end process;

process(clk)
begin
        if(rst ='1') then
            count_f <= "0000000000000000";
            clk_ms <= '0';
        
        elsif(rising_edge(clk)) then
            count_f <= count_f + "0000000000000001";
            
            if(count_f = f_clk) then
                count_f <= "0000000000000000";
                clk_ms <= not clk_ms;
            end if;                       
        end if;
end process;

process(clk_ms)
begin   
    
        if(rst = '1') then
            tempo <= "0000000000000000";
            val_pos <= "0000000000000000";
         
        elsif(rising_edge(clk_ms) or falling_edge(clk_ms)) then
            if(hall = '0') then
                tempo <= tempo + "0000000000000001";
            
            elsif(hall = '1') then
                if (tempo > "0000000000000000") then
                    val_pos <= tempo;
                end if;
                
                tempo <= "0000000000000000";
                
            end if;
         end if;
end process;




end rpm;
