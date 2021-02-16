library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_hack_soc is
end test_hack_soc;

architecture sim of test_hack_soc is
    component hack_soc
        port(
            mainrst: in STD_LOGIC;
            mainclk: in STD_LOGIC;
            vgaout: out STD_LOGIC_VECTOR(15 downto 0);
            vgaclk: out STD_LOGIC
        );
    end component;
    
    signal tmainrst, tmainclk, tvgaclk: STD_LOGIC;
    signal tvgaout: STD_LOGIC_VECTOR(15 downto 0);
begin
    dut: hack_soc
        port map(
            mainrst => tmainrst, mainclk => tmainclk,
            vgaout => tvgaout, vgaclk => tvgaclk
        );
        
    clk_proc: process
        begin
            tmainclk <= '0';
            wait for 5ns;
            tmainclk <= '1';
            wait for 5ns;
        end process;
        
    hack_soc_test: process
    begin
        tmainrst <= '1';
        wait for 10ns;
        tmainrst <= '0';
        wait;
    end process;

end sim;
