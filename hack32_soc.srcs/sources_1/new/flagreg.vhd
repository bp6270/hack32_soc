library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity flagreg is
    port (
        clk: in std_logic;
        we: in std_logic;
        din: in std_logic;
        dout: out std_logic
    );
end flagreg;

architecture behavioral of flagreg is
begin
    process (clk)
        variable temp: std_logic;
    begin
        if (rising_edge(clk)) then
            if (we = '1') then
                temp := din;
            end if;
        end if;
        
        dout <= temp;
    end process;
end behavioral;