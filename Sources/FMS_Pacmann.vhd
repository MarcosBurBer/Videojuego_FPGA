----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2024 18:54:44
-- Design Name: 
-- Module Name: FMS_Pacmann - Behavioral
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

entity FMS_Pacmann is
    Port (
        clk        : in std_logic;
        rst        : in std_logic;
        btnUp      : in std_logic;
        btnDown    : in std_logic;
        btnRight   : in std_logic;
        btnLeft    : in std_logic;
        pac_fila   : out unsigned(5 downto 0);
        direccion  : out std_logic_vector(3 downto 0); -- 4 bits para las 8 direcciones (0: Stop, 1: Up, etc.)
        pac_col    : out unsigned(5 downto 0)
    );
end FMS_Pacmann;

architecture Behavioral of FMS_Pacmann is
    signal fila, columna : unsigned(5 downto 0); -- Posición de Pacman
    signal contador : unsigned(26 downto 0); -- Contador para 100 ms
    signal max_valor: unsigned(26 downto 0); -- Tiempo maximo del contador
    signal enable_move : std_logic := '0'; -- Señal que habilita el movimiento
    signal jug_en_pista : STD_LOGIC;
     
begin

       -- Contador para generar un pulso cada 100 ms
    process(clk, rst)
    begin
        if rst = '1' then
            contador <= (others => '0');
            enable_move <= '0';
        elsif rising_edge(clk) then
            if contador = max_valor  then -- Suponiendo un clk de 125 MHz
                contador <= (others => '0');
                enable_move <= '1';
            else
                contador <= contador + 1;
                enable_move <= '0';
            end if;
        end if;
    end process;

    -- Lógica para mover el cuadrado
    process(clk, rst)
    begin
        if rst = '1' then
            fila <= to_unsigned(25,6);        --Inicio en la salida
            columna <= to_unsigned(14,6);
        elsif rising_edge(clk) then
            if enable_move = '1' then
                if btnDown = '1' and fila < 29 then -- límite superior
                    fila <= fila + 1;
                elsif btnUp = '1' and fila > 0 then -- límite inferior
                    fila <= fila - 1;
                end if;

                if btnRight = '1' and columna < 31 then -- límite derecho
                    columna <= columna + 1;
                elsif btnLeft = '1' and columna > 0 then -- límite izquierdo
                    columna <= columna - 1;
                end if;
            end if;
        end if;
    end process;
    
  
-- Lógica para determinar si esta en pista y ajustar la velocidad
    process(clk, rst)
    begin
        if rst = '1' then
            jug_en_pista <= '0';
            max_valor <= to_unsigned(125000000-1,27); --100ms para
        elsif rising_edge(clk) then
           -- if enable_move = '1' then
                -- Consultar la constante "pista" para determinar si está en pista o fuera
                jug_en_pista <= not pista(to_integer(fila))(to_integer(columna));
                
                -- Cambiar el tiempo de avance dependiendo de si está en pista
                if jug_en_pista = '0' then
                  max_valor <= to_unsigned(12500000-1,27);--100ms para
                else
                  max_valor <= to_unsigned(62500000-1,27);--500ms para
                end if;              
         -- end if;                     
        end if;
    end process;
    
    -- Lógica para determinar la dirección del movimiento
    process(btnUp, btnDown, btnLeft, btnRight)
    begin
        if btnUp = '1' and btnRight = '1' then
            direccion <= "0001"; -- Diagonal arriba-derecha
        elsif btnUp = '1' and btnLeft = '1' then
            direccion <= "0010"; -- Diagonal arriba-izquierda
        elsif btnDown = '1' and btnRight = '1' then
            direccion <= "0011"; -- Diagonal abajo-derecha
        elsif btnDown = '1' and btnLeft = '1' then
            direccion <= "0100"; -- Diagonal abajo-izquierda
        elsif btnUp = '1' then
            direccion <= "0101"; -- Arriba
        elsif btnDown = '1' then
            direccion <= "0110"; -- Abajo
        elsif btnRight = '1' then
            direccion <= "0111"; -- Derecha
        elsif btnLeft = '1' then
            direccion <= "1000"; -- Izquierda
        else
            direccion <= "0000"; -- Sin movimiento
        end if;
    end process;
    
    -- Asignación de las posiciones de Pacman a las salidas
   pac_fila <= fila;
   pac_col  <= columna;

end Behavioral;
