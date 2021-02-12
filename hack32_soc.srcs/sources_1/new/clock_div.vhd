
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity clock_div is
    port(
            mclk: in STD_LOGIC;
            rst: in STD_LOGIC;
            clk50M: out STD_LOGIC;
            clk25M: out STD_LOGIC;
            clk48k: out STD_LOGIC
            
        );
end clock_div;

architecture behavioral of clock_div is
    signal q: STD_LOGIC_VECTOR(23 downto 0);

begin
    clk_divider: process(mclk, rst)
    begin
        if rst = '1' then
            q <= X"000000";
        elsif mclk'event and mclk = '1' then
            q <= q + 1;
        end if;
    end process;
   
    clk50M <= q(0); -- 50 MHz
    clk25M <= q(1); -- 25 MHz
    clk48k <= q(10); -- 48 kHz

end behavioral;
