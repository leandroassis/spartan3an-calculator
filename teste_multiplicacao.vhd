----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:52:02 08/05/2022 
-- Design Name: 
-- Module Name:    teste_multiplicacao - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity teste_multiplicacao is
	port(
		clk : in std_logic;
		RESULTADO : out array_BCD_5DIGITOS
	);
end teste_multiplicacao;

architecture Behavioral of teste_multiplicacao is
	
	component modulo_multiplicador_completo
		port(
			A : in array_BCD_4DIGITOS;
			B : in array_BCD_4DIGITOS;
			RESULT : out array_BCD_8DIGITOS
		);
	end component;
	
	component modulo_somador_completo
		port(
			A : in array_BCD_4DIGITOS;
			B : in array_BCD_4DIGITOS;
			RESULTADO : out array_BCD_5DIGITOS
		);
	end component;
	
	signal E1, E2 : array_BCD_4DIGITOS;
	signal estado : std_logic_vector(1 downto 0) := "00";
	
begin

	process(clk, estado)
	begin
		if clk'event and clk = '1' then
			case estado is
				when "00" =>
					E1 <= (('1', '0', '0', '1'), ('1', '0', '0', '1'), ('1', '0', '0', '1'), ('1', '0', '0', '1'));
					E2 <= (('1', '0', '0', '1'), ('1', '0', '0', '1'), ('1', '0', '0', '1'), ('1', '0', '0', '1'));
					estado <= "01";
				when "01" =>
					E1 <= (('0', '0', '0', '1'), ('0', '1', '0', '1'), ('0', '0', '1', '1'), ('0', '0', '0', '0'));
					E2 <= (('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '1', '1'), ('1', '0', '0', '1'));
					estado <= "10";
				when "10" =>
					E1 <= (('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '1', '1', '0'), ('1', '0', '0', '0'));
					E2 <= (('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '1', '0'), ('0', '1', '0', '1'));
					estado <= "11";
				when "11" =>
					E1 <= (('0', '0', '0', '1'), ('0', '0', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'));
					E2 <= (('0', '0', '0', '0'), ('0', '1', '0', '0'), ('0', '0', '0', '0'), ('0', '0', '0', '0'));
					estado <= "00";
				when others =>
					estado <= "00";
			end case;
		end if;
	end process;
	
	--multi : modulo_multiplicador_completo port map(E1, E2, RESULTADO);
	somador : modulo_somador_completo port map(E1, E2, RESULTADO);


end Behavioral;

