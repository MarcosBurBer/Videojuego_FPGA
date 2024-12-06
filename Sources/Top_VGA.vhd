----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.10.2024 20:44:03
-- Design Name: 
-- Module Name: Top_VGA - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Top_VGA is
 port (
        btnUp : in std_logic;
        btnDown : in std_logic;
        btnRight : in std_logic;
        btnLeft : in std_logic;
        SW1 : in std_logic;
        SW2 : in std_logic; 
        clk : in std_logic;
        rst : in std_logic;
        datap : out std_logic_vector(2 downto 0);
        dataN : out std_logic_vector(2 downto 0);
        ClkN : out std_logic;
        ClkP: out std_logic
               
);

end Top_VGA;
architecture Behavioral of Top_VGA is

--signals
  signal fant_fila: unsigned (5 downto 0);
  signal fant_col: unsigned (5 downto 0);
  signal pac_fila: unsigned (5 downto 0);
  signal pac_col: unsigned (5 downto 0); 
  signal pos_x: unsigned (5 downto 0);  
  signal pos_y: unsigned (5 downto 0); 
     
   signal vdatargb: std_logic_vector( 23 downto 0 );

   signal filas_s : std_logic_vector(9 downto 0);   
   signal columnas_s : std_logic_vector(9 downto 0);  
   signal Visible_s : std_logic;
   signal Hsync_S:std_logic;  
   signal Vsync_S : std_logic; 

    signal clk_125M:std_logic;
    signal clk_25M:std_logic;
   
    signal addr_s:  std_logic_vector(8-1 downto 0);
    signal dato_s_pac:  std_logic_vector(16-1 downto 0);
    signal dato_s_fant:  std_logic_vector(16-1 downto 0);
    signal dato_s_fant2:  std_logic_vector(16-1 downto 0);
    signal direccion_s  : std_logic_vector(3 downto 0); 
    
    signal addr_s_pista : std_logic_vector(5-1 downto 0);  
    signal verde_p : std_logic_vector(32-1 downto 0);
    signal azul_P : std_logic_vector(32-1 downto 0);
   
    
--components
    --pll
    
        component clock_gen is
            generic (
        CLKIN_PERIOD : real := 8.000; -- input clock period (8ns)
        CLK_MULTIPLY : integer := 8; -- multiplier
        CLK_DIVIDE : integer := 1; -- divider
        CLKOUT0_DIV : integer := 8; -- serial clock divider
        CLKOUT1_DIV : integer := 40 -- pixel clock divider
        );
            port(
        rst: in std_logic;
        clk_i : in std_logic; -- input clock
        clk0_o : out std_logic; -- serial clock
        clk1_o : out std_logic -- pixel clock
        );
        end component;
        
    --SYNC VGA
    
        COMPONENT sync_vga is 
        port (
            clk_25 : in std_logic;
            rst : in std_logic;
            fils : out std_logic_vector(9 downto 0);
            cols : out std_logic_vector(9 downto 0);
            Visible : out std_logic;
            Hsync: out std_logic;
            Vsync: out std_logic
         );
        END component;
    
    --PINTA
    
        component PINTA_Cuadriculas_16x16 is
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
          direccion  : in std_logic_vector(3 downto 0); -- 4 bits para las 8 direcciones (0: Stop, 1: Up, etc.)
          -- Out ports                                       
          addr         : out std_logic_vector(8-1 downto 0); 
          addr_pista   : out std_logic_vector(5-1 downto 0); 
          rojo         : out std_logic_vector(8-1 downto 0);
          verde        : out std_logic_vector(8-1 downto 0);
          azul         : out std_logic_vector(8-1 downto 0)
        );
        end component;
    
    --Movimiwnto PACMAN   
        component FMS_Pacmann is
        Port (
              clk        : in std_logic;
              rst        : in std_logic;
              btnUp      : in std_logic;
              btnDown    : in std_logic;
              btnRight   : in std_logic;
              btnLeft    : in std_logic;
              direccion  : out std_logic_vector(3 downto 0); -- 4 bits para las 8 direcciones (0: Stop, 1: Up, etc.)
              pac_fila : out unsigned(5 downto 0);
              pac_col  : out unsigned(5 downto 0)
        );
        end component;
       
       --Movimiento Fantasma 
        component FMS_Fantasma is
           Port ( clk : in STD_LOGIC;
                  rst : in STD_LOGIC;
                  fant_col : inout unsigned(5 downto 0);  -- columna del fantasma
                  fant_fila : inout unsigned(5 downto 0)  -- fila del fantasma
         );
        end component;
       
       --movimiento del jugador automatico 
        component Jugador_Automatico is
            Port (  clk : in std_logic;               -- Reloj
                    rst : in std_logic;             -- Reinicio
                    SW1 : in std_logic; 
                    SW2 : in std_logic;  -- Control de velocidad (4 niveles)
                    pos_x : out unsigned(5 downto 0); -- Coordenada X del jugador (5 bits: 0 a 31)
                    pos_y : out unsigned(5 downto 0)  -- Coordenada Y del jugador (5 bits: 0 a 31)
         );
        end component;  
         
    --hdmi
    
        component hdmi_rgb2tmds is
        generic (
            SERIES6 : boolean := false
        );
        port(
            -- reset and clocks
            rst : in std_logic;
            pixelclock : in std_logic;  -- slow pixel clock 1x
            serialclock : in std_logic; -- fast serial clock 5x

            -- video signals
            video_data : in std_logic_vector(23 downto 0);
            video_active  : in std_logic;
            hsync : in std_logic;
            vsync : in std_logic;

            -- tmds output ports
            clk_p : out std_logic;
            clk_n : out std_logic;
            data_p : out std_logic_vector(2 downto 0);
            data_n : out std_logic_vector(2 downto 0)
        );
        end component;    
                               
        -- IMAGENES
       
        component ROM1b_1f_imagenes16_16x16_bn is   
           port (
                 clk  : in  std_logic;   -- reloj
                 addr : in  std_logic_vector(8-1 downto 0);
                 dout_pac : out std_logic_vector(16-1 downto 0);
                 dout_fant : out std_logic_vector(16-1 downto 0);
                 dout_fant2 : out std_logic_vector(16-1 downto 0)
               );
        end component;           
        
        -- PISTA
       
        component  ROM1b_1f_green_racetrack_1 is   
           port (
                 clk  : in  std_logic;   -- reloj
                 addr : in  std_logic_vector(5-1 downto 0);
                 dout : out std_logic_vector(32-1 downto 0)
               );
        end component;
        
        component  ROM1b_1f_blue_racetrack_1 is   
            port (
                  clk  : in  std_logic;   -- reloj
                  addr : in  std_logic_vector(5-1 downto 0);
                  dout : out std_logic_vector(32-1 downto 0)
                );
         end component;  
begin

--PLL 
    PLL: clock_gen 
    port map(
    rst =>rst,
    clk_i =>clk , -- input clock
    clk0_o => clk_125M , -- serial clock
    clk1_o => clk_25M   -- pixel clock
    );


--SYNC VGA
        SYNCVGA: sync_vga 
        port MAP (
            clk_25 =>clk_25m,
            rst    =>rst,
            fils   =>filas_s,
            cols   =>columnas_s,
            Visible=> visible_s,
            Hsync  =>hsync_s,
            Vsync  =>vsync_s
         );  
 
 --FMS_Pacmann      
        Controla_Pac: FMS_Pacmann
        Port map (
               clk       => clk_125M,
               rst       => rst,
               btnUp     => btnUp   ,
               btnDown   => btnDown ,
               btnRight  => btnRight,
               btnLeft   => btnLeft ,
               direccion => direccion_s,
               pac_fila => pac_fila,
               pac_col  => pac_col 
        );
        
 --FMS_Fantasma      
     Controla_Fan: FMS_Fantasma
     Port map (
            clk       => clk_125M,
            rst       => rst,
            fant_fila=> fant_fila,
            fant_col => fant_col 
     );
     
 --Jugador_Automatico      
     Automatico: Jugador_Automatico
     Port map (
                clk      => clk_125M,
                rst      => rst,
                SW1      => SW1,
                SW2      => SW2,
                pos_x    => pos_x, 
                pos_y    => pos_y
            
     );
        
--PINTA
        
        PINTAc: PINTA_Cuadriculas_16x16 
        Port map (
          -- In ports
          visible      =>visible_s,
          col          =>unsigned(columnas_s),
          fila         =>unsigned(filas_s),
          pac_fila   => pac_fila,
          pac_col    => pac_col ,
          fant_col  => fant_col ,
          fant_fila => fant_fila,
          pos_x     => pos_x,
          pos_y     => pos_y,
          dato_pac      => dato_s_pac,
          dato_fant => dato_s_fant,
          dato_fant2 => dato_s_fant2,
          dato_pista_verde    => verde_P,
          dato_pista_azul    => azul_p,
          direccion => direccion_s,
          --Out ports         
          addr      => addr_s,
          addr_pista   => addr_s_pista,
          rojo         =>Vdatargb(23 downto 16),
          verde        =>Vdatargb(15 downto 8),
          azul         =>Vdatargb(7 downto 0)
        );

   
  --hdmi
         HDMI:hdmi_rgb2tmds 
        port map(
            -- reset and clocks
            rst        =>rst,
            pixelclock =>clk_25m, -- slow pixel clock 1x
            serialclock=>clk_125m,-- fast serial clock 5x

            -- video signals
            video_data   =>VdataRGB,
            video_active =>visible_S,
            hsync        =>hsync_s,
            vsync        =>vsync_s,

            -- tmds output ports
            clk_p  =>clkP,
            clk_n  =>clkN,
            data_p =>dataP,
            data_n =>dataN
        );
                    
  IMAGENES: ROM1b_1f_imagenes16_16x16_bn
      port map ( 
              clk   => clk,
              addr  => addr_s,
              dout_pac  => dato_s_pac,
              dout_fant => dato_s_fant,
              dout_fant2 => dato_s_fant2
                    );
                    
  PISTA_G: ROM1b_1f_green_racetrack_1
      port map ( 
              clk   => clk,
              addr  => addr_s_pista ,
              dout  => verde_P 
                    );

    PISTA_B: ROM1b_1f_blue_racetrack_1
      port map ( 
              clk   => clk,
              addr  => addr_s_pista ,
              dout  => azul_P 
                    );             

end Behavioral;
