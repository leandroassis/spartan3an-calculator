----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:42:40 07/28/2022 
-- Design Name: 
-- Module Name:    key_to_bcd - Behavioral 
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

entity key_to_bcd is
	port(
		key_code : in std_logic_vector(7 downto 0);
		convert_enable : in std_logic;
		BCD_out  : out std_logic_vector(3 downto 0);
		convertido : out std_logic
	);
end key_to_bcd;

architecture Behavioral of key_to_bcd is
	
begin

	process
	begin
		if convert_enable = '1' then
			case key_code is
				when "00010110" => -- Se 16h retorna 1 em BCD
					BCD_out <= "0001";
					convertido <= '1';
				when "00011110" => -- Se 1Eh retorno 2 em BCD
					BCD_out <= "0010";
					convertido <= '1';
				when "00100110" => -- Se 26h retorna 3 em BCD
					BCD_out <= "0011";
					convertido <= '1';
				when "00100101" => -- Se 25h retorna 4 em BCD
					BCD_out <= "0100";
					convertido <= '1';
				when "00010110" =>
					BCD_out <= "0101";
					convertido <= '1';
				when "00010110" =>
					BCD_out <= "0110";
					convertido <= '1';
				when "00010110" =>
					BCD_out <= "0111";
					convertido <= '1';
				when "00010110" =>
					BCD_out <= "1000";
					convertido <= '1';
				when "00010110" =>
					BCD_out <= "1001";
					convertido <= '1';
				when "11110000" => -- Se F0h, bit de break so é ignorado
					BCD_out <= "0000";
					convertido <= '0';
				when otherhs =>
					BCD_out <= "ZZZZ";
					convertido <= '0';
			end case;
		end if;
	end process;


end Behavioral;

