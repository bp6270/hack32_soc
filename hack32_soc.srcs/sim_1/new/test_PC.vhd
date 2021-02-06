library IEEE;
use IEEE.std_logic_1164.all;

entity test_PC is
end test_PC;

architecture sim of test_PC is

    component PC
        port (
            clk, reset: in std_logic;
            q: out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal tclk, treset: std_logic;
    signal tq: std_logic_vector(15 downto 0);
    
begin
    dut: PC
        port map(
            clk => tclk, reset => treset,
            q => tq            
        );
        
    clk_proc : process
    begin
        tclk <= '0';
        wait for 10ns;
        tclk <= '1';
        wait for 10ns;
    end process;
    
    counter : process
    begin
        treset <= '1';
        wait for 100ns;
        treset <= '0';
        wait for 100ns;
        treset <= '1';
        wait for 10ns;
        treset <= '0';
        wait;
    end process;
end sim;
