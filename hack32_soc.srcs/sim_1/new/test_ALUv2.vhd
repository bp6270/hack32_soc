library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity test_ALUv2 is
end test_ALUv2;

architecture sim of test_ALUv2 is
    component ALUv2
        port (
            alufunc: in STD_LOGIC_VECTOR(5 downto 0);
            a: in STD_LOGIC_VECTOR(15 downto 0);
            b: in STD_LOGIC_VECTOR(15 downto 0);
            zf: out STD_LOGIC;
            nf: out STD_LOGIC;
            y: out STD_LOGIC_VECTOR(15 downto 0)    
        );
    end component;
    
    signal talufunc: STD_LOGIC_VECTOR(5 downto 0);
    signal ta, tb: STD_LOGIC_VECTOR(15 downto 0);
    signal tzf, tnf: STD_LOGIC;
    signal ty: STD_LOGIC_VECTOR(15 downto 0);
begin
    dut: ALUv2
        port map(
            alufunc => talufunc,
            a => ta,
            b => tb,
            zf => tzf,
            nf => tnf,
            y => ty
        );
    
    process
    begin
        
    ta <= x"0001";
    tb <= x"0002";
    talufunc <= "101010";
    
    wait for 10ns;
    assert ty = X"0000" report "Row 1 (0) test failed" severity ERROR;
    
    talufunc <= "111111";
    wait for 10ns;
    assert ty = X"0001" report "Row 2 (1) test failed" severity ERROR;
    
    talufunc <= "111010";
    wait for 10ns;
    assert ty = x"FFFF" report "Row 3 (-1) test failed" severity ERROR;
    
    talufunc <= "001100";
    wait for 10ns;
    assert ty = x"0001" report "Row 4 (a) test failed" severity ERROR;
    
    talufunc <= "110000";
    wait for 10ns;
    assert ty = x"0002" report "Row 5 (b) test failed" severity ERROR;
    
    talufunc <= "001101";
    wait for 10ns;
    assert ty = x"FFFE" report "Row 6 (!a) test failed" severity ERROR;
    
    talufunc <= "110001";
    wait for 10ns;
    assert ty = x"FFFD" report "Row 7 (!b) test failed" severity ERROR;
    
    talufunc <= "001111";
    wait for 10ns;
    assert ty = x"FFFF" report "Row 8 (-a) test failed" severity ERROR;
    
    talufunc <= "110011";
    wait for 10ns;
    assert ty = x"FFFE" report "Row 9 (-b) test failed" severity ERROR;
    
    talufunc <= "011111";
    wait for 10ns;
    assert ty = x"0002" report "Row 10 (a+1) test failed" severity ERROR;
    
    talufunc <= "110111";
    wait for 10ns;
    assert ty = x"0003" report "Row 11 (b+1) test failed" severity ERROR;
    
    talufunc <= "001110";
    wait for 10ns;
    assert ty = x"0000" report "Row 12 (a-1) test failed" severity ERROR;
    
    talufunc <= "110010";
    wait for 10ns;
    assert ty = x"0001" report "Row 13 (b-1) test failed" severity ERROR;
    
    talufunc <= "010011";
    wait for 10ns;
    assert ty = x"FFFF" report "Row 14 (a-b) test failed" severity ERROR;
    
    talufunc <= "000111";
    wait for 10ns;
    assert ty = x"0001" report "Row 15 (b-a) test failed" severity ERROR;
    
    talufunc <= "000000";
    wait for 10ns;
    assert ty = x"0000" report "Row 16 (a&b) test failed" severity ERROR;
    
    talufunc <= "010101";
    wait for 10ns;
    assert ty = x"0003" report "Row 17 (a|b) test failed" severity ERROR;
    
    wait;
    end process;

end sim;
