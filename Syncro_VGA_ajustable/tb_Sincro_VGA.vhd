----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2024 01:52:17
-- Design Name: 
-- Module Name: tb_Sincro_VGA - Behavioral
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Sincro_VGA is
end tb_Sincro_VGA;

architecture testbench of tb_Sincro_VGA is
  -- Declaración del componente a probar (Unit Under Test - UUT)
  component Sincro_VGA is
    Port (
      clk      : in std_logic;
      rst      : in std_logic;
      hsync    : out std_logic;
      vsync    : out std_logic;
      visible  : out std_logic;
      fila     : out unsigned(9 downto 0);
      col      : out unsigned(9 downto 0)
    );
  end component;

  -- Señales para el testbench
  signal clk      : std_logic := '0';
  signal rst      : std_logic := '1';
  signal hsync    : std_logic;
  signal vsync    : std_logic;
  signal visible  : std_logic;
  signal fila     : unsigned(9 downto 0);
  signal col      : unsigned(9 downto 0);

  -- Periodo del reloj
  constant clk_period : time := 40 ns;  -- Frecuencia de reloj de 25 MHz

begin

  -- Instancia del UUT (Unidad a Probar)
  uut: Sincro_VGA
    Port map (
      clk      => clk,
      rst      => rst,
      hsync    => hsync,
      vsync    => vsync,
      visible  => visible,
      fila     => fila,
      col      => col
    );

  -- Generación del reloj
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process;

  -- Proceso de estímulo
  stimulus_process: process
  begin
    -- Aplicar reset
    rst <= '1';
    wait for 100 ns;  -- Esperar para inicializar el sistema
    rst <= '0';
    
    -- Permitir que la simulación se ejecute un tiempo
    wait for 20 ms;  -- Suficiente tiempo para observar varios cuadros de VGA

    -- Fin de la simulación
    wait;
  end process;

end testbench;

