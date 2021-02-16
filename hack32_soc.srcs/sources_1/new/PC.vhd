library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    port ( 
        clk, rst, we, inc: in std_logic;
        din: in std_logic_vector(14 downto 0);
        q: out std_logic_vector(14 downto 0)
    );
end PC;

architecture behavioral of PC is
    
begin
    process (clk, rst, we, inc)
        variable count_up: std_logic_vector(14 downto 0) := "000000000000000";
    begin
        if (rst = '1') then
            count_up := "000000000000000";
        elsif (clk'event and clk = '1') then
            if (we = '1') then
                count_up := din;
            elsif (inc = '1') then
                count_up := count_up + 1;
            else
                count_up := count_up;
            end if;
        end if;     
        q <= count_up;
    end process;
end behavioral;
