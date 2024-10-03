library IEEE;
use IEEE.std_logic_1164.all;

entity tb_sensor_hall is
-- Testbench não precisa de portas
end tb_sensor_hall;

architecture behavior of tb_sensor_hall is
    signal clk       : std_logic := '0';
    signal val_hall  : std_logic := '0';
    signal rpm       : std_logic_vector(15 downto 0);

    -- Período do clock: 50 MHz -> 20 ns
    constant clk_period : time := 20 ns;

begin

    -- Instancia o módulo sensor_hall
    uut: entity work.sensor_hall
    port map (
        clk => clk,
        val_hall => val_hall,
        rpm => rpm
    );

    -- Processo para gerar o clock de 50 MHz
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Processo para simular o sinal do sensor Hall (5000 RPM)
    hall_process : process
    begin
        wait for 6 ms; -- Simula meio período da rotação (12 ms para uma rotação completa a 5000 RPM)
        val_hall <= '1';
        wait for 6 ms;
        val_hall <= '0';
    end process;

end behavior;