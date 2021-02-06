library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity test_mux is
end test_mux;

architecture sim of test_mux is

    component mux
        port(
            d0, d1: in std_logic_vector(15 downto 0);
            sel: in std_logic;
            y: out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal td0, td1, ty: std_logic_vector(15 downto 0);
    signal tsel: std_logic;
    
begin
    dut: mux 
        port map(
                d0 => td0, d1 => td1, 
                sel => tsel, 
                y => ty
        );
    
    process begin
        td0 <= x"FFFF";
        td1 <= x"AABB";
        
        tsel <= '1';        
        wait for 10ns;
        assert ty = x"AABB" report "tsel1 output incorrect" severity ERROR;
        
        tsel <= '0';
        wait for 10ns;
        assert ty = x"FFFF" report "tsel0 output incorrect" severity ERROR;
   
        wait;
    end process;
end sim;
