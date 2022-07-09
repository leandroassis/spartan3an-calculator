----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:00:26 07/09/2022 
-- Design Name: 
-- Module Name:    modulo_somador_linhas - Behavioral 
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
use IEEE.numeric_std.ALL;

entity modulo_somador_linhas is
	port(
		LINHA0 : in array_BCD_5DIGITOS;
		LINHA1 : in array_BCD_5DIGITOS;
		LINHA2 : in array_BCD_5DIGITOS;
		LINHA3 : in array_BCD_5DIGITOS;
		resultado: out array_BCD_8DIGITOS
	);
end modulo_somador_linhas;

architecture Behavioral of modulo_somador_linhas is
	
	component modulo_somador_simples
		port(
			DIGITO_1  : in unsigned(3 downto 0);
			DIGITO_2  : in unsigned(3 downto 0);
			CARRY_IN  : in unsigned(3 downto 0);
			CARRY_OUT : out unsigned(3 downto 0);
			RESULT 	: out unsigned(3 downto 0)
		);
	end component;
	
begin


end Behavioral;

