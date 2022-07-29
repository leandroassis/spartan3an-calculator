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
		le_kbd : in std_logic;
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
	
	type estados_maquina is (digito0_0, digito1_0, digito2_0, digito3_0,
									 digito0_1, digito1_1, digito2_1, digito3_1,
									 resultado, operacao, igual);
	signal estado_atual, proximo_estado : estados_maquina := digito0_0;
	signal numero_code : std_logic_vector(3 downto 0);
	signal A,B : array_BCD_4DIGITOS;
	
begin
	
	lcd : lcd port map(code_escrita, enter_press, LED=>LED , LCD_DB=>LCD_DB, RS=>RS, RW=>RW, clk, OE=>OE, reset_maq);
	
	kbd: kbd_code port map(clk, reset_maq, ps2d=>ps2d, ps2c=>ps2c, le_kbd, numero_code, open);
	
	-- FSM para ler digitos
	
	process(clk)
		begin
			if clk'event and clk = '1' then
				estado_atual <= proximo_estado;
			end if;
	end process;
	
	process(le_kbd, reset_maq)
		begin
			if reset_maq = '1' then
				proximo_estado <= digito0_0;
			else 
				case estado_atual is
					when digito0_0 =>
						A(0) <= numero_code;
						proximo_estado <= digito0_1;
						out_en <= '0';
					when digito0_1 =>
						A(1) <= numero_code;
						proximo_estado <= digito0_2;
					when digito0_2 =>
						A(2) <= numero_code;
						proximo_estado <= digito0_3;
					when digito0_3 =>
						A(3) <= numero_code;
						proximo_estado <= operacao;
					when operacao =>
						proximo_estado <= digito1_0;
					when digito1_0 =>
						B(0) <= numero_code;
						proximo_estado <= digito1_1;
					when digito1_1 =>
						B(1) <= numero_code;
						proximo_estado <= digito1_2;
					when digito1_2 =>
						B(2) <= numero_code;
						proximo_estado <= digito1_3;
					when digito1_3 =>
						B(3) <= numero_code;
						proximo_estado <= igual;
					when igual =>
						out_en <= '1';
						proximo_estado <= resultado;
					when resultado =>
						proximo_estado <= resultado;
						out_en <= '1';
				end case;
			end if;
	end process;
	

end Behavioral;

