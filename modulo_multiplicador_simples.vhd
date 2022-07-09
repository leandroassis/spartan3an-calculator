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

entity modulo_multiplicador_simples is
	port(
		DIGITO_1 : in unsigned(3 downto 0);
		DIGITO_2 : in unsigned(3 downto 0);
		CARRY_IN : in unsigned(3 downto 0);
		RESULT : out unsigned(3 downto 0);
		CARRY_OUT  : out unsigned(3 downto 0)
	);
end modulo_multiplicador_simples;

architecture Behavioral of modulo_multiplicador_simples is
	
	signal resultado : unsigned (7 downto 0) := "00000000";
	signal aux : unsigned (7 downto 0) := "00000000";

begin
	resultado <= DIGITO_1*DIGITO_2 + CARRY_IN;
	
	process(resultado)
	begin
		if resultado >= 80 then
			aux <= resultado + 48;
		elsif resultado >= 70 then
			aux <= resultado + 42;
		elsif resultado >= 60 then
			aux <= resultado + 36;
		elsif resultado >= 50 then
			aux <= resultado + 30;
		elsif resultado >= 40 then
			aux <= resultado + 24;
		elsif resultado >= 30 then
			aux <= resultado + 18;
		elsif resultado >= 20 then
			aux <= resultado + 12;
		elsif resultado >= 10 then
			aux <= resultado + 6;
		else 
			aux <= resultado;
		end if;
	end process;
	
	CARRY_OUT <= aux(7 downto 4);
	RESULT <= aux(3 downto 0);
	
end Behavioral;

