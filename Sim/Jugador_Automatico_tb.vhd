----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2024 13:44:02
-- Design Name: 
-- Module Name: Jugador_Automatico_tb - Behavioral
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
use WORK.RACETRACK_PKG.ALL; -- Incluye la pista

entity tb_jugador_automatico is
    -- El testbench no tiene puertos
end tb_jugador_automatico;

architecture Behavioral of tb_jugador_automatico is
    -- Componentes del DUT
    component jugador_automatico
        Port (
            clk : in std_logic;
            rst : in std_logic;
            SW1 : in std_logic; 
            SW2 : in std_logic;  -- Control de velocidad (4 niveles)
            pos_x : out unsigned(5 downto 0);
            pos_y : out unsigned(5 downto 0)
        );
    end component;

    -- Señales del testbench
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal SW1 : std_logic;
    signal SW2 : std_logic;
    signal pos_x : unsigned(5 downto 0);
    signal pos_y : unsigned(5 downto 0);

    -- Constante para la frecuencia del reloj (10 ns de periodo)
    constant clk_period : time := 10 ns;

begin
    -- Instancia del DUT
    DUT: jugador_automatico
        Port map (
            clk => clk,
            rst => rst,
            SW1 => SW1,
            SW2 => SW2,
            pos_x => pos_x,
            pos_y => pos_y
        );

    -- Generador de reloj
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    

    -- Prueba de giro a la izquierda
    stimulus_process: process
    begin
        -- Reinicio inicial
        rst <= '1';
        wait for clk_period * 2;
        rst <= '0';

        -- Establecer velocidad media
        SW1 <= '1';
        SW2 <= '1';
        -- Dejar que el jugador avance en la pista
        wait for 0.2 ms;

        -- Verificar que el jugador gire a la izquierda en una zona roja
        wait for clk_period * 100;
        -- Establecer velocidad media
        SW1 <= '1';
        SW2 <= '0';
        -- Dejar que el jugador avance en la pista
        wait for 0.2 ms;

        -- Verificar que el jugador gire a la izquierda en una zona roja
        wait for clk_period * 10;
        
        -- Establecer velocidad media
        SW1 <= '0';
        SW2 <= '1';
        -- Dejar que el jugador avance en la pista
        wait for 0.2 ms;

        -- Verificar que el jugador gire a la izquierda en una zona roja
        wait for clk_period * 10;
        -- Finalizar simulación
        wait;
    end process;

end Behavioral;
