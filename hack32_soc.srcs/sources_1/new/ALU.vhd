library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        x, y: in std_logic_vector (15 downto 0);
        zx, nx, zy, ny, f, no: in std_logic;
        res: out std_logic_vector (15 downto 0);
        zr, ng: out std_logic
    );
end ALU;

architecture behavioral of ALU is
begin
    process (all)
        variable a, b: signed (15 downto 0);
        variable result: signed (15 downto 0);
    begin  
        a := signed(x);
        b := signed(y);
        
        if (zx = '1') then
            a := X"0000";
        end if;
        
        if (nx = '1') then
            a := not a;
        end if;
        
        if (zy = '1') then
            b := X"0000";
        end if;
        
        if (ny = '1') then
            b := not b;
        end if;
        
        if (f = '1') then
            result := a + b;
        else
            result := a and b;
        end if;
        
        if (no = '1') then
            result := not result;
        end if;
               
        res <= std_logic_vector(result);
        
        if (result = X"0000") then
            zr <= '1';
        else
            zr <= '0';
        end if;
        
        if (result< X"0000") then
            ng <= '1';
        else
            ng <= '0';
        end if;
    end process;
end behavioral;         