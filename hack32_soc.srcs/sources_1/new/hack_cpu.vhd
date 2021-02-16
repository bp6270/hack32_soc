library ieee;
use ieee.std_logic_1164.all;

entity hack_cpu is
    port ( 
        inst: in std_logic_vector (15 downto 0);
        frommem: in std_logic_vector (15 downto 0);
        reset, clock: in std_logic;
        tomem: out std_logic_vector (15 downto 0);
        memwr: out std_logic;
        memaddr, pcaddr: out std_logic_vector(14 downto 0)
    );
end hack_cpu;

architecture structural of hack_cpu is
    component controllerv2
        port(
            inst: in STD_LOGIC_VECTOR(15 downto 0);
            clk: in STD_LOGIC;
            rst: in STD_LOGIC;
            iszero, isneg: in STD_LOGIC;
            irwe, aregmuxsel, alumuxsel, aregwe, dregwe, resregwe, ramwe, pcwe, pcinc: out STD_LOGIC;
            alufunc: out STD_LOGIC_VECTOR(5 downto 0)
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
    
    component flagreg
        port (
            clk: in std_logic;
            we: in std_logic;
            din: in std_logic;
            dout: out std_logic 
        );
    end component;
    
    component ALUv2
        port (
            alufunc: in STD_LOGIC_VECTOR(5 downto 0);
            a: in STD_LOGIC_VECTOR(15 downto 0);
            b: in STD_LOGIC_VECTOR(15 downto 0);
            zf: out STD_LOGIC;
            nf: out STD_LOGIC;
            y: out STD_LOGIC_VECTOR(15 downto 0)    
        );
    end component;
    
    component PC
        port ( 
            clk, rst, we, inc: in std_logic;
            din: std_logic_vector(14 downto 0);
            q: out std_logic_vector(14 downto 0)
        );
    end component;
    
    -- controller signals
    signal irwectl, aregmuxselctl, alumuxselctl, aregwectl, dregwectl, resregwectl, ramwectl, pcwectl, pcincctl: std_logic;
    signal alu_op_ctrl: std_logic_vector (5 downto 0);
           
    -- inst reg signals
    signal iregdata: std_logic_vector(15 downto 0);
    
    -- a reg signals
    signal aregdata: std_logic_vector(15 downto 0);
    
    -- a reg mux
    signal aregmuxdata: std_logic_vector(15 downto 0);
    
    -- d reg signals
    signal dregdata: std_logic_vector(15 downto 0);
    
    -- res reg signals
    signal resregdata: std_logic_vector(15 downto 0);
    
    -- zero flag reg signal
    signal zflagregsig: std_logic;
    
    -- neg flag reg signal
    signal nflagregsig: std_logic;
    
    -- alu mux signals
    signal alumuxdata: std_logic_vector(15 downto 0);
    
    -- alu signals
    signal aluzerores: std_logic;
    signal alunegres: std_logic;
    signal alu_res: std_logic_vector(15 downto 0);
begin
    ctrlr: controllerv2
        port map(
            inst => iregdata,
            clk => clock,
            rst => reset,
            iszero => zflagregsig,
            isneg => nflagregsig,
            irwe => irwectl,
            aregmuxsel => aregmuxselctl,
            alumuxsel => alumuxselctl,
            aregwe => aregwectl,
            dregwe => dregwectl,
            resregwe => resregwectl,
            ramwe => ramwectl,
            pcwe => pcwectl,
            pcinc => pcincctl,
            alufunc => alu_op_ctrl
        );
        
    pctr: PC
        port map(
            clk => clock, rst => reset, we => pcwectl, inc => pcincctl,
            din => aregdata(14 downto 0),
            q => pcaddr
        );
        
    ireg: reg
        port map(
            clk => clock,
            we => irwectl,
            din => inst,
            dout => iregdata
        );
        
    areg_mux: mux
        port map(
            d0 => resregdata, d1 => iregdata,
            sel => aregmuxselctl,
            y => aregmuxdata
        );
        
    areg: reg
        port map(
            clk => clock,
            we => aregwectl,
            din => aregmuxdata,
            dout => aregdata
        );
        
    dreg: reg
        port map(
            clk => clock,
            we => dregwectl,
            din => resregdata,
            dout => dregdata
        );
        
    cpu_alu: ALUv2
        port map(
            alufunc => alu_op_ctrl,
            a => dregdata,
            b => alumuxdata,
            zf => aluzerores,
            nf => alunegres,
            y => alu_res
        );
        
    alu_mux: mux
        port map(
            d0 => aregdata, d1 => frommem,
            sel => alumuxselctl,
            y => alumuxdata
        );
        
    res_reg: reg
        port map(
            clk => clock,
            we => resregwectl,
            din => alu_res,
            dout => resregdata
        );
        
    zero_reg: flagreg
        port map(
            clk => clock,
            we => resregwectl,
            din => aluzerores,
            dout => zflagregsig
        );
        
    neg_reg: flagreg
        port map(
            clk => clock,
            we => resregwectl,
            din => alunegres,
            dout => nflagregsig
        );
    
    tomem <= resregdata;
    memwr <= ramwectl;
    memaddr <= aregdata(14 downto 0);
    
end structural;
