library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity ALUv2 is
    port (
        alufunc: in STD_LOGIC_VECTOR(5 downto 0);
        a: in STD_LOGIC_VECTOR(15 downto 0);
        b: in STD_LOGIC_VECTOR(15 downto 0);
        zf: out STD_LOGIC;
        nf: out STD_LOGIC;
        y: out STD_LOGIC_VECTOR(15 downto 0)    
    );
end ALUv2;

architecture behavioral of ALUv2 is
begin
    process(a, b, alufunc)
        variable yv: STD_LOGIC_VECTOR(15 downto 0);
        variable zfv, nfv: STD_LOGIC;
    begin
        zfv := '0';
        
        case alufunc is
            when "101010" => -- 0
                yv := X"0000";
            when "111111" => -- 1
                yv := X"0001";
            when "111010" => -- -1
                yv := X"FFFF";
            when "001100" => -- emit a
                yv := a;
            when "110000" => -- emit b
                yv := b;
            when "001101" => -- NOT A
                yv := not a;
            when "110001" => -- NOT B
                yv := not b;
            when "001111" => -- -a
                yv := (not a) + 1;
            when "110011" => -- -b
                yv := (not b) + 1;
            when "011111" => -- a + 1
                yv := a + 1;
            when "110111" => -- b + 1
                yv := b + 1;
            when "001110" => -- a - 1
                yv := a - 1;
            when "110010" => -- b - 1
                yv := b - 1;
            when "000010" => -- a + b
                yv := a + b;
            when "010011" => -- a - b
                yv := a - b;
            when "000111" => -- b - a
                yv := b - a;
            when "000000" => -- a AND b
                yv := a and b;
            when "010101" => -- a OR b
                yv := a or b;
            when others =>
                yv := a;
        end case;
        
        for i in 0 to 15 loop
            zfv := zfv or yv(i);
        end loop;
        
        y <= yv;
        zf <= not zfv;
        nf <= yv(15);                   
    end process;
end behavioral;
