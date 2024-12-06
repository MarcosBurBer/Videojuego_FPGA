----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2024 01:16:16
-- Design Name: 
-- Module Name: Sincro_VGA - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Definición de la entidad del controlador VGA
entity Sincro_VGA is
  Port (
    clk        : in std_logic;               -- Reloj principal del sistema
    rst        : in std_logic;               -- Señal de reinicio
    hsync      : out std_logic;              -- Señal de sincronización horizontal
    vsync      : out std_logic;              -- Señal de sincronización vertical
    visible    : out std_logic;              -- Señal que indica si la posición actual es visible
    fila       : out unsigned(10-1 downto 0);   -- Contador de líneas (filas) en la pantalla
    col        : out unsigned(10-1 downto 0)    -- Contador de píxeles (columnas) en la pantalla
  );
end Sincro_VGA;

architecture Behavioral of Sincro_VGA is

  -- Parámetros de sincronización para la resolución VGA
  constant H_DISPLAY       : integer := 640; -- Ancho de la zona visible en píxeles
  constant H_FRONT         : integer := 16;  -- Porche delantero horizontal en píxeles
  constant H_SYNC          : integer := 96;  -- Duración del pulso de sincronización horizontal en píxeles
  constant H_BACK          : integer := 48;  -- Porche trasero horizontal en píxeles
  constant H_TOTAL         : integer := H_DISPLAY + H_FRONT + H_SYNC + H_BACK; -- Total de píxeles por línea

  constant V_DISPLAY       : integer := 480; -- Altura de la zona visible en líneas
  constant V_FRONT         : integer := 10;   -- Porche delantero vertical en líneas
  constant V_SYNC          : integer := 2;   -- Duración del pulso de sincronización vertical en líneas
  constant V_BACK          : integer := 33;  -- Porche trasero vertical en líneas
  constant V_TOTAL         : integer := V_DISPLAY + V_FRONT + V_SYNC + V_BACK; -- Total de líneas por cuadro

  -- Señales internas utilizadas para la generación de señales de sincronización y visibilidad
  signal cont_clk    : unsigned(1 downto 0) := (others => '0'); -- Contador de ciclos de reloj para generar el pxl_clk
  signal pxl_clk     : std_logic := '0';                        -- Reloj de píxeles (cada 40 ns)
  signal cont_pxl    : unsigned(9 downto 0) := (others => '0'); -- Contador de píxeles (columnas)
  signal cont_line   : unsigned(9 downto 0) := (others => '0'); -- Contador de líneas (filas)
  signal new_pxl     : std_logic := '0';                        -- Señal de nueva línea
  signal new_line    : std_logic := '0';                        -- Señal de nueva pantalla
  signal visible_pxl : std_logic := '0';                        -- Señal de visibilidad en la columna actual
  signal visible_line: std_logic := '0';                        -- Señal de visibilidad en la fila actual
  signal fin_cuenta_pxl: std_logic := '0';                        -- Señal de visibilidad en la fila actual
  signal fin_cuenta_linea: std_logic := '0';                        -- Señal de visibilidad en la fila actual

begin

  -- Proceso P_cont_pxl: Contador de píxeles (columnas)
  P_cont_pxl : process(clk, rst)
  begin
    if rst = '1' then
      cont_pxl <= (others => '0');
      new_pxl <= '0';
    elsif rising_edge(clk) then
      if fin_cuenta_pxl='1' then
        cont_pxl <= (others => '0');
        --new_pxl <= '1'; -- Indicar que se ha completado una línea
      else
        cont_pxl <= cont_pxl + 1;
        --new_pxl <= '0';
      end if;
    end if;
  end process;
  fin_cuenta_pxl <= '1' when  cont_pxl = H_TOTAL - 1 else '0';
  
  -- Señal de visibilidad horizontal (visible_pxl) durante los píxeles visibles
  visible_pxl <= '1' when cont_pxl < H_DISPLAY else '0';
  
   -- Generación de hsync durante el intervalo de sincronización horizontal
   hsync <= '0' when (cont_pxl >= H_DISPLAY + H_FRONT-1 and cont_pxl < H_DISPLAY + H_FRONT + H_SYNC) else '1';

  -- Proceso P_cont_line: Contador de líneas (filas)
  P_cont_line : process(clk, rst)
  begin
    if rst = '1' then
      cont_line <= (others => '0');
      new_line <= '0';
    elsif rising_edge(clk) then
      if fin_cuenta_pxl = '1' then
        if fin_cuenta_linea = '1' then
          cont_line <= (others => '0');
          new_line <= '1'; -- Indicar que se ha completado una pantalla
        else
          cont_line <= cont_line + 1;
          new_line <= '0';
        end if;
      end if;
    end if;
  end process;
  fin_cuenta_linea <= '1' when  cont_line = V_TOTAL - 1 else '0';
  
  -- Señal de visibilidad vertical (visible_line) durante las líneas visibles
  visible_line <= '1' when cont_line < V_DISPLAY else '0';
  
  -- Generación de vsync durante el intervalo de sincronización vertical
  vsync <= '0' when (cont_line >= V_DISPLAY + V_FRONT and cont_line < V_DISPLAY + V_FRONT + V_SYNC) else '1';

  -- Señales de salida de visibilidad, fila y columna
  visible <= visible_pxl and visible_line; -- Indica si el píxel actual está en la región visible
  col <= cont_pxl;                         -- Contador de píxeles (columna actual)
  fila <= cont_line;                       -- Contador de líneas (fila actual)

end Behavioral;





