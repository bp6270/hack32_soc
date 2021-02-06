library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_RAM is
end test_RAM;

architecture sim of test_RAM is

    component RAM
        port (
            clk: in std_logic;
            we: in std_logic;
            addr: in std_logic_vector(14 downto 0);
            din: in std_logic_vector(15 downto 0);
            dout: out std_logic_vector (15 downto 0)
        );
    end component;
    
    signal tclk, twe: std_logic;
    signal taddr: std_logic_vector(14 downto 0);
    signal tdin, tdout: std_logic_vector(15 downto 0);

begin
    dut: RAM
        port map(
            clk => tclk, we => twe,
            addr => taddr,
            din => tdin, dout => tdout
        );
        
    clk_proc : process
    begin
        tclk <= '0';
        wait for 10ns;
        tclk <= '1';
        wait for 10ns;
    end process;
    
    ram_test : process
    begin
        twe <= '0';
        taddr <= (OTHERS => '0');
        tdin <= X"FFFF";
        
        wait for 100ns;
        twe <= '1';
        
        wait for 100ns;
        twe <= '0';
        assert tdout = X"FFFF" report "Checkpoint 1 failed" severity ERROR;
        
        taddr <= (OTHERS => '1');
        tdin <= X"7777";
        
        wait for 100ns;
        twe <= '1';
        
        wait for 100ns;
        twe <= '0';
        assert tdout = X"7777" report "Checkpoint 2 failed" severity ERROR;
        
        wait for 100ns;
        taddr <= (OTHERS => '0');
        
        wait for 100ns;
        assert tdout = X"FFFF" report "Checkpoint 3 failed" severity ERROR;
        
        wait; 
    end process;
end sim;
