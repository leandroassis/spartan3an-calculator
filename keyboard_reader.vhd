----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:35:19 07/28/2022 
-- Design Name: 
-- Module Name:    keyboard_controller - Behavioral 
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

entity keyboard_reader is
	port(
		kbd_data : in STD_LOGIC;
		kbdp_clk : in STD_LOGIC;
		byte : out STD_LOGIC_VECTOR(7 downto 0);
		convert_enable : out STD_LOGIC
	);
end keyboard_reader;

architecture Behavioral of keyboard_reader is

	type states is (start, bit0, bit1, bit2, bit3, bit4, bit5, bit6, bit7, parity);
	signal buffer_kbd : std_logic_vector(9 downto 0);
	signal estado, proximo_estado : states;
	
begin

	process(kbdp_clk, kbd_data)
		begin
			if kbdp_clk'event and kbdp_clk = '1' then
				estado <= proximo_estado;
			end if;
		
			if kbdp_clk'event and kbdp_clk = '0' then
				case estado is
					when start => 
						buffer_kbd(0) <= kbd_data;
						proximo_estado <= bit0;
						convert_enable <= '0';
					when bit0 => 
						buffer_kbd(1) <= kbd_data;
						proximo_estado <= bit1;
						convert_enable <= '0';
					when bit1 => 
						buffer_kbd(2) <= kbd_data;
						proximo_estado <= bit2;
						convert_enable <= '0';
					when bit2 => 
						buffer_kbd(3) <= kbd_data;
						proximo_estado <= bit3;
						convert_enable <= '0';
					when bit3 => 
						buffer_kbd(4) <= kbd_data;
						proximo_estado <= bit4;
						convert_enable <= '0';
					when bit4 => 
						buffer_kbd(5) <= kbd_data;
						proximo_estado <= bit5;
						convert_enable <= '0';
					when bit5 => 
						buffer_kbd(6) <= kbd_data;
						proximo_estado <= bit6;
						convert_enable <= '0';
					when bit6 => 
						buffer_kbd(7) <= kbd_data;
						proximo_estado <= bit7;
						convert_enable <= '0';
					when bit7 => 
						buffer_kbd(8) <= kbd_data;
						proximo_estado <= parity;
						convert_enable <= '1';
					when parity => 
						buffer_kbd(9) <= kbd_data;
						proximo_estado <= start;
						convert_enable <= '1';
				end case;
			end if;
	end process;
	
	process(buffer_kbd)
		begin
		byte <= buffer_kbd(8 downto 1);
	end process;

end Behavioral;

