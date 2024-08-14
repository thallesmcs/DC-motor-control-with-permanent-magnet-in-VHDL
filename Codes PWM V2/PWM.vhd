library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
entity PWM is 
    port ( 
        CLK 	 	    : in  std_logic;
        RST 	 	: in  std_logic;
        SEL_PR      : in  std_logic_vector (1 downto 0);
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
	signal DUTY        : std_logic_vector (7 downto 0) := "00000000";
	signal SW_s        : std_logic_vector (7 downto 0);

	component divf
		port (
			clk		: in std_logic;
			rst   		: in std_logic;
			s_SEL_PR	: in std_logic_vector(1 downto 0);
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

		SW_s <= SW;  -- Lembrar de religar os SW para placa
		DUTY <= SW_s;

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
