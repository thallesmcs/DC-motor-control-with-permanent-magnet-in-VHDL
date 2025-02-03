library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity bin_bcd is
    Port (  bin : in  STD_LOGIC_VECTOR (25 downto 0);
            bcd : out STD_LOGIC_VECTOR (15 downto 0));
end bin_bcd;

architecture alg_magic of bin_bcd is

begin

    process(bin)
        variable i : integer;
        variable temp_bin : STD_LOGIC_VECTOR (25 downto 0);
        variable bcd_temp : STD_LOGIC_VECTOR (27 downto 0);
    begin
        
        temp_bin := bin;
        bcd_temp := (others => '0');
        
        for i in 0 to 25 loop

            if bcd_temp(27 downto 24) >= "0101" then
                bcd_temp(27 downto 24) := bcd_temp(27 downto 24) + "0011";
            end if;
            if bcd_temp(23 downto 20) >= "0101" then
                bcd_temp(23 downto 20) := bcd_temp(23 downto 20) + "0011";
            end if;
            if bcd_temp(19 downto 16) >= "0101" then
                bcd_temp(19 downto 16) := bcd_temp(19 downto 16) + "0011";
            end if;
            if bcd_temp(15 downto 12) >= "0101" then
                bcd_temp(15 downto 12) := bcd_temp(15 downto 12) + "0011";
            end if;
            if bcd_temp(11 downto 8) >= "0101" then
                bcd_temp(11 downto 8) := bcd_temp(11 downto 8) + "0011";
            end if;
            if bcd_temp(7 downto 4) >= "0101" then
                bcd_temp(7 downto 4) := bcd_temp(7 downto 4) + "0011";
            end if;
            if bcd_temp(3 downto 0) >= "0101" then
                bcd_temp(3 downto 0) := bcd_temp(3 downto 0) + "0011";
            end if;
            bcd_temp := bcd_temp(26 downto 0) & temp_bin(25);
            temp_bin := temp_bin(24 downto 0) & '0';
        end loop;
        bcd <= bcd_temp(15 downto 0);
    end process;
    
end alg_magic;