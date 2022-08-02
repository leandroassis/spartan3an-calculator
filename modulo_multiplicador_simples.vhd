----------------------------------------------------------------------------------
-- Engineer: Leandro Assis dos Santos
-- 
-- Create Date:    17:37:35 15/07/2022 
-- Module Name:    modulo_multiplicador_simples - Behavioral 
-- Description: 	multiplicador BCD simples de 2 dígitos

-- Recebe dois valores entre 0000 e 1001 e coloca a resposta em 2 digitos (C_OUT e RESULT),
-- que variam respectivamente entre 0000 à 1001 e 0000 à 1001
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity modulo_multiplicador_simples is
	port(
		DIGITO_1 : in std_logic_vector(3 downto 0);
		DIGITO_2 : in std_logic_vector(3 downto 0);
		CARRY_IN : in std_logic_vector(3 downto 0);
		CARRY_OUT  : out std_logic_vector(3 downto 0);
		RESULT : out std_logic_vector(3 downto 0)
	);
end modulo_multiplicador_simples;

architecture Behavioral of modulo_multiplicador_simples is
	-- variaveis auxiliares para armazenar o resultado
	signal resultado : unsigned (7 downto 0) := "00000000";
	signal aux : unsigned (7 downto 0) := "00000000";
	
begin
	resultado <= unsigned(DIGITO_1)*unsigned(DIGITO_2) + unsigned(CARRY_IN); -- resultado recebe digito1*digito2 + carry_in
	
	process(resultado) -- processo para fazer o "ajuste do resultado para BCD"
	begin
		-- basicamente verifica qual o valor da dezena do resultado e multiplica este por 6 para somar com resultado
		if resultado >= 80 then -- se 80 ou 81 soma 6*8 = 48
			aux <= resultado + 48;
		elsif resultado >= 70 then -- se 70 à 79 soma 42
			aux <= resultado + 42;
		elsif resultado >= 60 then -- se 60 à 69 soma 36
			aux <= resultado + 36;
		elsif resultado >= 50 then -- se 50 à 59 soma 30
			aux <= resultado + 30;
		elsif resultado >= 40 then -- se 40 à 49 soma 24
			aux <= resultado + 24;
		elsif resultado >= 30 then -- se 30 à 39 soma 18
			aux <= resultado + 18;
		elsif resultado >= 20 then -- se 20 à 29 soma 12
			aux <= resultado + 12;
		elsif resultado >= 10 then -- se 10 à 19 soma 06
			aux <= resultado + 6;
		else 
			aux <= resultado; -- se <= 9 não precisa fazer nada pois já está em BCD
		end if;
	end process;
	
	CARRY_OUT <= std_logic_vector(aux(7 downto 4)); -- o digito BCD MSB de aux é colocado no carry_out para ser propagado
	RESULT <= std_logic_vector(aux(3 downto 0)); -- o digito BCD LSB de aux é colocado na saida
	
end Behavioral;

