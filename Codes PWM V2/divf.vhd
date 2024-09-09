library ieee;
use ieee.std_logic_1164.all;

entity divf is
    port(
        clk                       : in std_logic;
        rst                       : in std_logic;
        s_SEL_PR                  : in  std_logic_vector (1 downto 0);
        OUT_CLK                   : out std_logic
    );
end divf;

architecture dividendo of divf is
    signal jk_input : std_logic := '1';
    
    signal clk2    : std_logic; 
    signal clk4    : std_logic;
    signal clk8    : std_logic;
    signal clk16    : std_logic;
    signal clk32    : std_logic;

--------Maquina de estados------------

    type estado is (CLK32,CLK16);
    signal estado_atual, proximo_estado : estado;

--------------------------------------

    component JK_FF
        port(
            J, K : in std_logic;
            s_clk: in std_logic;
            s_rst: in std_logic;
            Q: out std_logic
        );
    end component;

begin

    df1: JK_FF
        port map(
            J =>jk_input,
            k =>jk_input,
            s_clk => clk,
            s_rst => rst,
            Q => clk2             -- CLK divido por 2
        );

    df2: JK_FF
        port map(
            J =>jk_input,
            k =>jk_input,
            s_clk => clk2,
            s_rst => rst,
            Q => clk4             -- CLK divido por 4
        );

    df3: JK_FF
        port map(
            J =>jk_input,
            k =>jk_input,
            s_clk => clk4,
            s_rst => rst,
            Q => clk8             -- CLK divido por 8
        );
   
    df4: JK_FF
        port map(
            J =>jk_input,
            k =>jk_input,
            s_clk => clk8,
            s_rst => rst,
            Q => clk16               -- CLK divido por 16
        );

    df5: JK_FF
        port map(
            J =>jk_input,
            k =>jk_input,
            s_clk => clk16,
            s_rst => rst,
            Q => clk32               -- CLK divido por 16
        );

    ---------- Lembrando que a frequencia é divida 2^n, onde n é o numero de FF 
    ---------- F_clk = CLk / 2^n

    sincrono : process (clk, rst, proximo_estado)
    
    begin
    
    	if (reset = '1') then
    		estado_atual <= clk32;
    		
    	elsif (rising_edge(clk)) then
    		estado_atual <= proximo_estado;
    	end if;
    
    end process;
    
    
    combinacional : process (estado_atual, entrada)
    
    begin 

	OUT_CLK <= '0';
	
        case estado_atual is

            when CLK32 => OUT_CLK <= '0';
            
            	if(s_SEL_PR = '1') then
            		proximo_estado <= clk16;
            	else
            		proximo_estado <= clk32;
		end if;
	    
	    when CLK16 => OUT_CLK <= '1';
	    
            	if(s_SEL_PR = '1') then
            		proximo_estado <= clk32;
            	else
            		proximo_estado <= clk16;
		end if;

        end case;
	

    end process;

end dividendo;
