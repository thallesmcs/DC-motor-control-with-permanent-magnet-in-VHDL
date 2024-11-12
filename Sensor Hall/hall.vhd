library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity hall is 

    	generic (
					N : integer := 16);

    port(
            
            clk, rst, hall    : in std_logic;
            clk_250 : out std_logic;
            RPM         : out std_logic_vector(15 downto 0):= "0000000000000000");
            
            
end entity;

architecture rpm of hall is
    
---------------------Funcionamento para rpm receber quociente--------------------------

    signal val_div      : std_logic_vector(15 downto 0) := "0000000000001100";
    signal val_dendo    : std_logic_vector(15 downto 0) := "1110101001100000";
    signal quociente1   : std_logic_vector(15 downto 0);
    signal terminou1    : std_logic;
    
---------------------------------------------------------------------------------------

-------------------------Logica para medição da Velocidade-------------------------

    signal      tempo       : std_logic_vector(15 downto 0) := "0000000000000000";
    signal      val_pos     : std_logic_vector(15 downto 0) := "0000000000000000";
    signal      count_f		: std_logic_vector (15 downto 0) := "0000000000000000" ;
    signal      clk_ms 		: std_logic := '0';
    constant    f_clk		: std_logic_vector (15 downto 0) := "1100001101001111"; -- Decimal = 49999;
    constant    rev_ms		:	std_logic_vector (15 downto 0) := "1110101001100000"; -- Decimal = 600000
    
-----------------------------------------------------------------------------------
    
-----------------------Funcionamento do 7 seguimentos-----------------------------

    signal rpm_bin : std_logic_vector(15 downto 0);
    signal D_1 : std_logic_vector(6 downto 0);
    signal D_2 : std_logic_vector(6 downto 0);
    signal D_3 : std_logic_vector(6 downto 0);
    signal D_4 : std_logic_vector(6 downto 0);
    signal seg_7 : std_logic_vector(15 downto 0);
    signal count_2 : integer range 0 to 50_000_000;
    signal clk_2 : std_logic := '0';
    constant total_2 : std_logic_vector (17 downto 0) := "110000110101000000";
    
----------------------------------------------------------------------------------



---------------------------Componentes para o Hall---------------------------

------------------------Divisor de bits-----------------------
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
---------------------------------------------------------------

------------Conversor Binario para BCD------------
	component bin_bcd 
		port(
			bin 	: in STD_LOGIC_VECTOR (15 downto 0);
			bcd 	: out STD_LOGIC_VECTOR (15 downto 0));

	end component;
--------------------------------------------------


------------- Contador Usando Procedure---------------
      procedure contando(signal counter : inout std_logic_vector (15 downto 0)) is
      begin
            counter <= counter + 1;
      end procedure;
------------------------------------------------------

-----------------------------------------------------------------------------

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
				
    BCD: bin_bcd
            port map(
                bin => rpm_bin,
                bcd => seg_7);
				
process(clk)
begin
        if(rst ='1') then
            rpm <= "0000000000000000";
        
        elsif(rising_edge(clk)) then        
            if(terminou1 = '1') then
                rpm <= quociente1;
                rpm_bin <= quociente1;
            end if;
        end if;
end process;

process(clk)
begin
        if(rst ='1') then
            count_f <= "0000000000000000";
            clk_ms <= '0';
        
        elsif(rising_edge(clk)) then
            --count_f <= count_f + "0000000000000001";
            contando(count_f);
            
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
                --tempo <= tempo + "0000000000000001";
                contando(tempo);
            
            elsif(hall = '1') then
                if (tempo > "0000000000000000") then
                    val_pos <= tempo;
                end if;
                
                tempo <= "0000000000000000";
                
            end if;
         end if;
end process;

    clk_250 <= clk_2;
    
	process(clk) 
	
	begin
		
		if (rising_edge(clk))then
		      
		    count_2 <= count_2 + 1;
			
			if( count_2 = total_2)then
				count_2 <= 0;
				clk_2 <= not clk_2;
			end if;
		
		end if;	
	end process;    

    process(clk_2)
    begin
        if(rising_edge(clk_2)) then
            
           case (seg_7(3 downto 0)) is
        
                when "0000" => D_1 <= "1111110"; -- 0
                when "0001" => D_1 <= "0110000"; -- 1
                when "0010" => D_1 <= "1101101"; -- 2
                when "0011" => D_1 <= "1111001"; -- 3
                when "0100" => D_1 <= "0110011"; -- 4
                when "0101" => D_1 <= "1011011"; -- 5
                when "0110" => D_1 <= "0011111"; -- 6
                when "0111" => D_1 <= "1110000"; -- 7
                when "1000" => D_1 <= "1111111"; -- 8
                when "1001" => D_1 <= "1110011"; -- 9      
            
                when others => D_1 <= "0000000"; -- Tudo desligado
               
           end case ;

           case (seg_7(7 downto 4)) is
        
                when "0000" => D_2 <= "1111110"; -- 0
                when "0001" => D_2 <= "0110000"; -- 1
                when "0010" => D_2 <= "1101101"; -- 2
                when "0011" => D_2 <= "1111001"; -- 3
                when "0100" => D_2 <= "0110011"; -- 4
                when "0101" => D_2 <= "1011011"; -- 5
                when "0110" => D_2 <= "0011111"; -- 6
                when "0111" => D_2 <= "1110000"; -- 7
                when "1000" => D_2 <= "1111111"; -- 8
                when "1001" => D_2 <= "1110011"; -- 9      
            
                when others => D_2 <= "0000000"; -- Tudo desligado
               
           end case ;

           case (seg_7(11 downto 8)) is
        
                when "0000" => D_3 <= "1111110"; -- 0
                when "0001" => D_3 <= "0110000"; -- 1
                when "0010" => D_3 <= "1101101"; -- 2
                when "0011" => D_3 <= "1111001"; -- 3
                when "0100" => D_3 <= "0110011"; -- 4
                when "0101" => D_3 <= "1011011"; -- 5
                when "0110" => D_3 <= "0011111"; -- 6
                when "0111" => D_3 <= "1110000"; -- 7
                when "1000" => D_3 <= "1111111"; -- 8
                when "1001" => D_3 <= "1110011"; -- 9      
            
                when others => D_3 <= "0000000"; -- Tudo desligado
               
           end case ;
            
            case (seg_7(15 downto 12)) is
        
                when "0000" => D_4 <= "1111110"; -- 0
                when "0001" => D_4 <= "0110000"; -- 1
                when "0010" => D_4 <= "1101101"; -- 2
                when "0011" => D_4 <= "1111001"; -- 3
                when "0100" => D_4 <= "0110011"; -- 4
                when "0101" => D_4 <= "1011011"; -- 5
                when "0110" => D_4 <= "0011111"; -- 6
                when "0111" => D_4 <= "1110000"; -- 7
                when "1000" => D_4 <= "1111111"; -- 8
                when "1001" => D_4 <= "1110011"; -- 9      
            
                when others => D_4 <= "0000000"; -- Tudo desligado
               
           end case ;
        end if;
    end process;



end rpm;
