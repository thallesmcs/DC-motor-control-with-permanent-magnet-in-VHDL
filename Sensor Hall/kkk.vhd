library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity sensor_hall is
  port (
    clk       : in std_logic;
    val_hall  : in std_logic;
    rpm       : out std_logic_vector(15 downto 0) -- Ajustado para 16 bits, suportando valores maiores
  );
end sensor_hall;

architecture behavior of sensor_hall is
    signal cont_time    : std_logic_vector(31 downto 0) := (others => '0'); -- Contador de tempo com 32 bits
    signal val_pos      : std_logic_vector(15 downto 0);
    signal rpm_calc     : std_logic_vector(15 downto 0); -- Sinal para até 5000 RPM
    signal hall_last    : std_logic; -- Estado anterior do sensor Hall
    constant F_CLK      : integer := 50000000; -- Frequência de clock em Hz
    signal cycles_per_rev : integer; -- Ciclos por revolução
    
begin

  process(clk)
  begin
    if (rising_edge(clk)) then
      -- Incrementa contador de tempo a cada ciclo de clock
      cont_time <= cont_time + 1;

      -- Detecta borda de descida no sensor Hall (transição de 1 para 0)
      if (val_hall = '0' and hall_last = '1') then
          -- Calcula os ciclos por revolução
          cycles_per_rev <= to_integer(cont_time);
          
          -- Calcula RPM: RPM = (60 * F_CLK) / cycles_per_rev
          if cycles_per_rev > 0 then
              rpm_calc <= std_logic_vector(to_unsigned((60 * F_CLK) / cycles_per_rev, 16)); -- Ajuste para 16 bits
          end if;

          cont_time <= (others => '0'); -- Reseta contador de tempo
      end if;

      -- Armazena o estado atual do sensor Hall
      hall_last <= val_hall;

    end if;
  end process;
  
  rpm <= rpm_calc; -- Saída de RPM calculado

end behavior;