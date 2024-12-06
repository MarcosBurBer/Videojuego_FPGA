----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.11.2024 17:50:20
-- Design Name: 
-- Module Name: FMS_Fantasma_tb - Behavioral
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity FMS_Fantasma_tb is
--  Port ( );
end FMS_Fantasma_tb;

architecture Behavioral of FMS_Fantasma_tb is
    
    signal  clk_s      : STD_LOGIC;            
    signal rst_s      : STD_LOGIC;            
    signal fant_col_s  :  unsigned(5 downto 0);
    signal fant_fila_s : unsigned(5 downto 0);


component FMS_Fantasma is
    Port ( clk      : in STD_LOGIC;
           rst      : in STD_LOGIC;
           fant_col : out unsigned(5 downto 0);  -- columna del fantasma
           fant_fila : out unsigned(5 downto 0)  -- fila del fantasma
         );
end component;

begin

T1: FMS_Fantasma 
port map (            
            clk       =>  clk_s     ,
            rst       => rst_s      ,
            fant_col  => fant_col_s ,
            fant_fila => fant_fila_s      

);

-- Generación del reloj
    clk_process : process
    begin
        while true loop
            clk_s <= '0';
            wait for 10 ns;  -- Tiempo en estado bajo
            clk_s <= '1';
            wait for 10 ns;  -- Tiempo en estado alto
        end loop;
    end process;

        rst_s <= '1','0' after 20ns;
         
         
        --BTN3_s <= '1','0' after 20ns, '1' after 50ns, '0' after 150ns, '1' after 450ns,'0' after 550ns,'1' after 650ns;

end Behavioral;
