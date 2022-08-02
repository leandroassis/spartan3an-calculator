----------------------------------------------------------------------------------
-- Engineer: Leandro Assis dos Santos
-- 
-- Create Date:    14:25:06 29/07/2022 
-- Module Name:    modulo_principal - Behavioral 

-- Description: modulo principal responsavel por ter a FSM que controla a entrada de digitos e a colocação dos mesmos no LCD
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BCD.all;

entity modulo_principal is
	port(
		OE:out std_logic;			
		RS:out std_logic;  				
		RW:out std_logic;				
		LCD_DB: out std_logic_vector(7 downto 0);
		kbd_data : in std_logic;
		kbd_clock : in std_logic;
		op_code : in std_logic_vector(3 downto 0);
		reset_maq : in std_logic;
		clk : in std_logic
	);
end modulo_principal;

architecture Behavioral of modulo_principal is

	-- chamada da interface com o teclado
	component kb_code
		port(
			clk, reset: in  std_logic;
			ps2d, ps2c: in  std_logic;
			rd_key_code: in std_logic;
			number_code: out std_logic_vector(7 downto 0);
			kb_buf_empty: out std_logic
		);
	end component;
	
	-- chamada da interface com o lcd
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
	
	-- chamada do modulo somador completo
	component modulo_somador_completo
		port(
			A : in array_BCD_4DIGITOS;
			B : in array_BCD_4DIGITOS;
			RESULTADO : out array_BCD_5DIGITOS
		);
	end component;
	
	-- chamada do módulo multiplicador completo	
	component modulo_multiplicador_completo
		port(
			A : in array_BCD_4DIGITOS;
			B : in array_BCD_4DIGITOS;
			RESULT : out array_BCD_8DIGITOS
		);
	end component;
	
	-- estados da FSM
	type estados_maquina is (digito0_0, digito1_0, digito2_0, digito3_0,
									 digito0_1, digito1_1, digito2_1, digito3_1,
									 resultado, operacao);
	signal estado_atual, proximo_estado : estados_maquina := digito0_0;
	
	signal numero_code : std_logic_vector(7 downto 0);
	signal op, code_escrita : std_logic_vector(3 downto 0); -- numero em BCD lido do teclado e código de operação lido das switchs, respectivamente
	signal A,B : array_BCD_4DIGITOS; -- Vetor A e B para serem preenchidos digito à digito pela FSM
	signal soma : array_BCD_5DIGITOS; -- Vetor para armazenar a saida do somador completo
	signal multiplicacao : array_BCD_8DIGITOS; -- Vetor para armazenar a saida do multiplicador completo
	signal write_lcd, is_empty, out_en : std_logic := '0'; -- variaveis de controle para enviar sinal de escrita no LCD no proximo clock e para verificar se a FIFO do teclado tem alguma tecla
	
begin
	
	lcd_display : lcd port map(numero_code(3 downto 0), write_lcd, open, LCD_DB, RS, RW, clk, OE, reset_maq);
	
	kbd: kb_code port map(clk, reset_maq, kbd_data, kbd_clock, not is_empty, numero_code, is_empty);
	
	somador : modulo_somador_completo port map(A, B, soma);
	
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
			elsif numero_code /= X"0D" and (op_code = "0001" or op_code = "1000") then
				case estado_atual is
					when digito0_0 =>
						A(0) <= numero_code(3 downto 0);
						proximo_estado <= digito1_0;
					when digito1_0 =>
						A(1) <= numero_code(3 downto 0);
						proximo_estado <= digito2_0;
					when digito2_0 =>
						A(2) <= numero_code(3 downto 0);
						proximo_estado <= digito3_0;
					when digito3_0 =>
						A(3) <= numero_code(3 downto 0);
						proximo_estado <= operacao;
					when operacao =>
						op <= op_code;
						proximo_estado <= digito0_1;
					when digito0_1 =>
						B(0) <= numero_code(3 downto 0);
						proximo_estado <= digito1_1;
					when digito1_1 =>
						B(1) <= numero_code(3 downto 0);
						proximo_estado <= digito2_1;
					when digito2_1 =>
						B(2) <= numero_code(3 downto 0);
						proximo_estado <= digito3_1;
					when digito3_1 =>
						B(3) <= numero_code(3 downto 0);
						proximo_estado <= resultado;
					when resultado =>
						proximo_estado <= resultado;
						out_en <= '1';
				end case;
			end if;
	end process;
	
	-- FSM para apresentar o resultado
	-- Essa FSM não funciona de forma propria, deve a cada clk enviar um digito BCD para o display
	process(clk, estado_atual)
	begin
		if estado_atual /= resultado then
			--code_escrita <= A(0);
		elsif clk'event and clk='1' and out_en = '1' then
			if op = "0001" then -- soma
				code_escrita <= soma(4);
			elsif op = "1000" then -- multipli
				code_escrita <= multiplicacao(7);
			end if;
		end if;
	end process;

end Behavioral;

