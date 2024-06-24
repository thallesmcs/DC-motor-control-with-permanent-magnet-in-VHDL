library ieee;
use ieee.std_logic_1164.all;

entity JK_FF is
    port(
        s_clk: in std_logic;
        s_rst: in std_logic;
        Q: out std_logic
    );
end JK_FF;

architecture ark of JK_FF is

    signal qs: std_logic := '0';

begin

    process(s_clk,s_rst)
    begin

        if( s_rst = '1' ) then
            qs <= '0';

        elsif rising_edge(s_clk) then
            qs <= not qs;
        end if;
    end process;

    Q <= qs;
end ark;
