library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity sensor_hall is

	generic (
					R : integer := 16;
					N : integer := 16);

  port (
    	clk, rst       	:  	in  std_logic;
    	val_hall  	:  	in  std_logic;
		clk_50 		: 	out std_logic;
    	rpm       	:  	out std_logic_vector(R-1 downto 0));
	
end sensor_hall;

architecture rpm of sensor_hall is

    	signal tempo      	:  	std_logic_vector(R-1 downto 0) := "0000000000000000";
    	signal val_pos   	:  	std_logic_vector(R-1 downto 0);
		signal count_f		:  	std_logic_vector (R-1 downto 0) := "0000000000000000" ; --integer range 0 to 49999;
	signal clk_ms 		: 	std_logic := '0';
	constant f_clk		:	std_logic_vector (R-1 downto 0) := "1100001101001111"; -- Decimal = 49999;
	constant rev_ms		:	std_logic_vector (R-1 downto 0) := "1110101001100000"; -- Decimal = 600000
    signal start 		: std_logic := '0';
	signal terminou 	: std_logic;
	signal resto		: std_logic_vector(N-1 downto 0);
	signal quociente : std_logic_vector(N-1 downto 0);


------------ Divisor de bits-----------

	component divisor 
		port(
			clk,reset 	: in std_logic;
			start 			: in std_logic;
			divisor 		: in std_logic_vector(N-1 downto 0);
			dividendo 	: in std_logic_vector(N-1 downto 0);
			terminou 	: out std_logic;
			quociente	: out std_logic_vector(N-1 downto 0);
			resto		: out std_logic_vector(N-1 downto 0));

	end component;

---------------------------------------

begin

clk_50<= clk_ms;

process(clk)
begin
	
	if(rst ='1') then
		count_f <= "0000000000000000";
		clk_ms <= '0';
	
	elsif (rising_edge(clk)) then
		count_f <= count_f + "0000000000000001";
	
		if (count_f = f_clk) then
			count_f <= "0000000000000000";
			clk_ms <= not clk_ms;
	   end if;
	end if;

end process;

process(clk_ms)
begin

	if(rst ='1') then
		tempo <= "0000000000000000";
		val_pos <= "0000000000000000";
		rpm <= "0000000000000000";
	
    elsif (rising_edge(clk_ms) or falling_edge(clk_ms)) then 
        if (val_hall = '0') then
            tempo <= tempo + "0000000000000001";
            start <= '0';
        elsif (val_hall = '1') then 
            if (tempo > "0000000000000000") then
                val_pos <= tempo;
                start <= '1';
            end if; 
            tempo <= "0000000000000000";
        end if;
    end if;
end process;

------------ Desenvolvimento do RPM -----------------------

--  RPM = 60000 / tempo em milisegundos   
	    
	     -- O valor de 60.000 mencionado refere-se à rotação ou ao número de rotações em RPM. 
             -- Neste caso, foi feita uma conversão onde 60 dividido pelo tempo em segundos corresponde ao RPS (rotações por segundo). 
             -- Para encontrar o valor em RPM, foi convertida a fórmula para 60.000 dividido pelo tempo em milissegundos, 
             -- garantindo assim a conversão direta da rotação do motor em RPM utilizando o clock de 50 kHz, 
             -- o que equivale a 1 ms. Vale destacar que utilizar 1 segundo como unidade de tempo poderia levar 
             -- a uma rotação muito demorada; por isso, optou-se por usar milissegundos. 
                                              
                                              

--  RPM = 1110101001100000 / val_pos         
	     
	     -- Lembrando que o valor do "val_pos" é o valor em binario do tempo levado em milissegundos de uma revolução,
             -- o valor da posição referente ao Hall em relação com o tempo desta posição inicial ate a final.

-----------------------------------------------------------


	divisor_1: divisor 
			port map(
				clk => clk,
				reset => rst,
				start => start,
				divisor  => val_pos,
				dividendo => rev_ms,
				terminou 	=> terminou,
				quociente	=> quociente,
				resto => resto);

--rpm <= quociente -- Ajustar para o RPM receber a saida do quociente.
		

end rpm;
