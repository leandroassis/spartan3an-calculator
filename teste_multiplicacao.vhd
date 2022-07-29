----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:25:46 07/27/2022 
-- Design Name: 
-- Module Name:    teste_multiplicacao - Behavioral 
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
use IEEE.NUMERIC_STD.all;
use work.BCD.all;

entity teste_multiplicacao is
	port(
		RESULTA : out array_BCD_5DIGITOS;
		RESULTAD : out array_BCD_8DIGITOS
	);
end teste_multiplicacao;

architecture Behavioral of teste_multiplicacao is
	component modulo_somador_completo
		port(
			A : in array_BCD_4DIGITOS;
			B : in array_BCD_4DIGITOS;
			RESULTADO : out array_BCD_5DIGITOS
		);
	end component;
	
	component modulo_multiplicador_completo
		port(
			A : in array_BCD_4DIGITOS;
			B : in array_BCD_4DIGITOS;
			RESULT : out array_BCD_8DIGITOS
		);
	end component;
	
	signal A, B : array_BCD_4DIGITOS := (('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('1', '0', '0', '1'));
begin
	
	A(1) <= "0010";
	A(0) <= "0101";
	--somador : modulo_somador_completo port map(A, B, RESULTA);
	--multiplicador : modulo_multiplicador_completo port map(A, B, RESULTAD);

end Behavioral;

