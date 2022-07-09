----------------------------------------------------------------------------------
-- Engineer: Leandro Assis dos Santos
-- 
-- Create Date:    15:52:05 07/08/2022 
-- Module Name:    modulo_somador_completo - Behavioral 
-- Description: 	somador BCD simples de 2 dígitos

-- Recebe dois valores entre 0000 e 1001 e coloca a resposta em 2 digitos (C_OUT e RESULT),
-- que variam respectivamente entre 0000 à 0001 e 0000 à 1001
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity modulo_somador_simples is
	port(
		A  : in unsigned(3 downto 0);
		B  : in unsigned(3 downto 0);
		C_IN  : in unsigned(3 downto 0);
		C_OUT : out unsigned(3 downto 0);
		RESULT 	: out unsigned(3 downto 0)
	);
end modulo_somador_simples;

architecture Behavioral of modulo_somador_simples is
	
	-- Variável auxiliar para receber (em binário) a soma de dois digitos entre 0000 e 1001
	signal resultado : unsigned (4 downto 0) := "00000";
	
begin
	-- Atribui a soma dos dois digitos mais o carry in
	resultado <= resize(A, 5)+resize(B,5)+resize(C_IN,5);
	
	process(resultado)
	begin
		if resultado > 9 then
			-- Se o resultado ultrapassa 9
			C_OUT <= "0001"; -- Seta o carry em 1
			RESULT <= resize((resultado+6), 4); -- Soma 6 ao segundo dígito (ultimos 4 bits) da resposta e coloca na saída
		else 
			-- Se o resultado não ultrapassa 9
			C_OUT <= "0000";	-- Não seta o carry
			RESULT <= resize(resultado, 4); -- Apresenta o segundo digito na saida (ultimos 4 bits)
		end if;
	end process;
end Behavioral;

