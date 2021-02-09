library ieee;
use ieee.std_logic_1164.all;

entity hack_cpu is
    port ( 
        inst: in std_logic_vector (15 downto 0);
        frommem: in std_logic_vector (15 downto 0);
        reset, clock: in std_logic;
        tomem, aregout, dregout, aregmuxout, alumuxout: out std_logic_vector (15 downto 0);
        memwr: out std_logic;
        memaddr, pcaddr: out std_logic_vector(14 downto 0)
    );
end hack_cpu;

architecture structural of hack_cpu is
    component controller
        port ( 
            opcode, c_inst_a, is_zero, is_neg: in std_logic;
            c_inst_c: in std_logic_vector (5 downto 0);
            c_inst_d, c_inst_j: in std_logic_vector (2 downto 0);
            a_reg_mux_sel, alu_mux_sel, pc_we, a_reg_we, d_reg_we, ram_we: out std_logic;
            alu_op: out std_logic_vector (5 downto 0)
        );
    end component;
    
    component mux
        port ( 
            d0, d1: in std_logic_vector(15 downto 0);
            sel: in std_logic;
            y: out std_logic_vector(15 downto 0)
        );  
    end component;

    component reg
        port (
            clk: in std_logic;
            we: in std_logic;
            din: in std_logic_vector(15 downto 0);
            dout: out std_logic_vector(15 downto 0) 
        );
    end component;
    
    component ALU
        port (
            x, y: in std_logic_vector (15 downto 0);
            zx, nx, zy, ny, f, no: in std_logic;
            res: out std_logic_vector (15 downto 0);
            zr, ng: out std_logic
        );
    end component;
    
    component PC
        port ( 
            clk, rst, we: in std_logic;
            din: std_logic_vector(14 downto 0);
            q: out std_logic_vector(14 downto 0)
        );
    end component;
    
    -- controller signals
    signal a_reg_mux_ctrl, alu_mux_sel_ctrl, pc_we_ctrl, a_reg_we_ctrl, d_reg_we_ctrl, ram_we_ctrl: std_logic;
    signal alu_op_ctrl: std_logic_vector (5 downto 0);
           
    -- a reg signals
    signal aregdata: std_logic_vector(15 downto 0);
    
    -- a reg mux
    signal aregmuxdata: std_logic_vector(15 downto 0);
    
    -- d reg signals
    signal dregdata: std_logic_vector(15 downto 0);
    
    -- alu mux signals
    signal alumuxdata: std_logic_vector(15 downto 0);
    
    -- alu signals
    signal res_zero, res_neg: std_logic;
    signal alu_res: std_logic_vector(15 downto 0);
begin
    ctrlr: controller
        port map(
            opcode => inst(15), c_inst_a => inst(12), is_zero => res_zero, is_neg => res_neg, 
            c_inst_c => inst(11 downto 6), 
            c_inst_d => inst(5 downto 3), c_inst_j => inst(2 downto 0),
            a_reg_mux_sel => a_reg_mux_ctrl, alu_mux_sel => alu_mux_sel_ctrl, pc_we => pc_we_ctrl, a_reg_we => a_reg_we_ctrl, d_reg_we => d_reg_we_ctrl, ram_we => ram_we_ctrl,
            alu_op => alu_op_ctrl
        );
        
    pctr: PC
        port map(
            clk => clock, rst => reset, we => pc_we_ctrl,
            din => aregdata(14 downto 0),
            q => pcaddr
        );
        
    areg_mux: mux
        port map(
            d0 => alu_res, d1 => inst(15 downto 0),
            sel => a_reg_mux_ctrl,
            y => aregmuxdata
        );
        
    areg: reg
        port map(
            clk => clock,
            we => a_reg_we_ctrl,
            din => aregmuxdata,
            dout => aregdata
        );
        
    dreg: reg
        port map(
            clk => clock,
            we => d_reg_we_ctrl,
            din => alu_res,
            dout => dregdata
        );
        
    cpu_alu: ALU
        port map(
            x => dregdata, y=> alumuxdata,
            zx => alu_op_ctrl(5) , nx => alu_op_ctrl(4), 
            zy => alu_op_ctrl(3), ny=> alu_op_ctrl(2), 
            f => alu_op_ctrl(1), no => alu_op_ctrl(0),
            res => alu_res,
            zr => res_zero, ng => res_neg
        );
        
    alu_mux: mux
        port map(
            d0 => aregdata, d1 => frommem,
            sel => alu_mux_sel_ctrl,
            y => alumuxdata
        );
    
    alumuxout <= alumuxdata;
    aregmuxout <= aregmuxdata;
    aregout <= aregdata;
    dregout <= dregdata;
    tomem <= alu_res;
    memwr <= ram_we_ctrl;
    memaddr <= aregdata(14 downto 0);
    
end structural;
