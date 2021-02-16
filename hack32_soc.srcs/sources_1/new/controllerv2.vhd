library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controllerv2 is
    port(
        inst: in STD_LOGIC_VECTOR(15 downto 0);
        clk: in STD_LOGIC;
        rst: in STD_LOGIC;
        iszero, isneg: in STD_LOGIC;
        irwe, aregmuxsel, alumuxsel, aregwe, dregwe, resregwe, ramwe, pcwe, pcinc: out STD_LOGIC;
        alufunc: out STD_LOGIC_VECTOR(5 downto 0)
    );
end controllerv2;

architecture behavioral of controllerv2 is
    type state_type is (start, fetch, decode, executea, executec_cmp, executec_wb, executec_jmp);
    signal present_state, next_state: state_type;
begin
    state_reg: process (clk, rst)
    begin
        if rst = '1' then
            present_state <= start;
        elsif clk'event and clk = '1' then
            present_state <= next_state;
        end if;
    end process;

    c1: process (present_state, inst)
    begin
        case present_state is
            when start =>
                next_state <= fetch;
                
            when fetch =>
                next_state <= decode;
                
            when decode =>
                if inst(15) = '0' then
                    next_state <= executea;
                else
                    next_state <= executec_cmp;
                end if;
                
            when executea =>
                next_state <= fetch;
                
            when executec_cmp =>
                next_state <= executec_wb;
                
            when executec_wb =>
                next_state <= executec_jmp;
                
            when executec_jmp =>
                next_state <= fetch; 
                
            when others =>
                null;
        end case;
    end process;
    
    c2: process (present_state)
    begin
        irwe <= '0';
        aregmuxsel <= '0';
        alumuxsel <= '0';
        aregwe <= '0';
        dregwe <= '0';
        resregwe <= '0';
        ramwe <= '0';
        pcwe <= '0';
        pcinc <= '0';
        alufunc <= "000000";
        
        case present_state is
            when fetch =>
                irwe <= '1';
                
            when executea =>
                aregmuxsel <= '1';
                aregwe <= '1';
                pcinc <= '1';
                
            when executec_cmp =>
                alumuxsel <= inst(12);
                alufunc <= inst(11 downto 6);
                resregwe <= '1';
                
            when executec_wb =>
                if inst(5 downto 3) = "001" then
                    ramwe <= '1';
                elsif inst(5 downto 3) = "010" then
                    dregwe <= '1';
                elsif inst(5 downto 3) = "011" then
                    ramwe <= '1';
                    dregwe <= '1';
                elsif inst(5 downto 3) = "100" then
                    aregwe <= '1';
                elsif inst(5 downto 3) = "101" then
                    aregwe <= '1';
                    ramwe <= '1';
                elsif inst(5 downto 3) = "110" then
                    aregwe <= '1';
                    dregwe <= '1';
                elsif inst(5 downto 3) = "111" then
                    aregwe <= '1';
                    dregwe <= '1';
                    ramwe <= '1';
                else
                    aregwe <= '0';
                    dregwe <= '0';
                    ramwe <= '0';
                end if;
                
            when executec_jmp =>
                if inst (2 downto 0) = "001" then
                    if iszero = '0' then
                        if isneg = '0' then
                            pcwe <= '1';
                        else
                            pcinc <= '1';
                        end if;
                    else
                        pcinc <= '1';
                    end if;
                elsif inst (2 downto 0) = "010" then
                    if iszero = '1' then
                        pcwe <= '1';
                    else
                        pcinc <= '1';
                    end if;
                elsif inst (2 downto 0) = "011" then
                    if iszero = '1' then
                        if isneg = '0' then
                            pcwe <= '1';
                        else
                            pcinc <= '1';
                        end if;
                    else
                        pcinc <= '1';
                    end if;
                elsif inst (2 downto 0) = "100" then
                    if isneg = '1' then
                        pcwe <= '1';
                    else
                        pcinc <= '1';
                    end if;
                elsif inst (2 downto 0) = "101" then
                    if iszero = '0' then
                        pcwe <= '1';
                    else
                        pcinc <= '1';
                    end if;
                elsif inst (2 downto 0) = "110" then
                    if iszero = '1' then
                        pcwe <= '1';
                    elsif isneg = '1' then
                        pcwe <= '1';
                    else
                        pcinc <= '1';
                        pcwe <= '0';
                    end if;
                elsif inst (2 downto 0) = "111" then
                    pcwe <= '1';
                else
                    pcwe <= '0';  
                    pcinc <= '1'; 
                end if;     
            when others =>
                null;
        end case;
    end process;
end behavioral;
