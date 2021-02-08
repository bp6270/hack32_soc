library ieee;
use ieee.std_logic_1164.all;

entity test_controller is
end test_controller;

architecture sim of test_controller is
    component controller
        port ( 
            opcode, c_inst_a, is_zero, is_neg: in std_logic;
            c_inst_c: in std_logic_vector (5 downto 0);
            c_inst_d, c_inst_j: in std_logic_vector (2 downto 0);
            a_reg_mux_sel, alu_mux_sel, pc_we, a_reg_we, d_reg_we, ram_we: out std_logic;
            alu_op: out std_logic_vector (5 downto 0)
        );
    end component;
    
    signal topcode, tc_inst_a, tis_zero, tis_neg: std_logic;
    signal ta_reg_mux_sel, talu_mux_sel, tpc_we, ta_reg_we, td_reg_we, tram_we: std_logic;
    signal tc_inst_d, tc_inst_j: std_logic_vector (2 downto 0);
    signal tc_inst_c, talu_op: std_logic_vector (5 downto 0);
    
begin
    dut: controller
        port map(
            opcode => topcode, c_inst_a => tc_inst_a, is_zero => tis_zero, is_neg => tis_neg,
            c_inst_c => tc_inst_c, 
            c_inst_d => tc_inst_d, c_inst_j => tc_inst_j,
            a_reg_mux_sel => ta_reg_mux_sel, alu_mux_sel => talu_mux_sel, pc_we => tpc_we,
            a_reg_we => ta_reg_we, d_reg_we => td_reg_we, ram_we => tram_we,
            alu_op => talu_op
        );
        
    process begin
        -- test 1: opcode is 0 (load a reg)
        topcode <= '0';
        tc_inst_a <= '1';
        
        wait for 20 ns;
        assert ta_reg_mux_sel = '1' report "Test 1 a reg mux failed" severity ERROR;
        assert ta_reg_we = '1' report "Test 1 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 1 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 1 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 1 pc we failed" severity ERROR;
        
        -- test 2: opcode is 1 (computation), save nowhere, no jump
        topcode <= '1';
        tc_inst_j <= "000";
        tc_inst_d <= "000";
        tc_inst_c <= "101010";
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 2 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 2 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 2 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 2 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 2 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 2 alu mux sel failed" severity ERROR;
        
        -- test 3: opcode is 1 (computation), save to M, no jump
        tc_inst_d <= "001";
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 3 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 3 d reg we failed" severity ERROR;
        assert tram_we = '1' report "Test 3 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 3 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 3 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 3 alu mux sel failed" severity ERROR;
        
        -- test 4: opcode is 1 (computation), save to D, no jump
        tc_inst_d <= "010";
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 4 a reg we failed" severity ERROR;
        assert td_reg_we = '1' report "Test 4 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 4 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 4 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 4 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 4 alu mux sel failed" severity ERROR;
        
        -- test 5: opcode is 1 (computation), save to MD, no jump
        tc_inst_d <= "011";
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 5 a reg we failed" severity ERROR;
        assert td_reg_we = '1' report "Test 5 d reg we failed" severity ERROR;
        assert tram_we = '1' report "Test 5 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 5 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 5 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 5 alu mux sel failed" severity ERROR;
        
        -- test 6: opcode is 1 (computation), save to A, no jump
        tc_inst_d <= "100";
        
        wait for 20 ns;       
        assert ta_reg_mux_sel = '0' report "Test 6 a reg mux sel failed" severity ERROR;
        assert ta_reg_we = '1' report "Test 6 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 6 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 6 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 6 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 6 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 6 alu mux sel failed" severity ERROR;
        
        -- test 7: opcode is 1 (computation), save to AM, no jump
        tc_inst_d <= "101";
        
        wait for 20 ns;  
        assert ta_reg_mux_sel = '0' report "Test 7 a reg mux sel failed" severity ERROR;
        assert ta_reg_we = '1' report "Test 7 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 7 d reg we failed" severity ERROR;
        assert tram_we = '1' report "Test 7 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 7 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 7 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 7 alu mux sel failed" severity ERROR;
        
        -- test 8: opcode is 1 (computation), save to AD, no jump
        tc_inst_d <= "110";
        
        wait for 20 ns;   
        assert ta_reg_mux_sel = '0' report "Test 8 a reg mux sel failed" severity ERROR;
        assert ta_reg_we = '1' report "Test 8 a reg we failed" severity ERROR;
        assert td_reg_we = '1' report "Test 8 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 8 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 8 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 8 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 8 alu mux sel failed" severity ERROR;
        
        -- test 9: opcode is 1 (computation), save to AMD, no jump
        tc_inst_d <= "111";
        
        wait for 20 ns;    
        assert ta_reg_mux_sel = '0' report "Test 9 a reg mux sel failed" severity ERROR;
        assert ta_reg_we = '1' report "Test 9 a reg we failed" severity ERROR;
        assert td_reg_we = '1' report "Test 9 d reg we failed" severity ERROR;
        assert tram_we = '1' report "Test 9 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 9 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 9 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 9 alu mux sel failed" severity ERROR;
        
        -- test 10: opcode is 1 (computation), save nowhere, jgt, negative number
        tc_inst_d <= "000";
        tc_inst_j <= "001";
        tis_zero <= '0';
        tis_neg <= '1';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 10 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 10 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 10 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 10 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 10 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 10 alu mux sel failed" severity ERROR;
        
        -- test 11: opcode is 1 (computation), save nowhere, jgt, zero number
        tis_zero <= '1';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 11 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 11 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 11 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 11 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 11 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 11 alu mux sel failed" severity ERROR;
        
        -- test 12: opcode is 1 (computation), save nowhere, jgt, positive number
        tis_zero <= '0';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 12 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 12 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 12 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 12 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 12 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 12 alu mux sel failed" severity ERROR;
        
        -- test 13: opcode is 1 (computation), save nowhere, jeq, negative number
        tc_inst_j <= "010";
        tis_zero <= '0';
        tis_neg <= '1';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 13 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 13 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 13 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 13 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 13 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 13 alu mux sel failed" severity ERROR;
        
        -- test 14: opcode is 1 (computation), save nowhere, jeq, zero number
        tis_zero <= '1';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 14 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 14 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 14 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 14 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 14 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 14 alu mux sel failed" severity ERROR;
        
        -- test 15: opcode is 1 (computation), save nowhere, jeq, positive number
        tis_zero <= '0';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 15 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 15 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 15 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 15 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 15 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 15 alu mux sel failed" severity ERROR;
        
        -- test 16: opcode is 1 (computation), save nowhere, jge, negative number
        tc_inst_j <= "011";
        tis_zero <= '0';
        tis_neg <= '1';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 16 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 16 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 16 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 16 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 16 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 16 alu mux sel failed" severity ERROR;
        
        -- test 17: opcode is 1 (computation), save nowhere, jge, zero number
        tis_zero <= '1';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 17 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 17 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 17 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 17 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 17 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 17 alu mux sel failed" severity ERROR;
        
        -- test 18: opcode is 1 (computation), save nowhere, jge, positive number
        tis_zero <= '0';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 18 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 18 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 18 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 18 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 18 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 18 alu mux sel failed" severity ERROR;
        
        -- test 19: opcode is 1 (computation), save nowhere, jlt, negative number
        tc_inst_j <= "100";
        tis_zero <= '0';
        tis_neg <= '1';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 19 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 19 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 19 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 19 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 19 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 19 alu mux sel failed" severity ERROR;
        
        -- test 20: opcode is 1 (computation), save nowhere, jlt, zero number
        tis_zero <= '1';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 20 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 20 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 20 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 20 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 20 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 20 alu mux sel failed" severity ERROR;
        
        -- test 21: opcode is 1 (computation), save nowhere, jlt, positive number
        tis_zero <= '0';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 21 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 21 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 21 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 21 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 21 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 21 alu mux sel failed" severity ERROR;
        
        -- test 22: opcode is 1 (computation), save nowhere, jne, negative number
        tc_inst_j <= "101";
        tis_zero <= '0';
        tis_neg <= '1';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 22 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 22 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 22 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 22 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 22 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 22 alu mux sel failed" severity ERROR;
        
        -- test 23: opcode is 1 (computation), save nowhere, jne, zero number
        tis_zero <= '1';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 23 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 23 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 23 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 23 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 23 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 23 alu mux sel failed" severity ERROR;
        
        -- test 24: opcode is 1 (computation), save nowhere, jne, positive number
        tis_zero <= '0';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 24 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 24 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 24 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 24 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 24 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 24 alu mux sel failed" severity ERROR;
        
        -- test 25: opcode is 1 (computation), save nowhere, jle, negative number
        tc_inst_j <= "110";
        tis_zero <= '0';
        tis_neg <= '1';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 25 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 25 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 25 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 25 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 25 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 25 alu mux sel failed" severity ERROR;
        
        -- test 26: opcode is 1 (computation), save nowhere, jle, zero number
        tis_zero <= '1';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 26 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 26 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 26 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 26 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 26 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 26 alu mux sel failed" severity ERROR;
        
        -- test 27: opcode is 1 (computation), save nowhere, jle, positive number
        tis_zero <= '0';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 27 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 27 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 27 ram we failed" severity ERROR;
        assert tpc_we = '0' report "Test 27 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 27 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 27 alu mux sel failed" severity ERROR;
        
        -- test 28: opcode is 1 (computation), save nowhere, unconditional jump, negative number
        tc_inst_j <= "111";
        tis_zero <= '0';
        tis_neg <= '1';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 28 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 28 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 28 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 28 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 28 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 28 alu mux sel failed" severity ERROR;
        
        -- test 29: opcode is 1 (computation), save nowhere, unconditional jump, zero number
        tis_zero <= '1';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 29 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 29 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 29 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 29 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 29 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 29 alu mux sel failed" severity ERROR;
        
        -- test 30: opcode is 1 (computation), save nowhere, unconditional jump, positive number
        tis_zero <= '0';
        tis_neg <= '0';
        
        wait for 20 ns;
        assert ta_reg_we = '0' report "Test 30 a reg we failed" severity ERROR;
        assert td_reg_we = '0' report "Test 30 d reg we failed" severity ERROR;
        assert tram_we = '0' report "Test 30 ram we failed" severity ERROR;
        assert tpc_we = '1' report "Test 30 pc we failed" severity ERROR;
        assert talu_op = "101010" report "Test 30 alu op failed" severity ERROR;
        assert talu_mux_sel = '1' report "Test 30 alu mux sel failed" severity ERROR;
        
        wait;
    end process;
end sim;
