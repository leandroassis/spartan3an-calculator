----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:44:22 07/08/2022 
-- Design Name: 
-- Module Name:    modulo_multiplicador - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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

entity modulo_multiplicador is
	port(
		DIGITO_1 : in STD_LOGIC_VECTOR(3 downto 0);
		DIGITO_2 : in STD_LOGIC_VECTOR(3 downto 0);
		RESULT : out STD_LOGIC_VECTOR(7 downto 0)
	);
end modulo_multiplicador;

architecture Behavioral of modulo_multiplicador is
	
	signal resultado : unsigned (7 downto 0) := "00000000";

begin
	resultado <= unsigned(DIGITO_1)*unsigned(DIGITO_2);
	RESULT <= STD_LOGIC_VECTOR(resultado);
end Behavioral;

