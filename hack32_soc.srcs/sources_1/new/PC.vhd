library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    Port ( 
        clk, reset: in std_logic;
        q: out std_logic_vector(15 downto 0)
    );
end PC;

architecture behavioral of PC is
    signal count_up: std_logic_vector(15 downto 0);
begin
    process (clk, reset)
    begin
        if (reset = '1') then
                count_up <= X"0000";
        end if;
        if (rising_edge(clk)) then
                count_up <= count_up + X"0001";
        end if;
    end process;
    
    q <= count_up;

end behavioral;
