----------------------------------------------------------------------------------
-- Engineer: Leandro Assis dos Santos
-- 
-- Create Date:    20:03:55 16/07/2022  
-- Module Name:    modulo_multiplicador_completo - Behavioral 

-- Description: Recebe 4 digitos BCD de um número A e 4 dígios BCD de um numero B e coloca
-- a resposta em 8 digitos (7 de resposta e 1 do ultimo carry out).
----------------------------------------------------------------------------------

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

	-- chamada do multiplicador simples
	component modulo_multiplicador_simples
		port(
			DIGITO_1 : in std_logic_vector(3 downto 0);
			DIGITO_2 : in std_logic_vector(3 downto 0);
			CARRY_IN : in std_logic_vector(3 downto 0);
			CARRY_OUT  : out std_logic_vector(3 downto 0);
			RESULT : out std_logic_vector(3 downto 0)
		);
	end component;
	
	-- chamada do modulo responsavel por soma as linhas da multiplicação
	component modulo_somador_linhas
		port(
			LINHA0 : in array_BCD_5DIGITOS;
			LINHA1 : in array_BCD_5DIGITOS;
			LINHA2 : in array_BCD_5DIGITOS;
			LINHA3 : in array_BCD_5DIGITOS;
			resultado: out array_BCD_8DIGITOS
		);
	end component;
	
	-- variaveis para armazenar os carrys (cada indice dessas variaveis é um digito bcd Ex: carry0(0) é igual à "0000")
	--												            3							2							1							0
	signal carry0 : array_BCD_4DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal carry1 : array_BCD_4DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal carry2 : array_BCD_4DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal carry3 : array_BCD_4DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	
	-- variaveis para armazenar os resultados da multiplicação dos digitos (ex: linha0 recebe B(3)*A(0), B(2)*A(0), B(1)*A(0), B(0)*A(0)) 
	--																4							3							2							1							0
	signal linha0 : array_BCD_5DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal linha1 : array_BCD_5DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal linha2 : array_BCD_5DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));
	signal linha3 : array_BCD_5DIGITOS := ( ('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'),('0', '0', '0', '0'));

begin

	-- Multiplicação cruzada de A(0) por todos os valores de B, armazenada todos os digitos BCD na linha0 e os carrys propagados em carry0
	multi0: modulo_multiplicador_simples port map(A(0), B(0), "0000", carry0(0), linha0(0));
	multi1: modulo_multiplicador_simples port map(A(0), B(1), carry0(0), carry0(1), linha0(1));
	multi2: modulo_multiplicador_simples port map(A(0), B(2), carry0(1), carry0(2), linha0(2));
	multi3: modulo_multiplicador_simples port map(A(0), B(3), carry0(2), carry0(3), linha0(3));
	linha0(4) <= carry0(3);
	
	-- Multiplicação cruzada de A(1) por todos os valores de B, armazenada todos os digitos BCD na linha1 e os carrys propagados em carry1
	multi4: modulo_multiplicador_simples port map(A(1), B(0), "0000", carry1(0), linha1(0));
	multi5: modulo_multiplicador_simples port map(A(1), B(1), carry1(0), carry1(1), linha1(1));
	multi6: modulo_multiplicador_simples port map(A(1), B(2), carry1(1), carry1(2), linha1(2));
	multi7: modulo_multiplicador_simples port map(A(1), B(3), carry1(2), carry1(3), linha1(3));
	linha1(4) <= carry1(3);
	
	-- Multiplicação cruzada de A(2) por todos os valores de B, armazenada todos os digitos BCD na linha2 e os carrys propagados em carry2
	multi8: modulo_multiplicador_simples port map(A(2), B(0), "0000", carry2(0), linha2(0));
	multi9: modulo_multiplicador_simples port map(A(2), B(1), carry2(0), carry2(1), linha2(1));
	multi10: modulo_multiplicador_simples port map(A(2), B(2), carry2(1), carry2(2), linha2(2));
	multi11: modulo_multiplicador_simples port map(A(2), B(3), carry2(2), carry2(3), linha2(3));
	linha2(4) <= carry2(3);
	
	-- Multiplicação cruzada de A(3) por todos os valores de B, armazenada todos os digitos BCD na linha3 e os carrys propagados em carry3
	multi13: modulo_multiplicador_simples port map(A(3), B(0), "0000", carry3(0), linha3(0));
	multi14: modulo_multiplicador_simples port map(A(3), B(1), carry3(0), carry3(1), linha3(1));
	multi15: modulo_multiplicador_simples port map(A(3), B(2), carry3(1), carry3(2), linha3(2));
	multi16: modulo_multiplicador_simples port map(A(3), B(3), carry3(2), carry3(3), linha3(3));
	linha3(4) <= carry3(3);
	-- Fim da multiplicação
	
	-- Soma das linhas
	soma_linhas: modulo_somador_linhas port map(linha0, linha1, linha2, linha3, RESULT);
	-- Fim da soma

end Behavioral;

