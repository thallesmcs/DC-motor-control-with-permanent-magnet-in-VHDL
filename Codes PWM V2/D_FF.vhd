library ieee;
use ieee.std_logic_1164.all;

entity D_FF is
    port(
        D, s_clk: in std_logic;
        s_rst: in std_logic;
        Q: out std_logic
    );
end D_FF;

architecture ark of D_FF is

    signal qs: std_logic := '0';
    signal d: std_logic := '0';

begin

    d <= D;

    process(s_clk,s_rst)
    begin

        if( s_rst = '1' ) then
            qs <= '0';

        elsif rising_edge(s_clk) then
            case d is
                    when "0" =>  qs <= '0';
                    when "1" =>  qs <= '1';
                    --when "01" =>  qs <= '0';
                    --when "11" =>  qs <= qs; 
            end case;
        end if;
    end process;

    Q <= qs;
end ark;
