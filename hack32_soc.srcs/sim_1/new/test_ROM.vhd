library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_ROM is
end test_ROM;

architecture sim of test_ROM is

    component ROM
        port (
            addr : in STD_LOGIC_VECTOR(2 downto 0);
            dout : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    signal taddr : STD_LOGIC_VECTOR(2 downto 0);
    signal tdout : STD_LOGIC_VECTOR(15 downto 0);
begin
    dut: ROM
        port map(
            addr => taddr,
            dout => tdout
        );
    
    -- this tests Add.hack (replace asserts if you change the init file in the ROM)
    process
    begin
        wait for 10ns;
        taddr <= "000";
        assert tdout = "0000000000000010" report "Addr 000 failed" severity ERROR;
        
        wait for 10ns;
        taddr <= "001";
        assert tdout = "1110110000010000" report "Addr 001 failed" severity ERROR;
        
        wait for 10ns;
        taddr <= "010";
        assert tdout = "0000000000000011" report "Addr 010 failed" severity ERROR;
        
        wait for 10ns;
        taddr <= "011";
        assert tdout = "1110000010010000" report "Addr 011 failed" severity ERROR;
        
        wait for 10ns;
        taddr <= "100";
        assert tdout = "0000000000000000" report "Addr 100 failed" severity ERROR;
        
        wait for 10ns;
        taddr <= "101";
        assert tdout = "1110001100001000" report "Addr 101 failed" severity ERROR;
        
        -- these are empty areas of the ROM
        wait for 10ns;
        taddr <= "110";
        assert tdout = "0000000000000000" report "Addr 110 failed" severity ERROR;
        
        wait for 10ns;
        taddr <= "111";
        assert tdout = "0000000000000000" report "Addr 111 failed" severity ERROR;
        
        wait;
    end process;
end sim;
