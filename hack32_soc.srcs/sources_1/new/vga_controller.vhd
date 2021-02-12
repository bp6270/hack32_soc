library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 640 x 480 controller @ 60Hz using 25MHz pixel clock
-- http://tinyvga.com/vga-timing/640x480@60Hz
entity vga_controller is
    port ( 
        clk, rst: in STD_LOGIC;
        hsync, vsync: out STD_LOGIC;
        hc, vc: out STD_LOGIC_VECTOR(9 downto 0);
        vidon: out STD_LOGIC
    );
end vga_controller;

architecture behavioral of vga_controller is

    constant hpixels: STD_LOGIC_VECTOR(9 downto 0)  := "1100100000"; -- 800 pixels for line of pixels
    constant vlines: STD_LOGIC_VECTOR(9 downto 0)   := "1000001101"; -- 525 lines for whole frame of lines
    constant hfporch: STD_LOGIC_VECTOR(9 downto 0)  := "0001110000"; -- 112 (96 sp + 16 fp) length
    constant hbporch: STD_LOGIC_VECTOR(9 downto 0)  := "1100010000"; -- 784 (640 px + 96 sp + 48 bp) length
    constant vfporch: STD_LOGIC_VECTOR(9 downto 0)  := "0000001100"; -- 12 (2 sp + 10 fp) length
    constant vbporch: STD_LOGIC_VECTOR(9 downto 0)  := "1000000011"; -- 515 (480 px + 2 sp + 33 bp) length
    
    signal hcs, vcs: STD_LOGIC_VECTOR(9 downto 0); -- horizontal and vertical counters
    signal vsyncenable: STD_LOGIC; -- video signal enable

begin
    hcounter: process(clk, rst)
    begin
        if rst = '1' then
            hcs <= "0000000000";
        elsif clk'event and clk = '1' then
            if hcs = hpixels - 1 then
                hcs <= "0000000000";
                vsyncenable <= '1'; -- used by vertical counter to see when to increment
            else
                hcs <= hcs + 1;
                vsyncenable <= '0';
            end if;
        end if;
    end process;

    hsync <= '0' when hcs < 96 else '1'; -- gen hsync pulse; pulse is low when 0-95
    
    vcounter: process(clk, rst)
    begin
        if rst = '1' then
            vcs <= "0000000000";
        elsif clk'event and clk = '1' and vsyncenable='1' then
            if vcs = vlines - 1 then
                vcs <= "0000000000";
            else
                vcs <= vcs + 1;
            end if;
        end if;
    end process;
    
    vsync <= '0' when vcs < 2 else '1'; -- gen vsync pulse; pulse is low when 0-1
    
    vidon <= '1' when (((hcs < hbporch) and (hcs >= hfporch))
                    and ((vcs < vbporch) and (vcs >= vfporch))) else '0';   
    hc <= hcs;
    vc <= vcs;

end behavioral;
