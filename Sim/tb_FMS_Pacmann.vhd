----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.12.2024 20:57:40
-- Design Name: 
-- Module Name: tb_FMS_Pacmann - Behavioral
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

entity tb_FMS_Pacmann is
end tb_FMS_Pacmann;

architecture Behavioral of tb_FMS_Pacmann is
    -- Component Declaration
    component FMS_Pacmann
        Port (
            clk        : in std_logic;
            rst        : in std_logic;
            btnUp      : in std_logic;
            btnDown    : in std_logic;
            btnRight   : in std_logic;
            btnLeft    : in std_logic;
            pac_fila   : out unsigned(5 downto 0);
            direccion  : out std_logic_vector(3 downto 0);
            pac_col    : out unsigned(5 downto 0)
        );
    end component;

    -- Testbench Signals
    signal clk         : std_logic := '0';
    signal rst         : std_logic := '0';
    signal btnUp       : std_logic := '0';
    signal btnDown     : std_logic := '0';
    signal btnRight    : std_logic := '0';
    signal btnLeft     : std_logic := '0';
    signal pac_fila    : unsigned(5 downto 0);
    signal direccion   : std_logic_vector(3 downto 0);
    signal pac_col     : unsigned(5 downto 0);

    -- Clock Period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: FMS_Pacmann
        Port map (
            clk        => clk,
            rst        => rst,
            btnUp      => btnUp,
            btnDown    => btnDown,
            btnRight   => btnRight,
            btnLeft    => btnLeft,
            pac_fila   => pac_fila,
            direccion  => direccion,
            pac_col    => pac_col
        );

    -- Clock Process
    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Testbench Process
    stim_proc: process
    begin
        -- Reset the system
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- Move Up
        btnUp <= '1';
        wait for 0.5 ms;
        btnUp <= '0';

        -- Move Down
        btnDown <= '1';
        wait for 0.5 ms;
        btnDown <= '0';

        -- Move Right
        btnRight <= '1';
        wait for 0.5 ms;
        btnRight <= '0';

        -- Move Left
        btnLeft <= '1';
        wait for 0.5 ms;
        btnLeft <= '0';

        -- Diagonal Movement (Up + Right)
        btnUp <= '1';
        btnRight <= '1';
        wait for 0.5 ms;
        btnUp <= '0';
        btnRight <= '0';

        -- Diagonal Movement (Down + Left)
        btnDown <= '1';
        btnLeft <= '1';
        wait for 0.5 ms;
        btnDown <= '0';
        btnLeft <= '0';
        
        -- Diagonal Movement (Up + Left)
        btnUp <= '1';
        btnLeft <= '1';
        wait for 0.5 ms;
        btnUp <= '0';
        btnLeft <= '0';

        -- Diagonal Movement (Down + Right)
        btnDown <= '1';
        btnRight <= '1';
        wait for 0.5 ms;
        --btnDown <= '0';
        --btnRight <= '0';

        -- Stop Simulation
        wait for 100 ms;
        wait;
    end process;
end Behavioral;

