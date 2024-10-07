library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity PWM is 
    port ( 
        CLK 	 	    : in  std_logic;
        RST 	 	: in  std_logic;
        SEL_PR      : in  std_logic;
        SW          : in  std_logic_vector (7 downto 0);
        led         : out std_logic_vector (7 downto 0);
        PWM_OUT 	: out std_logic
    );
end entity;
architecture RTL of PWM is

	signal s_OUT_CLK   : std_logic; 
	signal CYCLE_OFF   : std_logic_vector (7 downto 0);
	signal s_PWM_OUT   : std_logic;	
	signal CONT        : std_logic_vector (7 downto 0) := "00000000";
	signal TIMER       : std_logic_vector (7 downto 0);
	--signal DUTY        : std_logic_vector (7 downto 0) := "00000000";
	signal P0,P1,P2,P3,P4,P5,P6,P7        : std_logic_vector (7 downto 0) := "00000000";
	signal SW_s        : std_logic_vector (7 downto 0);

	component divf
		port (
			clk			: in std_logic;
			rst   		: in std_logic;
			s_SEL_PR		: in std_logic;
			OUT_CLK		: out std_logic
		);
	end component;

	begin

	U0 : divf 
		port map(
			clk => CLK,
			rst => RST,
			s_SEL_PR => SEL_PR,
			OUT_CLK => s_OUT_CLK
			);

		--SW_s <= SW;  -- Lembrar de religar os SW para placa
		--DUTY <= SW_s;

--------------Potenciometro-------------------

	process(CLK)
		begin

			if(rising_edge(CLK)) then
				

				----Logica do P0----
				if(P0 = 1 and DUTY < "00000001") then			
					DUTY <= DUTY + "00000001";

				if(P0 = 1 and DUTY > "00000001") then
					DUTY <= DUTY - "00000001";

				----Logica do P1----				
				elsif(P1 = 1 and DUTY < "00000010") then
					DUTY <= DUTY + "00000001";

				elsif(P1 = 1 and DUTY > "00000010") then
					DUTY <= DUTY - "00000001";

				----Logica do P2----
				elsif(P2 = 1 and DUTY < "00000100") then
					DUTY <= DUTY + "00000001";

				elsif(P2 = 1 and DUTY > "00000100") then
					DUTY <= DUTY - "00000001";

				----Logica do P3----
				elsif(P3 = 1 and DUTY < "00001000") then
					DUTY <= DUTY + "00000001";

				elsif(P3 = 1 and DUTY > "00001000") then
					DUTY <= DUTY - "00000001";

				----Logica do P4----
				elsif(P4 = 1 and DUTY < "00010000") then
					DUTY <= DUTY + "00000001";

				elsif(P4 = 1 and DUTY > "00010000") then
					DUTY <= DUTY - "00000001";

				----Logica do P5----
				elsif(P5 = 1 and DUTY < "00100000") then
					DUTY <= DUTY + "00000001";

				elsif(P5 = 1 and DUTY > "00100000") then
					DUTY <= DUTY - "00000001";

				----Logica do P6----
				elsif(P6 = 1 and DUTY < "01000000") then
					DUTY <= DUTY + "00000001";

				elsif(P6 = 1 and DUTY > "01000000") then
					DUTY <= DUTY - "00000001";

				----Logica do P7----
				elsif(P7 = 1 and DUTY < "10000000") then
					DUTY <= DUTY + "00000001";				

				elsif(P7 = 1 and DUTY > "10000000") then
					DUTY <= DUTY - "00000001";		
				

				----Logica quando potenciometro for valor 0----
				elsif(P0 = 0 and P1 = 0 and P2 = 0 and P3 = 0 and P4 = 0 and P5 = 0 and P6 = 0 and P7 = 0)
					DUTY <= "00000000"
				
				end if;
			end if;
	end process;

----------------------------------------------


	TIMER <= "01000000";          --Maximo de Pulsos para o Contador e Tamanho maximo da PWM de 0-1
	
	CYCLE_OFF <= TIMER - DUTY - '1';  -- Tamanho do Ciclo off do pulso de PWM
	
	process(s_OUT_CLK,RST)
	begin
		if( RST = '1' ) then
			s_PWM_OUT <= '0';
			CONT      <= "00000000";
		elsif( s_OUT_CLK = '1' and s_OUT_CLK'EVENT ) then
							
				CONT <= CONT + '1';   	-- Conta os pulsos do s_CLK_OUT      
							-- Lembrando que s_CLK_OUT ee: CLK32,CLK16,CLK4,CLK

				if ( DUTY >= TIMER ) then         -- Condicao para o PWM 100%
					s_PWM_OUT <= '1';
					CONT      <= "00000000";
				elsif ( CONT = CYCLE_OFF ) then   -- Condicao para o fim do Ciclo off do PWM         
					s_PWM_OUT <= '1';
				elsif ( CONT = TIMER ) then       -- Condicao para o fim do Ciclo On do PWM
					s_PWM_OUT <= '0';
					CONT      <= "00000000";
				elsif ( CONT = "00000000") then
					s_PWM_OUT <= '0';
				end if;
					
		end if;
	end process;

	led <= DUTY;
	PWM_OUT <= not s_PWM_OUT;

	end RTL;
