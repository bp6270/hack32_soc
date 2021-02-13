library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;

entity ROM is
    port (
        addr : in STD_LOGIC_VECTOR(2 downto 0);
        dout : out STD_LOGIC_VECTOR(15 downto 0)
    );
end ROM;

architecture behavioral of ROM is
    type romtype is array (0 to 7) of bit_vector(15 downto 0);
    impure function initrom(romfilename : in string) return romtype is
        FILE romfile : text is in romfilename;
        variable romfileline : line;
        variable ROM : romtype;
    begin
        for I in romtype'range loop
            readline(romfile, romfileline);
            read(romfileline, ROM(I));
        end loop;
        return ROM;
    end function;

    
    signal ROM: romtype := initrom("Add.hack");
begin
    dout <= to_stdlogicvector(ROM(to_integer(unsigned(addr))));
end behavioral;
