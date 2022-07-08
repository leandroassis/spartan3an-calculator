----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:52:05 07/08/2022 
-- Design Name: 
-- Module Name:    modulo_somador - Behavioral 
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

entity modulo_somador is
	port(
		A  : in unsigned(3 downto 0);
		B  : in unsigned(3 downto 0);
		C_IN  : in unsigned(3 downto 0);
		C_OUT : out unsigned(3 downto 0);
		RESULT 	: out unsigned(3 downto 0)
	);
end modulo_somador;

architecture Behavioral of modulo_somador is
	
	signal resultado : unsigned (7 downto 0) := "00000000";
	
begin
	
	resultado <= resize(A+B+C_IN, 8);
	
	process(resultado)
	begin
		if resultado > 9 then
			C_OUT <= "0001";
			RESULT <= resize((resultado+"00000110"), 4);
		else 
			C_OUT <= "0000";
			RESULT <= resize(resultado, 4);
		end if;
	end process;
	
end Behavioral;

