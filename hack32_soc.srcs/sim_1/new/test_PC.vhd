library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_PC is
end test_PC;

architecture sim of test_PC is

    component PC
        port (
            clk, rst, we: in std_logic;
            din: in std_logic_vector(14 downto 0);
            q: out std_logic_vector(14 downto 0)
        );
    end component;
    
    signal tclk, trst, twe: std_logic;
    signal tdin: std_logic_vector(14 downto 0);
    signal tq: std_logic_vector(14 downto 0);
    
begin
    dut: PC
        port map(
            clk => tclk, rst => trst, we => twe,
            din => tdin,
            q => tq            
        );
        
    clk_proc: process
    begin
        tclk <= '0';
        wait for 10ns;
        tclk <= '1';
        wait for 10ns;
    end process;
    
    counter: process
    begin
        trst <= '1';
        tdin <= std_logic_vector(to_unsigned(42, tdin'length));
        
        wait for 10ns;
        trst <= '0';
        wait for 10ns;
        trst <= '1';
        wait for 10ns;
        trst <= '0';
        wait for 100ns;
        twe <= '1';
        wait for 50ns;
        twe <= '0';
        wait for 100ns;
        trst <= '1';
        wait for 10 ns;
        trst <= '0';
        
        wait;
    end process;
end sim;
