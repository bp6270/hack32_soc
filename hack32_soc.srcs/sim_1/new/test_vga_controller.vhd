library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity test_vga_controller is
end test_vga_controller;

architecture sim of test_vga_controller is

    component vga_controller
        port ( 
            clk, rst: in STD_LOGIC;
            hsync, vsync: out STD_LOGIC;
            hc, vc: out STD_LOGIC_VECTOR(9 downto 0);
            vidon: out STD_LOGIC
        );
    end component;
    
    signal tclk, trst, thsync, tvsync, tvidon: STD_LOGIC;
    signal thc, tvc: STD_LOGIC_VECTOR(9 downto 0);
    
begin
    dut: vga_controller
        port map(
            clk => tclk, rst => trst,
            hsync => thsync, vsync => tvsync,
            hc => thc, vc => tvc,
            vidon => tvidon
        );
        
        clk_proc: process
        begin
            tclk <= '0';
            wait for 20ns; -- 25 MHz
            tclk <= '1';
            wait for 20ns;
        end process;
        
        controller: process
        begin
            trst <= '1';
            wait for 40ns;
            trst <= '0';
            wait;
        end process;
end sim;
