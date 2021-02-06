library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg is
    port (
        clk: in std_logic;
        we: in std_logic;
        din: in std_logic_vector(15 downto 0);
        dout: out std_logic_vector(15 downto 0) 
    );
end reg;

architecture behavioral of reg is
begin
    process (clk)
        variable temp: std_logic_vector(15 downto 0);
    begin
        if (rising_edge(clk)) then
            if (we = '1') then
                temp := din;
            end if;
        end if;
        
        dout <= temp;
    end process;
end behavioral;
