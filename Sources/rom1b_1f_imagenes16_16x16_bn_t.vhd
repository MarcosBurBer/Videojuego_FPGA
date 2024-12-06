------- ROM creada automaticamente por ppm2rom -----------
------- Felipe Machado -----------------------------------
------- Departamento de Tecnologia Electronica -----------
------- Universidad Rey Juan Carlos ----------------------
------- http://gtebim.es ---------------------------------
----------------------------------------------------------
--------Datos de la imagen -------------------------------
--- Fichero original    : imagenes16_16x16_bn.pbm 
--- Filas    : 256 
--- Columnas : 16 
--- Color    :  Blanco y negro. 2 niveles (1 bit)



------ Puertos -------------------------------------------
-- Entradas ----------------------------------------------
--    clk  :  senal de reloj
--    addr :  direccion de la memoria
-- Salidas  ----------------------------------------------
--    dout :  dato de 16 bits de la direccion addr (un ciclo despues)


library IEEE;
  use IEEE.STD_LOGIC_1164.ALL;
  use IEEE.NUMERIC_STD.ALL;


entity ROM1b_1f_imagenes16_16x16_bn is
  port (
    clk  : in  std_logic;   -- reloj
    addr : in  std_logic_vector(8-1 downto 0);
    dout_pac : out std_logic_vector(16-1 downto 0);
    dout_fant : out std_logic_vector(16-1 downto 0); 
    dout_fant2 : out std_logic_vector(16-1 downto 0)
  );
end ROM1b_1f_imagenes16_16x16_bn;


architecture BEHAVIORAL of ROM1b_1f_imagenes16_16x16_bn is
  signal addr_int  : natural range 0 to 2**8-1;
  type memostruct is array (natural range<>) of std_logic_vector(16-1 downto 0);
  constant filaimg : memostruct := (
       "1111100000111111",
       "1111000000000111",
       "1111000110111111",
       "1110101110111111",
       "1110100111011111",
       "1110011110000111",
       "1111111111111111",
       "1111000000111111",
       "1110000000000111",
       "1100000000000011",
       "1111001001001111",
       "1111100000011111",
       "1111000000001111",
       "1111000110001111",
       "1110001111000111",
       "1100001111000011",
       "1111100000111111",
       "1111000000000111",
       "1111000110110001",
       "1110101110111001",
       "1110100111011101",
       "1110011110000011",
       "1111111111110011",
       "1100000000000110",
       "1100000000001100",
       "1110000000010000",
       "1111000010000000",
       "1100000000000000",
       "1000000000011111",
       "1001111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111100000011111",
       "1111100000011111",
       "1000010110100001",
       "1000110110110001",
       "1100001111000011",
       "1100000110000011",
       "1100010000100011",
       "1110011111100111",
       "0110000000000110",
       "0011000000001100",
       "0000000000000000",
       "0000001001000000",
       "0000000000000000",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111111111111111",
       "1111110000011111",
       "1111000000000111",
       "1110000100000011",
       "1110000000000011",
       "1100000000001111",
       "1100000001111111",
       "1100001111111111",
       "1100000001111111",
       "1100000000001111",
       "1110000000000011",
       "1110000000000011",
       "1111000000000111",
       "1111110000011111",
       "1111111111111111",
       "1111111111111111",
       "1111110000111111",
       "1111000000001111",
       "1110000000000111",
       "1101100001100011",
       "1111110011110011",
       "1100110000110011",
       "1000110000110001",
       "1001100001100001",
       "1000000000000001",
       "1000000000000001",
       "1000000000000001",
       "1000000000000001",
       "1001000110001001",
       "1011100110011101",
       "1111111111111111",
       "1111111111111111",
       "1111110000111111",
       "1111000000001111",
       "1110000000000111",
       "1100000000000011",
       "1100000000000011",
       "1100011001100011",
       "1000011001100001",
       "1000000000000001",
       "1000000000000001",
       "1001100110011001",
       "1010011001100101",
       "1000000000000001",
       "1001000110001001",
       "1011100110011101",
       "1111111111111111",
       "1111110001001111",
       "1111100000000011",
       "1111000110000001",
       "1110001101101000",
       "1111111011101100",
       "1111110111011101",
       "1110000111011111",
       "1100000010000111",
       "1000000100000011",
       "1000001000000001",
       "1001001000000001",
       "1000101001000001",
       "1100001000100001",
       "1110000100000011",
       "1111111110000111",
       "1111111111111111",
       "1111111101111111",
       "1111000000000111",
       "1110000000000011",
       "1100000000001011",
       "1000001000000001",
       "1000100000010001",
       "1000000000000001",
       "1000010010010001",
       "1100000000000011",
       "1100010000000011",
       "1110000001000111",
       "1111000100000111",
       "1111100000001111",
       "1111110000011111",
       "1111111000111111",
       "1111111111111111",
       "1111000000001111",
       "1110000000000111",
       "1100000000000011",
       "1100001110000011",
       "1100011110000011",
       "1100011110100011",
       "1100011100100011",
       "1100011101100011",
       "1100011001100011",
       "1100011011100011",
       "1100010011100011",
       "1100000111100011",
       "1100000111000011",
       "1100000000000011",
       "1110000000000111",
       "1111000000001111",
       "1111110000111111",
       "1111110000111111",
       "1111000000111111",
       "1111000000111111",
       "1100000000111111",
       "1100000000111111",
       "1111110000111111",
       "1111110000111111",
       "1111110000111111",
       "1111110000111111",
       "1111110000111111",
       "1111110000111111",
       "1100000000000011",
       "1100000000000011",
       "1100000000000011",
       "1100000000000011",
       "1111000000001111",
       "1111000000001111",
       "1100000000000011",
       "1100000000000011",
       "1111111111000011",
       "1111111111000011",
       "1111000000000011",
       "1111000000000011",
       "1100000000000011",
       "1100000000000011",
       "1100001111111111",
       "1100001111111111",
       "1100000000000011",
       "1100000000000011",
       "1100000000000011",
       "1100000000000011",
       "1111000000001111",
       "1111000000001111",
       "1100000000000011",
       "1100000000000011",
       "1111111111000011",
       "1111111111000011",
       "1111110000000011",
       "1111110000000011",
       "1111110000000011",
       "1111110000000011",
       "1111111111000011",
       "1111111111000011",
       "1100000000000011",
       "1100000000000011",
       "1111000000001111",
       "1111000000001111",
       "1111001111111111",
       "1111001111111111",
       "1100001111111111",
       "1100001111111111",
       "1100001111000011",
       "1100001111000011",
       "1100001111000011",
       "1100001111000011",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1100000000000000",
       "1111111111000011",
       "1111111111000011",
       "1111111111000011",
       "1111111111000011",
       "1100000000000011",
       "1100000000000011",
       "1100000000000011",
       "1100000000000011",
       "1100001111111111",
       "1100001111111111",
       "1100000000001111",
       "1100000000001111",
       "1100000000000011",
       "1100000000000011",
       "1111111111000011",
       "1111111111000011",
       "1100000000000011",
       "1100000000000011",
       "1111000000001111",
       "1111000000001111",
       "1111111111111111",
       "1111111111111111",
       "1110011111100111",
       "1110000000000111",
       "1110000000000111",
       "1110011001100111",
       "1111111001111111",
       "1111110000111111",
       "1111110000111111",
       "1111100000011111",
       "1100100000010011",
       "1100000000000011",
       "1100000000000011",
       "1100100000010011",
       "1111111111111111",
       "1111111111111111",
       "1111111110111111",
       "1111111100011111",
       "1111111000011111",
       "1111111100001111",
       "1111111110000111",
       "1110111110000001",
       "1100011100000000",
       "1000110000110001",
       "0000000001111011",
       "0000000001111111",
       "1100000011111111",
       "1110000010111111",
       "1111000000011111",
       "1111100000111111",
       "1111110001111111",
       "1111110011111111"
        );

begin

  addr_int <= TO_INTEGER(unsigned(addr));

  P_ROM: process (clk)
  begin
    if clk'event and clk='1' then
      dout_pac <= filaimg(addr_int);
      dout_fant <= filaimg(addr_int);
      dout_fant2 <= filaimg(addr_int);
    end if;
  end process;

end BEHAVIORAL;

