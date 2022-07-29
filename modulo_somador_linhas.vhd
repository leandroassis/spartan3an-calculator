----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:00:26 07/09/2022 
-- Design Name: 
-- Module Name:    modulo_somador_linhas - Behavioral 
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
library work;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.BCD.all;

entity modulo_somador_linhas is
	port(
		LINHA0 : in array_BCD_5DIGITOS;
		LINHA1 : in array_BCD_5DIGITOS;
		LINHA2 : in array_BCD_5DIGITOS;
		LINHA3 : in array_BCD_5DIGITOS;
		resultado: out array_BCD_8DIGITOS
	);
end modulo_somador_linhas;

architecture Behavioral of modulo_somador_linhas is
	
	component modulo_somador_simples
		port(
			DIGITO_1  : in std_logic_vector(3 downto 0);
			DIGITO_2  : in std_logic_vector(3 downto 0);
			CARRY_IN  : in std_logic_vector(3 downto 0);
			CARRY_OUT : out std_logic_vector(3 downto 0);
			RESULT 	: out std_logic_vector(3 downto 0)
		);
	end component;
	
	signal carry : array_BCD_7DIGITOS :=     (('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'),
													      ('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'));
	signal aux : array_BCD_6DIGITOS :=       (('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'),
													      ('0', '0', '0', '0'), ('0', '0', '0', '0'));
	signal carry_aux : array_BCD_5DIGITOS := (('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'),
													      ('0', '0', '0', '0'));
begin
	resultado(0) <= linha0(0); -- coluna 0
	
	coluna1: modulo_somador_simples port map(linha0(1), linha1(0), "0000", carry(0), resultado(1)); -- coluna 1
	
	coluna2_0: modulo_somador_simples port map(linha0(2), linha1(1), carry(0), carry_aux(0), aux(0));
	coluna2_1: modulo_somador_simples port map(aux(0), linha2(0), carry_aux(0), carry(1), resultado(2)); -- coluna 2
	
	coluna3_0: modulo_somador_simples port map(linha0(3), linha1(2), carry(1), carry_aux(1), aux(1));
	coluna3_1: modulo_somador_simples port map(aux(1), linha2(1), carry_aux(1), carry_aux(2),aux(2));
	coluna3_2: modulo_somador_simples port map(aux(2), linha3(0), carry_aux(2), carry(2), resultado(3)); -- coluna 3
	
	coluna4_0: modulo_somador_simples port map(linha0(4), linha1(3), carry(2), carry_aux(3), aux(3));
	coluna4_1: modulo_somador_simples port map(aux(3), linha2(2), carry_aux(3), carry_aux(4), aux(4));
	coluna4_2: modulo_somador_simples port map(aux(4), linha3(1), carry_aux(4), carry(3), resultado(4)); -- coluna 4
	
	coluna5_0: modulo_somador_simples port map(linha1(4), linha2(3), carry(3), carry_aux(5), aux(5));
	coluna5_1: modulo_somador_simples port map(aux(5), linha3(2), carry_aux(5), carry(4), resultado(5)); -- coluna 5
	
	coluna6: modulo_somador_simples port map(linha2(4), linha3(3), carry(4), carry(5), resultado(6)); -- coluna 6
	coluna7: modulo_somador_simples port map(linha3(4), "0000", carry(5), open, resultado(7)); -- coluna 7
end Behavioral;

