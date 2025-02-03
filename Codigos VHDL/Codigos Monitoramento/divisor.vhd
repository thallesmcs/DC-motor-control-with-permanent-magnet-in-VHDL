library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity divisor is 
	generic(
		N : integer := 26
);

	port(
			clk,reset 	: in std_logic;
			start 			: in std_logic;
			divisor 		: in std_logic_vector(N-1 downto 0);
			dividendo 	: in std_logic_vector(N-1 downto 0);
			terminou 	: out std_logic;
			quociente	: out std_logic_vector(N-1 downto 0);
			resto		: out std_logic_vector(N-1 downto 0));
end divisor;

architecture dividindo of divisor is

	type state_type is (idle, count, least, done);
	signal state_reg, state_next : state_type;
	signal count_reg, count_next : integer;
	signal r1_next, r1_reg : std_logic_vector(N-1 downto 0);
	signal rh_next, rh_reg : std_logic_vector(N-1 downto 0);
	signal rh_aux : std_logic_vector(N-1 downto 0);
    signal q_bit : std_logic;

begin

	process(clk, reset)
		begin
			if (reset = '1') then
				state_reg <= idle;
				rh_reg <= (others => '0');
				r1_reg <= (others => '0');
				count_reg <= 0;
			
			elsif (rising_edge(clk)) then
				state_reg <= state_next;
				rh_reg <= rh_next;
				r1_reg <= r1_next;
				count_reg <= count_next;
			end if;
	end process;

	--Compara e subtrai
	
	process(rh_reg)
		begin
			if(rh_reg >= divisor) then
				rh_aux <= rh_reg - divisor;
				q_bit <= '1';
			
			else
				rh_aux <= rh_reg;
				q_bit <= '0';
			end if;
	end process;

	process(state_reg, rh_reg, rh_aux, r1_reg, count_reg, start, q_bit, dividendo)
		begin
			--Mantem o estado atual caso não haja mudanças
			state_next <= state_reg;
			rh_next <= rh_reg;
			r1_next <= r1_reg;
			count_next <= count_reg;
			terminou <= '0';
		
			case state_reg is
				when idle =>
					if(start = '1') then	--Inicializa os valores
						state_next <= count;
						rh_next <= (others => '0');	--Expansão do dividendo
						r1_next <= dividendo; --Dividendo
						count_next <= N;
					end if;
				
				when count =>	   --Faz as divisões
					               --Deslocamento para a esquerda
					r1_next <= r1_reg(N-2 downto 0) & q_bit;	--Desloca os valores do dividendo e adiciona o resultado da subtração no bit menos significativo
					rh_next <= rh_aux(N-2 downto 0) & r1_reg(N-1);	--Desloca o valor subtraido e "puxa" o MSB do dividendo para seu LSB
					count_next <= count_reg - 1; --Atualiza o valor do contador
					if(count_reg = 1) then 
						state_next <= least;
					end if;

				when least => 
					r1_next <= r1_reg(N-2 downto 0) & q_bit;
					rh_next <= rh_aux;
					state_next <= done;

				when done => 
					state_next <= idle;
					terminou <= '1';
			end case;
		end process;
        
		quociente <= r1_reg;
		resto <= rh_reg;
end dividindo;