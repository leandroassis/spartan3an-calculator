----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:05:28 07/28/2022 
-- Design Name: 
-- Module Name:    teste_keyboard - Behavioral 
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

entity teste_keyboard is
	port( 
		saida : out std_logic_vector(7 downto 0)
	);
end teste_keyboard;

architecture Behavioral of teste_keyboard is
	component keyboard_controller 
		port(
		kbd_data : in STD_LOGIC;
		kbdp_clk : in STD_LOGIC;
		byte : out STD_LOGIC_VECTOR(7 downto 0)
	);
	end component;
	
	signal clock: std_logic;
--																  Start b0  b1   b2  b3  b4  b5  b6  b7  par Start b0  b1  b2  b3  b4  b5  b6  b7  par
	signal buff : std_logic_vector(39 downto 0) := ('0', '0','0','0','0','0','0','0','1', '0' ,'0', '0','0','1','0','0','0','1','1', '0',
																	'0', '0','1','0','0','0','1','0','1', '0' ,'0', '0','1','1','0','0','1','1','1', '0');
	signal aux : std_logic;
	signal cont : integer := 0;
	
begin

	--key_read : keyboard_controller port map(aux, clock, saida);
	
	process(clock)
		begin
			if clock'event and clock = '1' then
				aux <= buff(cont);
				if cont = 39 then
					cont <= 0;
				else cont <= cont+1;
				end if;
			end if;
	end process;
	
 

end Behavioral;

