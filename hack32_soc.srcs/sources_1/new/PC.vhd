library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PC is
    port ( 
        clk, rst, we: in std_logic;
        din: in std_logic_vector(14 downto 0);
        q: out std_logic_vector(14 downto 0)
    );
end PC;

architecture behavioral of PC is
    signal count_up: std_logic_vector(14 downto 0) := "000000000000000";
begin
    process (clk, rst, we)
    begin
        if (rst = '1') then
            count_up <= ("000" & X"000");
        elsif (we = '1') then
            count_up <= din;
        end if;
        if (rising_edge(clk)) then
                count_up <= count_up + '1';
        end if;
    end process;
    
    q <= count_up;

end behavioral;
