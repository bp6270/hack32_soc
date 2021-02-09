library ieee;
use ieee.std_logic_1164.all;

entity test_hack_CPU is
end test_hack_CPU;

architecture sim of test_hack_CPU is

    component hack_CPU
        port ( 
            inst: in std_logic_vector (15 downto 0);
            frommem: in std_logic_vector (15 downto 0);
            reset, clock: in std_logic;
            tomem, aregout, dregout, aregmuxout, alumuxout: out std_logic_vector (15 downto 0);
            memwr: out std_logic;
            memaddr, pcaddr: out std_logic_vector(14 downto 0)
    );
    end component;
    
    signal tinst, tfrommem, ttomem, taregout, tdregout, taregmuxout, talumuxout: std_logic_vector(15 downto 0);
    signal tmemaddr, tpcaddr: std_logic_vector(14 downto 0);
    signal treset, tclock, tmemwr: std_logic;
begin
    dut: hack_CPU
        port map(
            inst => tinst,
            frommem => tfrommem,
            reset => treset, clock => tclock,
            tomem => ttomem, aregout => taregout, dregout => tdregout, aregmuxout => taregmuxout, alumuxout => talumuxout,
            memwr => tmemwr,
            memaddr => tmemaddr, pcaddr => tpcaddr
        );
        
    clk_proc: process
        begin
            tclock <= '0';
            wait for 1ns;
            tclock <= '1';
            wait for 1ns;
        end process;
    
    hack_cpu_test: process
    begin
        -- test A instruction
        wait for 10ns;
        tinst <= '0' & "000000000000001"; -- load 1
        tfrommem <= "1111000011110000";
        treset <= '0';
        
        wait for 2ns;
        tinst <= "111" & '0' & "110000" & "000" & "000"; -- output A as result
        
        wait for 2ns;
        tinst <= '0' & "000000000000010"; -- load 2
        
        wait for 2ns;
        tinst <= "111" & '0' & "110111" & "011" & "001"; -- add A+1 and save to A M D
        
        wait for 2ns;
        tinst <= "111" & '0' & "000010" & "001" & "000"; -- add D+A and save to M
    wait;
    end process;
end sim;
