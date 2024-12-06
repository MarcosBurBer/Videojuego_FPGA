----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2024 13:19:35
-- Design Name: 
-- Module Name: Jugador_Automatico - Behavioral
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

entity Jugador_Automatico is
    Port (
        clk : in std_logic;               -- Reloj
        rst : in std_logic;               -- Reinicio
        SW1 : in std_logic; 
        SW2 : in std_logic;               -- Control de velocidad (4 niveles)
        pos_x : out unsigned(5 downto 0); -- Coordenada X del jugador
        pos_y : out unsigned(5 downto 0)  -- Coordenada Y del jugador
    );
end Jugador_Automatico;

architecture Behavioral of Jugador_Automatico is

    -- Señales internas
    signal fila, columna : unsigned(5 downto 0); -- Posición actual
    signal fila_sig, columna_sig : unsigned(5 downto 0); -- Posición siguiente
    signal contador : unsigned(26 downto 0); -- Contador para control de velocidad
    signal max_valor: unsigned(26 downto 0); -- Tiempo máximo del contador
    signal sel_switch: std_logic_vector(1 downto 0);
    signal enable_move : std_logic := '0'; -- Habilita movimiento

    -- Máquina de estados
    type state_type is (derecha,arriba,izquierda, abajo);
    signal current_state, next_state : state_type;

begin 

    -- Contador para control de velocidad y enable_move
    process(clk, rst)
    begin
        if rst = '1' then
            contador <= (others => '0');
            enable_move <= '0';
        elsif rising_edge(clk) then
            if contador = max_valor then
                contador <= (others => '0');
                enable_move <= '1';
            else
                contador <= contador + 1;
                enable_move <= '0';
            end if;
        end if;
    end process;

    -- FSM secuencial: actualiza estados y posiciones
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= derecha;
            fila <= to_unsigned(27, 6);    -- Posición inicial
            columna <= to_unsigned(15, 6); -- Posición inicial
        elsif rising_edge(clk) then
            if enable_move = '1' then
                current_state <= next_state;
                fila <= fila_sig;
                columna <= columna_sig;
            end if;
        end if;
    end process;

    -- FSM combinacional: lógica de transición y movimiento
    process(current_state, fila, columna)
    begin
        -- Valores por defecto
        fila_sig <= fila;
        columna_sig <= columna;
        next_state <= current_state;

        case current_state is
            -- Movimiento hacia la derecha
            when derecha =>
                if pista(to_integer(fila))(to_integer(columna + 1)) = '1' and pista(to_integer(fila+1))(to_integer(columna)) = '0' then
                    columna_sig <= columna + 1; -- Mover una casilla a la derecha
                end if;
                if pista(to_integer(fila))(to_integer(columna + 1)) = '0' and pista(to_integer(fila+1))(to_integer(columna)) = '0' then
                    fila_sig <= fila - 1;
                    next_state <= arriba;
                end if;
                if pista(to_integer(fila+1))(to_integer(columna)) = '0' and pista(to_integer(fila))(to_integer(columna-1)) = '0' then
                    columna_sig <= columna + 1; -- Mover una casilla a la derecha
                    next_state <= derecha;
                end if;
                if pista(to_integer(fila+1))(to_integer(columna)) = '1' and pista(to_integer(fila))(to_integer(columna-1)) = '1' then
                    fila_sig <= fila + 1; -- Subir una abajo
                    next_state <= abajo;
                end if;

            -- Movimiento hacia arriba
            when arriba =>
                 if pista(to_integer(fila - 1))(to_integer(columna)) = '1' and pista(to_integer(fila))(to_integer(columna+1)) = '1' then
                    columna_sig <= columna + 1; --derecha
                    next_state <= derecha;
                 end if;
                 if pista(to_integer(fila - 1))(to_integer(columna)) = '1' and pista(to_integer(fila))(to_integer(columna+1)) = '0' then 
                    fila_sig <= fila - 1; -- Subir una casilla
                 end if;
                 if pista(to_integer(fila - 1))(to_integer(columna)) = '0' and pista(to_integer(fila))(to_integer(columna+1)) = '0' then
                    columna_sig <= columna - 1;--izquierda
                    next_state <= izquierda;
                 end if; 
                                 
                 

         

            -- Movimiento hacia la izquierda
            when izquierda =>
                if pista(to_integer(fila-1))(to_integer(columna)) = '1'and pista(to_integer(fila))(to_integer(columna-1)) = '1' then
                    fila_sig <= fila - 1; -- Subir una casilla
                    next_state <= arriba;
                end if;
                if pista(to_integer(fila-1))(to_integer(columna)) = '0'and pista(to_integer(fila))(to_integer(columna-1)) = '1' then
                    columna_sig <= columna - 1; -- Mover a la izquierda
                end if; 
                if pista(to_integer(fila-1))(to_integer(columna)) = '0'and pista(to_integer(fila))(to_integer(columna-1)) = '0' then
                   fila_sig <= fila + 1; -- Mover hacia abajo
                   next_state <= abajo;
                end if; 
                

          
            -- Movimiento hacia abajo
            when abajo =>
                if pista(to_integer(fila+1))(to_integer(columna)) = '1' and pista(to_integer(fila))(to_integer(columna-1)) = '0' then
                   fila_sig <= fila + 1;  -- Mover hacia abajo
                  -- next_state <= abajo;
                   
                end if;
                if pista(to_integer(fila+1))(to_integer(columna)) = '0' and pista(to_integer(fila))(to_integer(columna-1)) = '0' then
                   columna_sig <= columna + 1; --derecha  
                    next_state <= derecha;
                end if;
                if pista(to_integer(fila+1))(to_integer(columna)) = '1' and pista(to_integer(fila))(to_integer(columna-1)) = '1' then
                    columna_sig <= columna - 1; -- Mover a la izquierda
                    next_state <= izquierda;
                end if;
                

          
        end case;
    end process;

    -- Control de velocidad según los interruptores SW1 y SW2
    sel_switch <= SW1 & SW2;

    process(clk, rst)
    begin
        if rst = '1' then
            max_valor <= to_unsigned(125000000-1, 27); -- 100ms por defecto
        elsif rising_edge(clk) then
            case sel_switch is
                when "00" => max_valor <= to_unsigned(62500000-1, 27); -- 500ms
                when "01" => max_valor <= to_unsigned(12500000-1, 27); -- 100ms
                when "10" => max_valor <= to_unsigned(6250000-1, 27);  -- 50ms
                when "11" => max_valor <= to_unsigned(1250000-1, 27);  -- 10ms
                when others => max_valor <= to_unsigned(12500000-1, 27); -- Valor por defecto
            end case;
        end if;
    end process;

    -- Asignación de las posiciones a las salidas
    pos_x <= fila;
    pos_y <= columna;

end Behavioral;

