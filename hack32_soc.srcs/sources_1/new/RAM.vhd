library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
    port (
        clk: in std_logic;
        we: in std_logic;
        addr: in std_logic_vector(14 downto 0);
        din: in std_logic_vector(15 downto 0);
        dout: out std_logic_vector (15 downto 0)
    );
end RAM;

architecture behavioral of RAM is
    
    type mem_array is array (0 to (2**15)-1)
        of std_logic_vector(15 downto 0);
    signal mem: mem_array;

begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            if (we = '1') then
                mem(to_integer(unsigned(addr))) <= din;
            end if;
        end if;
    end process;
    
    dout <= mem(to_integer(unsigned(addr)));
end behavioral;
