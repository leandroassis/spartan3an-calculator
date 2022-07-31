----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:26 07/29/2022 
-- Design Name: 
-- Module Name:    modulo_principal - Behavioral 
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
use work.BCD.all;

entity modulo_principal is
	port(
		op_code : in std_logic_vector(3 downto 0);
		reset_maq : in std_logic;
		clk : in std_logic
	);
end modulo_principal;

architecture Behavioral of modulo_principal is

	component kb_code
		port(
			clk, reset: in  std_logic;
			ps2d, ps2c: in  std_logic;
			rd_key_code: in std_logic;
			number_code: out std_logic_vector(7 downto 0);
			kb_buf_empty: out std_logic
		);
	end component;
	
	component lcd
		port( 	
		 NUMERO: std_logic_vector(3 downto 0);
		 BOTAO: in std_logic;
		 LED: out std_logic;
		 LCD_DB: out std_logic_vector(7 downto 0);		--DB( 7 through 0)
		 RS:out std_logic;  				--WE
		 RW:out std_logic;				--ADR(0)
		 CLK:in std_logic;				--GCLK2
		 OE:out std_logic;				--OE
		 rst:in std_logic					--BTN
		);	
	end component;
	
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
	
	type estados_maquina is (digito0_0, digito1_0, digito2_0, digito3_0,
									 digito0_1, digito1_1, digito2_1, digito3_1,
									 resultado, operacao, igual);
	signal estado_atual, proximo_estado : estados_maquina := digito0_0;
	signal numero_code, op : std_logic_vector(3 downto 0);
	signal A,B : array_BCD_4DIGITOS;
	signal soma : array_BCD_5DIGITOS;
	signal multiplicacao : array_BCD_8DIGITOS;
	signal write_lcd, is_empty : std_logic;
	
begin
	
	lcd : lcd port map(code_escrita, write_lcd, LED=>LED , LCD_DB=>LCD_DB, RS=>RS, RW=>RW, clk, OE=>OE, reset_maq);
	
	kbd: kb_code port map(clk, reset_maq, ps2d=>ps2d, ps2c=>ps2c, not is_empty, numero_code, is_empty);
	
	soma : modulo_somador_completo port map(A, B, soma);
	
	multiplicador : modulo_multiplicador_completo port map(A, B, multiplicacao);
	
	-- FSM para ler digitos
	
	process(numero_code)
	begin
		if numero_code(3 downto 0) = X"1101" then
			estado_atual <= proximo_estado;
			write_lcd <= '1';
		else 
			code_escrita <= numero_code(3 downto 0);
			write_lcd <= '0';
		end if;
	end process;
	
	process(numero_code, reset_maq)
		begin
			if reset_maq = '1' then
				proximo_estado <= digito0_0;
			else 
				case estado_atual is
					when digito0_0 =>
						if numero_code /= X"0D" then
							A(0) <= numero_code(3 downto 0);
							proximo_estado <= digito0_1;
						else 
							proximo_estado <= digito0_0;
						end if;
					when digito0_1 =>
						if numero_code /= X"0D" then
							A(1) <= numero_code(3 downto 0);
							proximo_estado <= digito0_2;
						else 
							proximo_estado <= digito0_1;
						end if;
					when digito0_2 =>
						if numero_code /= X"0D" then
							A(2) <= numero_code(3 downto 0);
							proximo_estado <= digito0_3;
						else 
							proximo_estado <= digito0_2;
						end if;
					when digito0_3 =>
						if numero_code /= X"0D" then
							A(3) <= numero_code(3 downto 0);
							proximo_estado <= operacap;
						else 
							proximo_estado <= digito0_3;
						end if;
					when operacao =>
						if OPCODE = "0001" or OPCODE = "1000" then
							op <= OPCODE;
							proximo_estado <= digito1_0;
						else 
							proximo_estado <= operacao;
						end if;
					when digito1_0 =>
						if numero_code /= X"0D" then
							B(0) <= numero_code(3 downto 0);
							proximo_estado <= digito1_1;
						else 
							proximo_estado <= digito1_0;
						end if;
					when digito1_1 =>
						if numero_code /= X"0D" then
							B(1) <= numero_code(3 downto 0);
							proximo_estado <= digito1_2;
						else 
							proximo_estado <= digito1_1;
						end if;
					when digito1_2 =>
						if numero_code /= X"0D" then
							B(2) <= numero_code(3 downto 0);
							proximo_estado <= digito1_3;
						else 
							proximo_estado <= digito1_2;
						end if;
					when digito1_3 =>
						if numero_code /= X"0D" then
							B(3) <= numero_code(3 downto 0);
							proximo_estado <= resultado;
						else 
							proximo_estado <= digito1_3;
						end if;
					when resultado =>
						proximo_estado <= resultado;
						out_en <= '1';
				end case;
			end if;
	end process;
	
	-- FSM para apresentar o resultado
	
	process(clk)
	begin
		if clk'event and clk='1' then
			if op = "0001" then -- soma
				code_escrita <= soma(4);
			elsif op = "1000" then -- multipli
				code_escrita <= multiplicacao(7);
			end if;
		end if;
	end process;

end Behavioral;

