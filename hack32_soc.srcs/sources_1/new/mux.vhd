library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    port ( 
        d0, d1: in std_logic_vector(15 downto 0);
        sel: in std_logic;
        y: out std_logic_vector(15 downto 0)
    );
end mux;

architecture behavioral of mux is

begin
    process (sel)
    begin
        if (sel='0') then
            y <= d0;
        elsif (sel='1') then
            y <= d1;
        end if;
    end process;
end behavioral;
