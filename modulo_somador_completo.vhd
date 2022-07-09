----------------------------------------------------------------------------------
-- Engineer: Leandro Assis dos Santos
-- 
-- Create Date:    20:05:04 07/08/2022 
-- Module Name:    modulo_somador_completo - Behavioral 
-- Description: Recebe 4 digitos BCD de um número A e 4 dígios BCD de um numero B e coloca
-- a resposta em 5 digitos.

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity modulo_somador_completo is
	port(
		-- Inicio dos digitos BCD de A
		A0 : in unsigned(3 downto 0);
		A1 : in unsigned(3 downto 0);
		A2 : in unsigned(3 downto 0);
		A3 : in unsigned(3 downto 0);
		-- Fim dos dígitos BCD de A
		
		-- Inicio dos digitos BCD de B
		B0 : in unsigned(3 downto 0);
		B1 : in unsigned(3 downto 0);
		B2 : in unsigned(3 downto 0);
		B3 : in unsigned(3 downto 0);
		-- Fim dos dígitos BCD de B
		
		-- Inicio dos digitos BCD da resposta
		RESULTADO0 : out unsigned(3 downto 0);
		RESULTADO1 : out unsigned(3 downto 0);
		RESULTADO2 : out unsigned(3 downto 0);
		RESULTADO3 : out unsigned(3 downto 0);
		RESULTADO4 : out unsigned(3 downto 0)
		-- FIM dos digitos BCD da resposta
	);
end modulo_somador_completo;

architecture Behavioral of modulo_somador_completo is
	
	-- Chamada do modulo somador simples para fazer o somador em cascata
	component modulo_somador_simples
		port(
			A  : in unsigned(3 downto 0);
			B  : in unsigned(3 downto 0);
			C_IN  : in unsigned;
			C_OUT : out unsigned;
			RESULT 	: out unsigned(3 downto 0)
		);
	end component;
	
	-- Variáveis auxiliares para guardar os carrys
	signal aux0, aux1, aux2, aux3 : unsigned (3 downto 0) := "0000";
	
begin
	
	-- Soma do digito mais a direita em BCD
	digito_0 : modulo_somador_simples port map(A0, B0, "0000", aux0, RESULTADO0);
	
	digito_1 : modulo_somador_simples port map(A1, B1, aux0, aux1, RESULTADO1);
	digito_2 : modulo_somador_simples port map(A2, B2, aux1, aux2, RESULTADO2);
	digito_3 : modulo_somador_simples port map(A3, B3, aux2, aux3, RESULTADO3);
	
	-- Atribuição do digito BCD mais a esquerda
	RESULTADO4 <= aux3;
end Behavioral;

