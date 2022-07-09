----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:51:21 07/09/2022 
-- Design Name: 
-- Module Name:    modulo_multiplicador_completo - Behavioral 
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
use IEEE.numeric_std.ALL;

package BCD is
	type array_BCD_4DIGITOS is array(3 downto 0, 3 downto 0) of unsigned;
	type array_BCD_5DIGITOS is array(4 downto 0, 3 downto 0) of unsigned;
	type array_BCD_8DIGITOS is array(7 downto 0, 3 downto 0) of unsigned;
end package;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.BCD.all;

entity modulo_multiplicador_completo is
	port(
		A : in array_BCD_4DIGITOS;
		B : in array_BCD_4DIGITOS;
		RESULT : out array_BCD_8DIGITOS
	);
end modulo_multiplicador_completo;

architecture Behavioral of modulo_multiplicador_completo is
	component modulo_multiplicador_simples
		port(
			DIGITO_1 : in unsigned(3 downto 0);
			DIGITO_2 : in unsigned(3 downto 0);
			CARRY_IN : in unsigned(3 downto 0);
			CARRY_OUT  : out unsigned(3 downto 0);
			RESULT : out unsigned(3 downto 0)
		);
	end component;
	
	component modulo_somador_linhas
		port(
			LINHA0 : in array_BCD_5DIGITOS;
			LINHA1 : in array_BCD_5DIGITOS;
			LINHA2 : in array_BCD_5DIGITOS;
			LINHA3 : in array_BCD_5DIGITOS;
			resultado: out array_BCD_8DIGITOS
		);
	end component;
	
	--												            3							2							1							0
	signal carry : array_BCD_4DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	
	--																4							3							2							1							0
	signal linha0 : array_BCD_5DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal linha1 : array_BCD_5DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal linha2 : array_BCD_5DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal linha3 : array_BCD_5DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));

begin

	-- Multiplicação
	multi0: modulo_multiplicador_simples port map(A(0), B(0), "0000", carry(0), linha0(0));
	multi1: modulo_multiplicador_simples port map(A(0), B(1), carry(0), carry(1), linha0(1));
	multi2: modulo_multiplicador_simples port map(A(0), B(2), carry(1), carry(2), linha0(2));
	multi3: modulo_multiplicador_simples port map(A(0), B(3), carry(2), carry(3), linha0(3));
	linha0(4) <= carry(3);
	
	multi4: modulo_multiplicador_simples port map(A(1), B(0), "0000", carry(0), linha1(0));
	multi5: modulo_multiplicador_simples port map(A(1), B(1), carry(0), carry(1), linha1(1));
	multi6: modulo_multiplicador_simples port map(A(1), B(2), carry(1), carry(2), linha1(2));
	multi7: modulo_multiplicador_simples port map(A(1), B(3), carry(2), carry(3), linha1(3));
	linha1(4) <= carry(3);
	
	multi8: modulo_multiplicador_simples port map(A(2), B(0), "0000", carry(0), linha2(0));
	multi9: modulo_multiplicador_simples port map(A(2), B(1), carry(0), carry(1), linha2(1));
	multi10: modulo_multiplicador_simples port map(A(2), B(2), carry(1), carry(2), linha2(2));
	multi11: modulo_multiplicador_simples port map(A(2), B(3), carry(2), carry(3), linha2(3));
	linha12(4) <= carry(3);
	
	multi13: modulo_multiplicador_simples port map(A(3), B(0), "0000", carry(0), linha3(0));
	multi14: modulo_multiplicador_simples port map(A(3), B(1), carry(0), carry(1), linha3(1));
	multi15: modulo_multiplicador_simples port map(A(3), B(2), carry(1), carry(2), linha3(2));
	multi16: modulo_multiplicador_simples port map(A(3), B(3), carry(2), carry(3), linha3(3));
	linha3(4) <= carry(3);
	-- Fim da multiplicação
	
	-- Soma das linhas
	
	soma_linhas: modulo_somador_linhas port map(linha0, linha1, linha2, linha3, RESULT);
	
	-- Fim da soma

end Behavioral;

