library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_clock_div is
end test_clock_div;

architecture sim of test_clock_div is

    component clock_div
        port (
            mclk: in STD_LOGIC;
            rst: in STD_LOGIC;
            clk50M: out STD_LOGIC;
            clk25M: out STD_LOGIC;
            clk48k: out STD_LOGIC
        );
    end component;
    
    signal tmclk, trst, tclk50M, tclk25M, tclk48k: STD_LOGIC;
begin
    dut: clock_div
        port map(
            mclk => tmclk,
            rst => trst,
            clk50M => tclk50M,
            clk25M => tclk25M,
            clk48k => tclk48k
        );
        
    clk_proc: process -- sim 100MHz master clock
    begin
        tmclk <= '0';
        wait for 5ns;
        tmclk <= '1';
        wait for 5ns;
    end process;
    
    clk_divider: process
    begin
        trst <= '1';
        wait for 10ns;
        trst <= '0';
        wait;
    end process;

end sim;
