-- Caleb Kugel
-- Iowa State University
-- Department of Electrical and Computer Engineering

-- ShiftLeftTwo.vhd
-- This file contains the VHDL code to shift a 32-bit input left by two bits.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftLeftTwo is
	Port ( input : in  STD_LOGIC_VECTOR (31 downto 0);
		   output : out  STD_LOGIC_VECTOR (31 downto 0));
end ShiftLeftTwo;

architecture Behavioral of ShiftLeftTwo is
begin
	output(31 downto 2) <= input(29 downto 0);
	output(1 downto 0) <= "00";
end Behavioral;
