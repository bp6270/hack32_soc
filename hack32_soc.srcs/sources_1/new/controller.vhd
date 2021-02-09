library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port ( 
        opcode, c_inst_a, is_zero, is_neg: in std_logic;
        c_inst_c: in std_logic_vector (5 downto 0);
        c_inst_d, c_inst_j: in std_logic_vector (2 downto 0);
        a_reg_mux_sel, alu_mux_sel, pc_we, a_reg_we, d_reg_we, ram_we: out std_logic;
        alu_op: out std_logic_vector (5 downto 0)
    );
end controller;

architecture behavioral of controller is
    -- a_reg_mux_sel (11), 
    -- alu_mux_sel (10), 
    -- pc_we (9), 
    -- a_reg_we (8), 
    -- d_reg_we (7), 
    -- ram_we (6), 
    -- alu_op (5:0)
begin
    process (all)
        variable control: std_logic_vector (11 downto 0);
    begin
        if (opcode = '0') then
            -- load A register with constant
            control := "100100000000";
        else           
            -- these blocks figure out where ALU computation is stored
            
            -- don't store anywhere
            if (c_inst_d = "000") then 
                control := ('0', c_inst_a, "0000", c_inst_c(5 downto 0));
                
            -- store in M addressed by A
            elsif (c_inst_d = "001") then
                control := ('0', c_inst_a, "0001", c_inst_c(5 downto 0));
                
            -- store in D
            elsif (c_inst_d = "010") then
                control := ('0', c_inst_a, "0010", c_inst_c(5 downto 0));
                
            -- store in M and D
            elsif (c_inst_d = "011") then 
                control := ('0', c_inst_a, "0011", c_inst_c(5 downto 0));
                
            -- store in A
            elsif (c_inst_d = "100") then
                control := ('0', c_inst_a, "0100", c_inst_c(5 downto 0));
                
            -- store in A and M
            elsif (c_inst_d = "101") then
                control := ('0', c_inst_a, "0101", c_inst_c(5 downto 0));
                
            -- store in A and D
            elsif (c_inst_d = "110") then
                control := ('0', c_inst_a, "0110", c_inst_c(5 downto 0));
                
            -- store in A, M, and D
            elsif (c_inst_d = "111") then
                control := ('0', c_inst_a, "0111", c_inst_c(5 downto 0));
            end if;
            
            -- these blocks figure out which instruction to go to next
    
            if (c_inst_j = "001") then -- jump if out > 0
                if (is_zero = '0') then
                    if (is_neg = '0') then
                        control := (control(11 downto 10), '1', control(8 downto 0));
                    end if;
                end if;
            elsif (c_inst_j = "010") then -- jump if out = 0
                if (is_zero = '1') then
                    control := (control(11 downto 10), '1', control(8 downto 0));
                end if;
            elsif (c_inst_j = "011") then -- jump if out >= 0
                if (is_zero = '1') then
                    control := (control(11 downto 10), '1', control(8 downto 0));
                elsif (is_neg = '0') then
                    control := (control(11 downto 10), '1', control(8 downto 0));
                end if;
            elsif (c_inst_j = "100") then -- jump if out < 0
                if (is_neg = '1') then
                    control := (control(11 downto 10), '1', control(8 downto 0));
                end if;
            elsif (c_inst_j = "101") then -- jump if out != 0
                if (is_zero = '0') then
                    control := (control(11 downto 10), '1', control(8 downto 0));
                end if;
            elsif (c_inst_j = "110") then -- jump if out <= 0
                if (is_zero = '1') then
                    control := (control(11 downto 10), '1', control(8 downto 0));
                elsif (is_neg = '1') then
                    control := (control(11 downto 10), '1', control(8 downto 0));
                end if;
            elsif (c_inst_j = "111") then -- unconditional jump
               control := (control(11 downto 10), '1', control(8 downto 0));
            end if;        
        end if;
        
        (a_reg_mux_sel, alu_mux_sel, pc_we, a_reg_we, d_reg_we, ram_we, alu_op(5 downto 0)) <= control;
    end process;
end behavioral;
