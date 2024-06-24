library ieee;
use ieee.std_logic_1164.all;

entity divf is
    port(
        clk                       : in std_logic;
        rst                       : in std_logic;
        s_SEL_PR                    : in  std_logic_vector (1 downto 0);
        Q1, Q2, Q3, Q4, OUT_CLK     : out std_logic
    );
end divf;

architecture dividendo of divf is
    signal clk2    : std_logic; 
    signal clk4    : std_logic;
    signal clk8    : std_logic;

    component JK_FF
        port(
            clk: in std_logic;
            s_rst: in std_logic;
            Q: out std_logic
        );
    end component;

begin

    df1: JK_FF
        port map(
            clk => clk,
            s_rst => rst,
            Q => clk2             -- CLK divido por 2
        );

    df2: JK_FF
        port map(
            clk => clk2,
            s_rst => rst,
            Q => clk4             -- CLK divido por 4
        );

    df3: JK_FF
        port map(
            clk => clk4,
            s_rst => rst,
            Q => clk8             -- CLK divido por 8
        );
    
    df4: JK_FF
        port map(
            clk => clk8,
            s_rst => s_rst,
            Q => Q4               -- CLK divido por 16
        );

    Q1 <= clk2;
    Q2 <= clk4;
    Q3 <= clk8;

    ---------- Lembrando que a frequencia é divida 2^n, onde n é o numero de FF 
    ---------- F_clk = CLk / 2^n

    process (s_SEL_PR)
    begin 

                case s_SEL_PR is

                    when "00" => OUT_CLK <= Q4      -- CLK/16
                    when "10" => OUT_CLK <= Q2      -- CLK/4
                    when "01" => OUT_CLK <= clk   -- CLK
                    when others => OUT_CLK <= '0' 
                
                    end case;

    end process;

end dividendo;
