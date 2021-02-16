library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port (
        opcode: in std_logic;
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
        variable result: signed (15 downto 0) := X"0000";
        variable isneg: std_logic := '0';
        variable iszero: std_logic := '0';
    begin  
        if (opcode = '1') then
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
                   
            
            
            if (result = X"0000") then
                iszero := '1';
            else
                iszero := '0';
            end if;
            
            if (result < X"0000") then
                isneg := '1';
            else
                isneg := '0';           
            end if;
            
            res <= std_logic_vector(result);
            zr <= iszero;
            ng <= isneg;
        else
            zr <= iszero;
            ng <= isneg;
            res <= std_logic_vector(result);
            
        end if;
 
    end process;
end behavioral;         