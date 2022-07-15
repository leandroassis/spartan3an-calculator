--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.numeric_std.ALL;

package BCD is
	type array_BCD_4DIGITOS is array(3 downto 0) of unsigned(3 downto 0);
	type array_BCD_5DIGITOS is array(4 downto 0) of unsigned(3 downto 0);
	type array_BCD_6DIGITOS is array(5 downto 0) of unsigned(3 downto 0);
	type array_BCD_7DIGITOS is array(6 downto 0) of unsigned(3 downto 0);
	type array_BCD_8DIGITOS is array(7 downto 0) of unsigned(3 downto 0);
end BCD;

package body BCD is
end BCD;
