library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ent is
  port (
    clock
  ) ;
end ent;

architecture arch of ent is

    signal 

begin

end arch ; -- arch

process(CLK)

if (rising_edge(CLK))

if (val_hall = 0)
    cont <= cont + '1';
else 
    val_pos <= cont;    
    cont <= '0';
end if;
end if;
end process;
    

