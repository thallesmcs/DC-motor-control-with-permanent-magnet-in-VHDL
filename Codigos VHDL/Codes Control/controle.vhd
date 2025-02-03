library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity controle is
    Port(
        CLK         : in  std_logic;
        RST         : in  std_logic;
        SW          : in  std_logic_vector(7 downto 0); -- PWM desejado
        HALL_IN     : in  std_logic;
        SEL_PR      : in  std_logic;
        AN          : out std_logic_vector (3 downto 0);
        CX          : out std_logic_vector (7 downto 0);
        LED         : out std_logic_vector (7 downto 0);
        PWM_OUT     : out std_logic
    );
end controle;

architecture Behavioral of controle is

component PWM
    port (
        CLK         : in  std_logic;
        RST         : in  std_logic;
        SEL_PR      : in  std_logic;
        SW          : in  std_logic_vector (7 downto 0);
        LED         : out std_logic_vector (7 downto 0);
        PWM_OUT     : out std_logic
    );
end component;

component hall
    port(
        CLK, RST, HALL : in std_logic;
        AN              : out std_logic_vector (3 downto 0);
        CX              : out std_logic_vector (7 downto 0);
        RPM             : out std_logic_vector(25 downto 0)
    );
end component;

--------------------------Sistema de controle----------------------------

signal RRPM          : std_logic_vector(25 downto 0);  
signal ERROR         : integer range -33554432 to 33554431 := 0;
signal DUTY_CYCLE    : std_logic_vector(7 downto 0) := "00000000";
signal RPM           : std_logic_vector(25 downto 0);

-------------------------------------------------------------------------

-------------------------Frequencia do controle--------------------------

signal      count_f		        : std_logic_vector (25 downto 0) := "00000000000000000000000000" ;
signal      clk_controle         : std_logic := '0';
constant    f_clk_controle		: std_logic_vector (25 downto 0) := "00010110111000110110000000"; -- Decimal = 24;

-------------------------------------------------------------------------


--------------------------Variáveis de controle--------------------------

signal error_small, error_medium, error_large : std_logic;

-------------------------------------------------------------------------

begin

Sensor_Hall : hall
    port map(
        CLK => CLK, 
        RST => RST,
        HALL => HALL_IN,
        CX => CX,
        AN => AN,
        RPM => RPM
    );
    
process(CLK)
    begin
        if(rst ='1') then
            count_f <= "00000000000000000000000000";
            clk_controle <= '0';
        
        elsif(rising_edge(clk)) then
            count_f <= count_f + "00000000000000000000000001";
                
            if(count_f = f_clk_controle) then
            count_f <= "00000000000000000000000000";
            clk_controle <= not clk_controle;
            end if;   
                
        end if;
    end process;

process(SW)     --Referencia do RRPM, baseado no SW
begin
    case SW is
        when "00000001" => RRPM <= "00000000000000000000000000";  -- 0rpm
        when "00000010" => RRPM <= "00000000000000000000001010";  -- 0rpm
        when "00000100" => RRPM <= "00000000000000000111110100";  -- 500rpm
        when "00001000" => RRPM <= "00000000000000001010111100";  -- 700rpm
        when "00010000" => RRPM <= "00000000000000001111101000";  -- 1000rpm
        when "00100000" => RRPM <= "00000000000000010111011100";  -- 1500rpm
        when "01000000" => RRPM <= "00000000000000100111000100";  -- 2500rpm
        when others     => RRPM <= RPM; 
    end case;
end process;


process(CLK)    -- Cálculo do erro
begin

    if rising_edge(CLK) then
        ERROR <= to_integer(signed(RRPM)) - to_integer(signed(RPM));  --Erro positivo aumenta vel, Erro negativo abaixa vel

    end if;
end process;


process(ERROR) 
begin
    
    
    if ERROR >= -200 and ERROR <= -50 then      -- Erro negativo small 1
        error_small <= '1';
        error_medium <= '0';
        error_large <= '0';
    
    elsif ERROR >= 50 and ERROR <= 200 then     -- Erro Positivo small 1
        error_small <= '1';
        error_medium <= '0';
        error_large <= '0';      

    elsif ERROR >= -50 and ERROR <= 50 then     -- Erro na faixa medium 1
        error_small <= '0';
        error_medium <= '1';
        error_large <= '0';  

    else                                        -- Erro positivo e negativo large 1
        error_small <= '0';
        error_medium <= '0';
        error_large <= '1';
        
    end if;
end process;


process(clk_controle)  
begin
    if rising_edge(clk_controle) then
        if RST = '1' then
            DUTY_CYCLE <= "00000000";
        
        else        
            -- Se erro é grande positivo, aumentar duty cycle rapidamente
            if error_large = '1'  then   
                    if ERROR > 0 then
                        if DUTY_CYCLE < "01000000" then    -- 00111111
                            DUTY_CYCLE <= DUTY_CYCLE + "00000100";
                        end if;
                    elsif ERROR < 0 then
                        if DUTY_CYCLE >= "00000100" then
                            DUTY_CYCLE <= DUTY_CYCLE - "00000100";
                        end if;
                    end if;
            -- Se erro é médio, ajustar moderadamente
            elsif error_medium = '1' then                      
                if ERROR > 0 then
                    if DUTY_CYCLE < "01000000" then
                        DUTY_CYCLE <= DUTY_CYCLE + "00000001";
                    end if;
                elsif ERROR < 0 then
                    if DUTY_CYCLE >= "00000001" then
                        DUTY_CYCLE <= DUTY_CYCLE - "00000001";
                    end if;
                else 
                    DUTY_CYCLE <= DUTY_CYCLE;
                end if;

            -- Se erro é pequeno negativo, reduzir duty cycle
            elsif error_small = '1' then
                if ERROR > 0 then
                    if DUTY_CYCLE < "01000000" then     --00111111
                        DUTY_CYCLE <= DUTY_CYCLE + "00000010";
                    end if;
                elsif ERROR < 0 then
                    if DUTY_CYCLE >= "00000010" then
                        DUTY_CYCLE <= DUTY_CYCLE - "00000010";
                    end if;   
                end if;     
            end if;
        end if;
    end if;
end process;

Pulse_Width_Modulation : PWM
    port map(
        CLK => CLK,
        RST => RST,
        SEL_PR => SEL_PR,
        SW => DUTY_CYCLE,
        LED => LED,
        PWM_OUT => PWM_OUT
    );

end Behavioral;