----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.10.2024 16:00:28
-- Design Name: 
-- Module Name: syncVGA_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity syncVGA_tb is
--  Port ( );
end syncVGA_tb;

architecture Behavioral of syncVGA_tb is
--signal
signal sclk : std_logic := '0';
signal srst : std_logic := '0';
signal sfils :  std_logic_vector(9 downto 0);
signal scols :  std_logic_vector(9 downto 0);
signal sVisible :  std_logic;
signal sHsync:  std_logic;
signal sVsync:  std_logic;
--componet

-- Periodo del reloj
  constant clk_period : time := 40 ns;  -- Frecuencia de reloj de 25 MHz

component sync_vga is
 port (
        clk_25 : in std_logic;
        rst : in std_logic;
        fils : out std_logic_vector(9 downto 0);
        cols : out std_logic_vector(9 downto 0);
        Visible : out std_logic;
        Hsync: out std_logic;
        Vsync: out std_logic
 );
 end component;
 
begin

    syncVGA:sync_vga
     port map (
        clk_25  =>sclk,
        rst     =>srst,
        fils    =>sfils,
        cols    =>scols,
        Visible =>sVisible,
        Hsync   =>shsync,
        Vsync   =>sVsync
 );
 
 -- Generación del reloj
  clk_process : process
  begin
    sclk <= '0';
    wait for clk_period / 2;
    sclk <= '1';
    wait for clk_period / 2;
  end process;

  -- Proceso de estímulo
  stimulus_process: process
  begin
    -- Aplicar reset
    srst <= '1';
    wait for 100 ns;  -- Esperar para inicializar el sistema
    srst <= '0';
    
    -- Permitir que la simulación se ejecute un tiempo
    wait for 20 ms;  -- Suficiente tiempo para observar varios cuadros de VGA

    -- Fin de la simulación
    wait;
  end process;

end Behavioral;
