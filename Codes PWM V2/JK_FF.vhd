library ieee;
use ieee.std_logic_1164.all;

entity JK_FF is
    port(
        J, K, s_clk: in std_logic;
        s_rst: in std_logic;
        Q: out std_logic
    );
end JK_FF;

architecture ark of JK_FF is

    signal qs: std_logic := '0';
    signal jk: std_logic_vector(1 downto 0);

begin

    jk <= J & K;
    process(s_clk,s_rst)
    begin

        if( s_rst = '1' ) then
            qs <= '0';

        elsif rising_edge(s_clk) then
            case jk is
                    when "00" =>  qs <= qs;
                    when "10" =>  qs <= '1';
                    when "01" =>  qs <= '0';
                    when "11" =>  qs <= not(qs); 
            end case;
        end if;
    end process;

    Q <= qs;
end ark;
