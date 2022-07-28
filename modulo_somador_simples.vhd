----------------------------------------------------------------------------------
-- Engineer: Leandro Assis dos Santos
-- 
-- Create Date:    15:52:05 07/08/2022 
-- Module Name:    modulo_somador_completo - Behavioral 
-- Description: 	somador BCD simples de 2 d�gitos

-- Recebe dois valores entre 0000 e 1001 e coloca a resposta em 2 digitos (C_OUT e RESULT),
-- que variam respectivamente entre 0000 � 0001 e 0000 � 1001
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity modulo_somador_simples is
	port(
		DIGITO_1  : in std_logic_vector(3 downto 0);
		DIGITO_2  : in std_logic_vector(3 downto 0);
		CARRY_IN  : in std_logic_vector(3 downto 0);
		CARRY_OUT : out std_logic_vector(3 downto 0);
		RESULT 	: out std_logic_vector(3 downto 0)
	);
end modulo_somador_simples;

architecture Behavioral of modulo_somador_simples is
	
	-- Vari�vel auxiliar para receber (em bin�rio) a soma de dois digitos entre 0000 e 1001
	signal resultado : unsigned (4 downto 0) := "00000";
	
begin
	-- Atribui a soma dos dois digitos mais o carry in
	resultado <= resize(unsigned(DIGITO_1), 5)+resize(unsigned(DIGITO_2), 5)+resize(unsigned(CARRY_IN), 5);
	
	process(resultado)
	begin
		if resultado > 9 then
			-- Se o resultado ultrapassa 9
			CARRY_OUT <= "0001"; -- Seta o carry em 1
			RESULT <= std_logic_vector(resize((resultado+6), 4)); -- Soma 6 ao segundo d�gito (ultimos 4 bits) da resposta e coloca na sa�da
		else 
			-- Se o resultado n�o ultrapassa 9
			CARRY_OUT <= "0000";	-- N�o seta o carry
			RESULT <= std_logic_vector(resize(resultado, 4)); -- Apresenta o segundo digito na saida (ultimos 4 bits)
		end if;
	end process;
end Behavioral;

