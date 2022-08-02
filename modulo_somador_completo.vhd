----------------------------------------------------------------------------------
-- Engineer: Leandro Assis dos Santos
-- 
-- Create Date:    20:05:04 08/07/2022 
-- Module Name:    modulo_somador_completo - Behavioral 

-- Description: Recebe 4 digitos BCD de um número A e 4 dígios BCD de um numero B e coloca
-- a resposta em 5 digitos.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BCD.all;

entity modulo_somador_completo is
	port(
		A : in array_BCD_4DIGITOS; -- array BCD de 4 digitos 
		B : in array_BCD_4DIGITOS; -- Array BCD de 4 digitos 
		RESULTADO : out array_BCD_5DIGITOS -- Array BCD de 5 digitos (4 digitos da soma e o carry out da ultima operacao)
	);
end modulo_somador_completo;

architecture Behavioral of modulo_somador_completo is
	
	-- Chamada do modulo somador simples para fazer o somador em cascata
	component modulo_somador_simples
		port(
			DIGITO_1  : in std_logic_vector(3 downto 0);
			DIGITO_2  : in std_logic_vector(3 downto 0);
			CARRY_IN  : in std_logic_vector(3 downto 0);
			CARRY_OUT : out std_logic_vector(3 downto 0);
			RESULT 	: out std_logic_vector(3 downto 0)
		);
	end component;
	
	-- Variáveis auxiliares para guardar os carrys
	signal aux : array_BCD_4DIGITOS := (('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'));

begin
	
	-- Soma do digito mais a direita em BCD
	digito_0 : modulo_somador_simples port map(A(0), B(0), "0000", aux(0), RESULTADO(0)); -- Digito 0 de A com digito 0 de B e sem carry in
	digito_1 : modulo_somador_simples port map(A(1), B(1), aux(0), aux(1), RESULTADO(1)); -- Digito 1 de A com digito 1 de B e o carry gerado na soma acima
	digito_2 : modulo_somador_simples port map(A(2), B(2), aux(1), aux(2), RESULTADO(2)); -- Digito 2 de A com digito 2 de B e o carry gerado na soma acima
	digito_3 : modulo_somador_simples port map(A(3), B(3), aux(2), aux(3), RESULTADO(3)); -- Digito 3 de A com digito 3 de A e o carry gerado na soma acima
	
	-- Atribuição do carry out da ultima soma no digito BCD mais a esquerda do resultado
	RESULTADO(4) <= aux(3);
end Behavioral;

