library ieee;
use ieee.std_logic_1164 .all;
use ieee.numeric_std.all;

entity test_ALU is
end test_ALU;

architecture sim of test_ALU is

    component ALU
        port (
            x, y: in std_logic_vector (15 downto 0);
            zx, nx, zy, ny, f, no: in std_logic;
            res: out std_logic_vector (15 downto 0);
            zr, ng: out std_logic
        );
    end component;
    
    signal tx, ty, tres: std_logic_vector(15 downto 0);
    signal tzx, tnx, tzy, tny, tf, tno, tzr, tng: std_logic;

begin
    dut: ALU
        port map(
            x=> tx, y => ty,
            zx => tzx, nx => tnx, zy => tzy, ny => tny, f => tf, no => tno,
            res => tres,
            zr => tzr, ng => tng
        );
    
    process begin
        tx <= x"0001";
        ty <= x"0002";
             
        -- row 1
        tzx <= '1';
        tnx <= '0';
        tzy <= '1';
        tny <= '0';
        tf <='1';
        tno <= '0';
        
        wait for 10ns;
        assert tres = X"0000" report "Row 1 (0) test failed" severity ERROR;
        
        -- row 2
        tzx <= '1';
        tnx <= '1';
        tzy <= '1';
        tny <= '1';
        tf <='1';
        tno <= '1';
        
        wait for 10ns;
        assert tres = X"0001" report "Row 2 (1) test failed" severity ERROR;
        
        -- row 3
        tzx <= '1';
        tnx <= '1';
        tzy <= '1';
        tny <= '0';
        tf <='1';
        tno <= '0';
        
        wait for 10ns;
        assert tres = x"FFFF" report "Row 3 (-1) test failed" severity ERROR;
        
        -- row 4
        tzx <= '0';
        tnx <= '0';
        tzy <= '1';
        tny <= '1';
        tf <='0';
        tno <= '0';
        
        wait for 10ns;
        assert tres = x"0001" report "Row 4 (x) test failed" severity ERROR;  
        
        -- row 5
        tzx <= '1';
        tnx <= '1';
        tzy <= '0';
        tny <= '0';
        tf <='0';
        tno <= '0';
        
        wait for 10ns;
        assert tres = x"0002" report "Row 5 (y) test failed" severity ERROR;
        
        -- row 6
        tzx <= '0';
        tnx <= '0';
        tzy <= '1';
        tny <= '1';
        tf <='0';
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"FFFE" report "Row 6 (!x) test failed" severity ERROR;
        
        -- row 7
        tzx <= '1';
        tnx <= '1';
        tzy <= '0';
        tny <= '0';
        tf <='0';
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"FFFD" report "Row 7 (!y) test failed" severity ERROR;
        
        -- row 8
        tzx <= '0';
        tnx <= '0';
        tzy <= '1';
        tny <= '1';
        tf <='1';
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"FFFF" report "Row 8 (-x) test failed" severity ERROR;
        
        -- row 9
        tzx <= '1';
        tnx <= '1';
        tzy <= '0';
        tny <= '0';
        tf <='1';
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"FFFE" report "Row 9 (-y) test failed" severity ERROR;
        
        -- row 10
        tzx <= '0';
        tnx <= '1';
        tzy <= '1';
        tny <= '1';
        tf <='1';
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"0002" report "Row 10 (x+1) test failed" severity ERROR;
        
        -- row 11
        tzx <= '1';
        tnx <= '1';
        tzy <= '0';
        tny <= '1';
        tf <='1';
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"0003" report "Row 11 (y+1) test failed" severity ERROR;
        
        -- row 12
        tzx <= '0';
        tnx <= '0';
        tzy <= '1';
        tny <= '1';
        tf <='1';
        tno <= '0';
        
        wait for 10ns;
        assert tres = x"0000" report "Row 12 (x-1) test failed" severity ERROR;
        
        -- row 13
        tzx <= '1';
        tnx <= '1';
        tzy <= '0';
        tny <= '0';
        tf <='1';
        tno <= '0';
        
        wait for 10ns;
        assert tres = x"0001" report "Row 13 (y-1) test failed" severity ERROR;
        
        -- row 14
        tzx <= '0';
        tnx <= '1';
        tzy <= '0';
        tny <= '0';
        tf <='1'; 
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"FFFF" report "Row 14 (x-y) test failed" severity ERROR;
        
        -- row 15
        tzx <= '0';
        tnx <= '0';
        tzy <= '0';
        tny <= '1';
        tf <='1'; 
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"0001" report "Row 15 (y-x) test failed" severity ERROR;
        
        -- row 16
        tzx <= '0';
        tnx <= '0';
        tzy <= '0';
        tny <= '0';
        tf <='0'; 
        tno <= '0';
        
        wait for 10ns;
        assert tres = x"0000" report "Row 16 (x&y) test failed" severity ERROR;
        
        -- row 17
        tzx <= '0';
        tnx <= '1';
        tzy <= '0';
        tny <= '1';
        tf <='0'; 
        tno <= '1';
        
        wait for 10ns;
        assert tres = x"0003" report "Row 17 (x|y) test failed" severity ERROR;
        
        wait;
    end process;

end sim;
