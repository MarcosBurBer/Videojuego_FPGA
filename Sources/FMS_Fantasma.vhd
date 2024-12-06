----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2024 18:43:41
-- Design Name: 
-- Module Name: FMS_Fantasma - Behavioral
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

entity FMS_Fantasma is
    Port ( clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           fant_col : out unsigned(5 downto 0);
           fant_fila : out unsigned(5 downto 0)
         );
end FMS_Fantasma;

architecture Behavioral of FMS_Fantasma is
    type Estados_Fantasma is (UP_RIGHT, DOWN_RIGHT, UP_LEFT, DOWN_LEFT);
    signal e_actual, e_sig : Estados_Fantasma;
    signal contador_500ms : unsigned(26 downto 0) := (others => '0');
    signal enable_move : std_logic := '0';
    signal fila, columna : unsigned(5 downto 0) := (others => '0');

    constant MAX_FILA    : unsigned(5 downto 0) := to_unsigned(29, 6);
    constant MAX_COLUMNA : unsigned(5 downto 0) := to_unsigned(31, 6);
    constant MIN_FILA    : unsigned(5 downto 0) := to_unsigned(0, 6);
    constant MIN_COLUMNA : unsigned(5 downto 0) := to_unsigned(0, 6);
begin

    -- Generación de `enable_move`
    process(clk, rst)
    begin
        if rst = '1' then
            contador_500ms <= (others => '0');
            enable_move <= '0';
        elsif rising_edge(clk) then
            if contador_500ms = 12_499_999 - 1 then -- 100 ms
                contador_500ms <= (others => '0');
                enable_move <= '1';
            else
                contador_500ms <= contador_500ms + 1;
                enable_move <= '0';
            end if;
        end if;
    end process;

    -- FSM Secuencial
    process(clk, rst)
    begin
        if rst = '1' then
            e_actual <= DOWN_RIGHT;
            fila <= to_unsigned(15, 6);
            columna <= (others => '0');
        elsif rising_edge(clk) then
            if enable_move = '1' then
                e_actual <= e_sig;

                -- Actualización de posición con verificación de límites
                case e_actual is
                    when UP_RIGHT =>
                        if fila > MIN_FILA then fila <= fila - 1; end if;
                        if columna < MAX_COLUMNA then columna <= columna + 1; end if;
                    when DOWN_RIGHT =>
                        if fila < MAX_FILA then fila <= fila + 1; end if;
                        if columna < MAX_COLUMNA then columna <= columna + 1; end if;
                    when UP_LEFT =>
                        if fila > MIN_FILA then fila <= fila - 1; end if;
                        if columna > MIN_COLUMNA then columna <= columna - 1; end if;
                    when DOWN_LEFT =>
                        if fila < MAX_FILA then fila <= fila + 1; end if;
                        if columna > MIN_COLUMNA then columna <= columna - 1; end if;
                end case;
            end if;
        end if;
    end process;

    -- FSM Combinacional
    process(e_actual, fila, columna)
    begin
        case e_actual is
            when DOWN_RIGHT =>
                if fila = MAX_FILA and columna = MAX_COLUMNA then
                    e_sig <= UP_LEFT;
                elsif fila = MAX_FILA then  -- Limite inferior
                    e_sig <= UP_RIGHT;
                elsif columna = MAX_COLUMNA then  --Limite derecho
                    e_sig <= DOWN_LEFT;
                else
                    e_sig <= DOWN_RIGHT;
                end if;

            when UP_RIGHT =>
                if fila = MIN_FILA and columna = MAX_COLUMNA then
                    e_sig <= DOWN_LEFT;
                elsif fila = MIN_FILA then  --Limite superior
                    e_sig <= DOWN_RIGHT;
                elsif columna = MAX_COLUMNA then  --Limite derecho
                    e_sig <= UP_LEFT;
                else
                    e_sig <= UP_RIGHT;
                end if;

            when UP_LEFT =>
                if fila = MIN_FILA and columna = MIN_COLUMNA then
                    e_sig <= DOWN_RIGHT;
                elsif fila = MIN_FILA then  --Limite superior
                    e_sig <= DOWN_LEFT;
                elsif columna = MIN_COLUMNA then  --Limite izquierdo
                    e_sig <= UP_RIGHT;
                else
                    e_sig <= UP_LEFT;
                end if;

            when DOWN_LEFT =>
                if fila = MAX_FILA and columna = MIN_COLUMNA then
                    e_sig <= UP_RIGHT;
                elsif fila = MAX_FILA then  --Limite superior
                    e_sig <= UP_LEFT;
                elsif columna = MIN_COLUMNA then  --Limite derecho
                    e_sig <= DOWN_RIGHT;
                else
                    e_sig <= DOWN_LEFT;
                end if;
        end case;
    end process;

    -- Salidas
    fant_fila <= fila;
    fant_col <= columna;

end Behavioral;

