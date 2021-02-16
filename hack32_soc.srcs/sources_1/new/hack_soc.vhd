library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity hack_soc is
    port(
        mainrst: in STD_LOGIC;
        mainclk: in STD_LOGIC;
        vgaout: out STD_LOGIC_VECTOR(15 downto 0);
        vgaclk: out STD_LOGIC
    );
end hack_soc;

architecture structural of hack_soc is
    component clock_div
        port(
            mclk: in STD_LOGIC;
            rst: in STD_LOGIC;
            clktop: out STD_LOGIC;
            clk50M: out STD_LOGIC;
            clk25M: out STD_LOGIC;
            clk48k: out STD_LOGIC
    );
    end component;
    
    component RAM
        port (
            clk: in std_logic;
            we: in std_logic;
            addr: in std_logic_vector(14 downto 0);
            din: in std_logic_vector(15 downto 0);
            dout: out std_logic_vector (15 downto 0)
        );
    end component;
    
    component ROM
        port (
            addr : in STD_LOGIC_VECTOR(14 downto 0);
            dout : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    component hack_cpu
        port ( 
            inst: in std_logic_vector (15 downto 0);
            frommem: in std_logic_vector (15 downto 0);
            reset, clock: in std_logic;
            tomem: out std_logic_vector (15 downto 0);
            memwr: out std_logic;
            memaddr, pcaddr: out std_logic_vector(14 downto 0)
        );
    end component;
    
    -- Clock divider signals
    signal clktopsig: STD_LOGIC;
    signal clk50Msig: STD_LOGIC;
    signal clk25Msig: STD_LOGIC;
    signal clk48ksig: STD_LOGIC;
    
  
    -- ROM signals
    signal romdout: STD_LOGIC_VECTOR(15 downto 0);
    
    -- RAM signals
    signal ramdout: STD_LOGIC_VECTOR(15 downto 0);
    
    -- CPU signals
    signal cpumemout: STD_LOGIC_VECTOR(15 downto 0);
    signal cpumemwe: STD_LOGIC;
    signal cpumemaddrout: STD_LOGIC_VECTOR(14 downto 0);
    signal cpupcaddrout: STD_LOGIC_VECTOR(14 downto 0);
    
begin
    soc_clk_div: clock_div
        port map(
            mclk => mainclk,
            rst => mainrst,
            clktop => clktopsig,
            clk50M => clk50Msig,
            clk25M => clk25Msig,
            clk48k => clk48ksig
        );

    soc_cpu: hack_cpu
        port map(
            inst => romdout,
            frommem => ramdout,
            reset => mainrst,
            clock => clktopsig,
            tomem => cpumemout,
            memwr => cpumemwe,
            memaddr => cpumemaddrout,
            pcaddr => cpupcaddrout
        );
        
    soc_rom: ROM
        port map(
            addr => cpupcaddrout,
            dout => romdout
        );
 
    soc_ram: RAM
        port map(
            clk => clktopsig,
            we => cpumemwe,
            addr => cpumemaddrout,
            din => cpumemout,
            dout => ramdout
    );
    
        
    vgaout <= ramdout;
    vgaclk <= clk25Msig;
end structural;
