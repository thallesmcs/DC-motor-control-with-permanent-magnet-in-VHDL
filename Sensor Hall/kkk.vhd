library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sensor_hall is
  port (
    clk       :  in  std_logic;   -- Clock de 50 MHz
    val_hall  :  in  std_logic;   -- Entrada do sensor Hall
    rpm       :  out std_logic_vector(15 downto 0)  -- Saída do RPM
  );
end sensor_hall;

architecture behavior of sensor_hall is

    -- Sinais internos
    signal cont        : unsigned(31 downto 0) := (others => '0');  -- Contador de ciclos do clock
    signal time_count  : unsigned(31 downto 0) := (others => '0');  -- Tempo medido entre transições
    signal rpm_calc    : unsigned(15 downto 0);                      -- Cálculo de RPM
    signal last_hall   : std_logic := '0';  -- Último estado do sensor Hall

    -- Constantes
    constant clock_freq : unsigned(31 downto 0) := to_unsigned(50000000, 32);  -- 50 MHz

begin

  -- Processo principal para contar ciclos e calcular RPM
  process(clk)
  begin
    if rising_edge(clk) then
      -- Se houver uma transição no sensor Hall
      if (val_hall = '1' and last_hall = '0') then
        -- Captura o tempo medido e reseta o contador
        time_count <= cont;
        cont <= (others => '0');

        -- Calculo do RPM: RPM = (Clock_Frequency * 60) / time_count
        if (time_count > 0) then
          rpm_calc <= (clock_freq * 60) / time_count;
        end if;

      else
        -- Incrementa o contador de ciclos do clock
        cont <= cont + 1;
      end if;

      -- Atualiza o estado do último valor do sensor Hall
      last_hall <= val_hall;
    end if;
  end process;

  -- Saída do valor de RPM calculado
  rpm <= std_logic_vector(rpm_calc);

end behavior;
