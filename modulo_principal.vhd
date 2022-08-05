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
	signal op, code_escrita, apresenta, valor : std_logic_vector(3 downto 0) := "0000"; -- numero em BCD lido do teclado e código de operação lido das switchs, respectivamente
	signal A,B : array_BCD_4DIGITOS; -- Vetor A e B para serem preenchidos digito à digito pela FSM
	signal soma : array_BCD_5DIGITOS; -- Vetor para armazenar a saida do somador completo
	signal multiplicacao : array_BCD_8DIGITOS; -- Vetor para armazenar a saida do multiplicador completo
	signal write_lcd, is_empty, out_en, stop : std_logic := '0'; -- variaveis de controle para enviar sinal de escrita no LCD no proximo clock e para verificar se a FIFO do teclado tem alguma tecla
	signal count : integer := 4;
	signal count2 : integer := 7;
	
begin
	
	valor <= code_escrita or apresenta;
	
	-- instância dos componentes
	lcd_display : lcd port map(valor, write_lcd, open, LCD_DB, RS, RW, clk, OE, reset_maq);
	
	kbd: kb_code port map(clk, reset_maq, kbd_data, kbd_clock, not is_empty, numero_code, is_empty);
	
	somador : modulo_somador_completo port map(A, B, soma);
	
	multiplicador : modulo_multiplicador_completo port map(A, B, multiplicacao);
	
	-- Controle de escrita no LCD ao apertar ENTER
	process(numero_code, clk)
	begin
			if numero_code = X"0D" then -- quando o ENTER for pressionado
				estado_atual <= proximo_estado; -- avança de estado
				write_lcd <= '1'; -- escreve no LCD
			else -- senao
				code_escrita <= numero_code(3 downto 0); -- guarda na variavel auxiliar de escrita para ser escrito no proximo clock
				write_lcd <= '0'; -- não escreve no LCD
			end if;
	end process;
	
	process(numero_code, reset_maq)
		begin
			if reset_maq = '1' then -- se botao de reset for pressionado
				proximo_estado <= digito0_0; -- volta para o estado inicial
			elsif numero_code /= X"0D" and (op_code = "0001" or op_code = "1000") then -- se a tecla nao for enter e a chave de OPCODE estiver em valores válidos
				case estado_atual is -- faz o chaveamento de estados
					when digito0_0 => -- salva o primeiro digito de A (esquerda para a direita)
						A(3) <= numero_code(3 downto 0);
						proximo_estado <= digito1_0;
					when digito1_0 => -- salva o segundo digito de A
						A(2) <= numero_code(3 downto 0);
						proximo_estado <= digito2_0;
					when digito2_0 => -- salva o terceiro digito de A
						A(1) <= numero_code(3 downto 0);
						proximo_estado <= digito3_0;
					when digito3_0 => -- salva o quarto digito de A
						A(0) <= numero_code(3 downto 0);
						proximo_estado <= operacao;
					when operacao => -- salva o OPCODE
						op <= op_code;
						proximo_estado <= digito0_1;
					when digito0_1 => -- salva o primeiro digito de B (esquerda para a direita)
						B(3) <= numero_code(3 downto 0);
						proximo_estado <= digito1_1;
					when digito1_1 => -- salva o segundo digito de B
						B(2) <= numero_code(3 downto 0);
						proximo_estado <= digito2_1;
					when digito2_1 => -- salva o terceiro digito de B
						B(1) <= numero_code(3 downto 0);
						proximo_estado <= digito3_1;
					when digito3_1 => -- salva o quarto digito de B
						B(0) <= numero_code(3 downto 0);
						proximo_estado <= resultado;
					when resultado => -- habilita a FSM que apresenta o resultado
						proximo_estado <= resultado;
						out_en <= '1';
				end case;
			end if;
	end process;
	
	-- FSM para apresentar o resultado
	process(clk, estado_atual, op)
	begin
		if estado_atual = resultado then -- se estiver no estado de apresentar resultado
		   if clk'event and clk='1' and out_en = '1' and stop <= '0' then -- a cada ciclo de clock
				if op = "0001" then -- se a operação for soma
					apresenta <= soma(count); -- apresenta o valor de cada um dos 5 digitos da soma (count ja inicia em 4)
					if count = 0 then -- se chegou ao final desabilita a apresentação
						count <= 4;
						stop <= '1';
					else count <= count - 1; -- senao vai apresentando ate o digito mais a direita
					end if;
				else -- se a operação for multiplicação
					apresenta <= multiplicacao(count2); -- apresenta o valor de cada um dos 8 digitos da multiplicação (count2 ja inicia em 7)
					if count2 = 0 then -- se chegou ao final desabilita a apresentação
						count2 <= 7; 
						stop <= '1';
					else count2 <= count2 - 1; -- senão vai apresentando ate o digito mais a direita
					end if;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

