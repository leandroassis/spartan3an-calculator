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
		RESULTADO : out array_BCD_8DIGITOS
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
	
	signal E1, E2 : array_BCD_4DIGITOS;
	
begin
	
	E1 <= (('1', '0', '0', '0'), ('1', '0', '0', '0'), ('1', '0', '0', '0'), ('1', '0', '0', '0'));
	E2 <= (('0', '0', '0', '1'), ('0', '0', '0', '1'), ('0', '0', '0', '1'), ('0', '0', '0', '1'));
	
	multi : modulo_multiplicador_completo port map(E1, E2, RESULTADO);


end Behavioral;

