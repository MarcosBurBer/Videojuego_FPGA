----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.11.2024 20:15:10
-- Design Name: 
-- Module Name: PINTA_Cuadriculas_16x16 - Behavioral
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

entity PINTA_Cuadriculas_16x16 is
        Port (
          -- In ports
          visible      : in std_logic;
          col          : in unsigned(10-1 downto 0);
          fila         : in unsigned(10-1 downto 0);
          pac_fila     : in unsigned(5 downto 0);  -- Entrada para posición de fila del cuadrado
          pac_col      : in unsigned(5 downto 0);  -- Entrada para posición de columna del cuadrado      
          fant_col     : in unsigned(5 downto 0);
          fant_fila    : in unsigned(5 downto 0);
          pos_x        : in unsigned (5 downto 0);
          pos_y        : in unsigned (5 downto 0);
          dato_pac         : in std_logic_vector(16-1 downto 0); 
          dato_fant    : in std_logic_vector(16-1 downto 0);
          dato_fant2    : in std_logic_vector(16-1 downto 0);
          dato_pista_verde   : in std_logic_vector(32-1 downto 0);
          dato_pista_azul   : in std_logic_vector(32-1 downto 0);
          direccion: in std_logic_vector(3 downto 0);            --Determina la posicion del sprite
          -- Out ports                                       
          addr         : out std_logic_vector(8-1 downto 0); 
          addr_pista   : out std_logic_vector(5-1 downto 0); 
          rojo         : out std_logic_vector(8-1 downto 0);
          verde        : out std_logic_vector(8-1 downto 0);
          azul         : out std_logic_vector(8-1 downto 0)
        );
end PINTA_Cuadriculas_16x16;

architecture Behavioral of PINTA_Cuadriculas_16x16 is
    -- Señales internas
    signal cuad_fil           : unsigned(5 downto 0);            -- Fila de la cuadrícula
    signal cuad_col           : unsigned(5 downto 0);            -- Columna de la cuadrícula
    signal int_horizontal     : unsigned(3 downto 0);            -- Coordenada interna (horizontal)
    signal int_vertical       : unsigned(3 downto 0);            -- Coordenada interna (vertical)
    signal select_dato_memo   : unsigned(3 downto 0);            -- Selecciona el dato en memoria dependiendo de la posicion del sprite
    
    signal direccion_pacman   : std_logic_vector(8-1 downto 0); -- Dirección de memoria para Pac-Man
    signal direccion_fantasma : std_logic_vector(8-1 downto 0); -- Dirección de memoria para el fantasma
    signal direccion_fantasma2 : std_logic_vector(8-1 downto 0); -- Dirección de memoria para el fantasma
    --signal direccion          : std_logic_vector(8-1 downto 0); -- Dirección seleccionada
    
    signal sel_pixel_pac      : std_logic;                       -- Selección de píxel de Pac-Man
    signal sel_pixel_fant     : std_logic;                       -- Selección de píxel del fantasma
    signal sel_pixel_fant2     : std_logic;                       -- Selección de píxel del fantasma2
    signal sel_pixel_pista   : std_logic;                        -- Selección de píxel de la pista
    
    signal verde_P, azul_P :std_logic;
    signal sel_color   : std_logic_vector(1 downto 0);
    
begin
    -- Calcular cuadrícula y posición interna
    cuad_fil       <= fila(9 downto 4);     -- Bits más significativos para obtener la fila
    cuad_col       <= col(9 downto 4);      -- Bits más significativos para obtener la columna
    int_horizontal <= fila(3 downto 0);     -- Bits menos significativos: coordenada interna horizontal
    int_vertical   <= col(3 downto 0);      -- Bits menos significativos: coordenada interna vertical

    -- Proceso para generar las direcciones de memoria de las imagenes
    P_direccion_memoria: Process (fila, col, cuad_fil, cuad_col,direccion)
    begin
        -- Dirección de Pac-Man
        if cuad_fil = pac_fila and cuad_col = pac_col then
        case direccion is
          when "0101" => -- Arriba (sin cambio)
            direccion_pacman <= "1110" & std_logic_vector(fila(3 downto 0)); 
            select_dato_memo <= int_vertical;
          when "0110" => -- Abajo (Invierto filas)
            direccion_pacman <= "1110" & std_logic_vector(not(fila(3 downto 0))); 
            select_dato_memo <= int_vertical;
          when "0111" => -- Derecha (Cambio filas por columnas e invierto)
            direccion_pacman <= "1110" &  std_logic_vector(not(col(3 downto 0))) ;
            select_dato_memo <= int_horizontal;
          when "1000" => -- Izquierda (Cambio filas por columnas)
            direccion_pacman <= "1110" & std_logic_vector(col(3 downto 0));
            select_dato_memo <= int_horizontal;
          when "0010" => -- Diagonal arriba-izquierda (sin cambio)
            direccion_pacman <= "1111" & std_logic_vector(fila(3 downto 0)); 
            select_dato_memo <= int_vertical;
          when "0100" => -- Diagonal abajo-izquierda (Invierto filas)
            direccion_pacman <= "1111" & std_logic_vector(not(fila(3 downto 0))); 
            select_dato_memo <= int_vertical;
          when "0011" => -- Diagonal abajo-derecha (Cambio filas por columnas)
            direccion_pacman <= "1111" & std_logic_vector(col(3 downto 0));
            select_dato_memo <= int_horizontal; 
          when "0001" => -- Diagonal arriba-derecha (Intercambio filas por columnas e invierto)
            direccion_pacman <= "1111" & std_logic_vector(not(col(3 downto 0)));
            select_dato_memo <= int_horizontal; 
          when others => -- Empieza mirando a la derecha
            direccion_pacman <= "1110" &  std_logic_vector(not(col(3 downto 0)));
            select_dato_memo <= int_horizontal;
        end case;
        else
            direccion_pacman <= (others => '0'); -- No válida si no estamos en Pac-Man
        end if;

        -- Dirección del fantasma
        if cuad_fil = fant_fila and cuad_col = fant_col then
            direccion_fantasma <= "0100" & std_logic_vector(fila(3 downto 0)); -- Bits menos significativos
        else
            direccion_fantasma <= (others => '0'); -- No válida si no estamos en el fantasma
        end if;
   
        -- Dirección del fantasma
        if cuad_fil = pos_x and cuad_col = pos_y then
            direccion_fantasma2 <= "0101" & std_logic_vector(fila(3 downto 0)); -- Bits menos significativos
        else
            direccion_fantasma2 <= (others => '0'); -- No válida si no estamos en el fantasma
        end if;
    end process;

    -- Selección de la dirección en función del personaje
    addr <= direccion_pacman when cuad_fil = pac_fila and cuad_col = pac_col else
            direccion_fantasma when cuad_fil = fant_fila and cuad_col = fant_col else
            direccion_fantasma2; 

    -- Señales para determinar si un píxel pertenece a Pac-Man o al fantasma
    sel_pixel_pac  <= '1' when dato_pac(to_integer(select_dato_memo))= '0' and cuad_fil = pac_fila and cuad_col = pac_col else '0';
    sel_pixel_fant <= '1' when dato_fant(to_integer(int_vertical)) = '0' and cuad_fil = fant_fila and cuad_col = fant_col else '0';
    sel_pixel_fant2 <= '1' when dato_fant2(to_integer(int_vertical)) = '0' and cuad_fil = pos_x and cuad_col = pos_y else '0';
    
    --pintamos el mapa                             
    addr_pista <= std_logic_vector (cuad_fil(4 downto 0));          
    verde_P <= dato_pista_verde(to_integer(cuad_col(5 downto 0)));
    azul_P <= dato_pista_azul(to_integer(cuad_col(5 downto 0)));
    
    sel_color <= verde_P & azul_P;


    -- Selección de colores según prioridades
    -- Lógica para determinar los colores
    Process (visible, col, fila)
    begin
        -- Inicializamos los valores en negro
        rojo  <= (others => '0');
        verde <= (others => '0');
        azul  <= (others => '0');
     
        if visible = '1' then
           -- Condición para pintar la pista
                if col >= 512 then
                   rojo  <= (others => '0');
                   verde <= (others => '0');
                   azul  <= (others => '0');
                 else
                     case (sel_color) is
                        when "00" => -- Borde de la pista (rojo)
                            rojo  <=(others => '1');
                            verde <=(others => '0');
                            azul  <=(others => '0');
                        when "01" => -- Línea de meta (azul)
                            rojo  <= (others => '0');
                            verde <= (others => '0');
                            azul  <= (others => '1');
                        when "10" => -- Hierba (verde)
                            rojo   <=(others =>  '0');
                            verde  <=(others =>  '1');
                            azul   <=(others =>  '0');
                        when "11" => -- Pista (blanco)
                            rojo  <= (others => '1');
                            verde <= (others => '1');
                            azul  <= (others => '1');
                        when others =>
                            rojo  <=(others => '0');
                            verde <=(others => '0');
                            azul  <=(others => '0'); -- Color por defecto
                    end case;                                                                 
             -- Condición para pintar el cuadrado en la posición especificada
                if sel_pixel_fant = '1' then
                    rojo <= (others => '1');
                    verde <=(others => '0');
                    azul <= (others => '1'); -- Color rosa para el fantasma 1
                end if;     
                                          
            -- Condición para pintar el cuadrado en la posición especificada
                if sel_pixel_fant2 = '1' then
                    rojo <= (others => '0'); -- Color celeste para el fantasma 2
                    verde <=(others => '1');
                    azul <= (others => '1');
                end if;  
               
           -- Condición para pintar el cuadrado en la posición especificada
              if sel_pixel_pac = '1' then
                  rojo <= (others => '0'); -- Color negro para el pacman (coche)
                  verde <=(others => '0');
                  azul <= (others => '0');
              end if;     
                    
        end if;    
       end if; 
          
    end process;
end Behavioral;





