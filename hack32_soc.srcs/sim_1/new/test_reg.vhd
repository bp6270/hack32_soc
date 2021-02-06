library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_reg is
end test_reg;

architecture sim of test_reg is

    component reg
        port (
            clk: in std_logic;
            we: in std_logic;
            din: in std_logic_vector(15 downto 0);
            dout: out std_logic_vector(15 downto 0) 
        );
    end component;
    
    signal tclk, twe: std_logic;
    signal tdin, tdout: std_logic_vector(15 downto 0);
    
begin
    dut: reg
        port map(
            clk => tclk, we => twe,
            din => tdin, dout => tdout
        );

    clk_proc: process
    begin
        tclk <= '0';
        wait for 10ns;
        tclk <= '1';
        wait for 10ns;
    end process;
    
    reg_test: process
    begin
        twe <= '0';
        tdin <= X"FFFF";
        
        wait for 100ns;
        twe <= '1';
        
        wait for 100ns;
        twe <= '0';
        assert tdout = X"FFFF" report "Checkpoint 1 failed" severity ERROR;
        
        wait for 100ns;
        tdin <= X"7777";
        
        wait for 100ns;
        assert tdout = X"FFFF" report "Checkpoint 2 failed" severity ERROR;
       
        twe <= '1';
        wait for 100ns;
        twe <= '0';
        assert tdout = X"7777" report "Checkpoint 3 failed" severity ERROR;
        
        wait;
    end process;
end sim;
