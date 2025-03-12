-- Caleb Kugel
-- Iowa State University
-- Department of Electrical and Computer Engineering

-- PCIncrementor.vhd
-- This file contains the vhdl design for the PCIncrementor module. This module increments an input number by 4.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity PCIncrementor is
	Port ( PC : in  STD_LOGIC_VECTOR (31 downto 0);
		   PCPlus4 : out  STD_LOGIC_VECTOR (31 downto 0));
end PCIncrementor;

architecture behavioral of PCIncrementor is
begin
	PCPlus4 <= std_logic_vector(unsigned(PC) + 4);
end behavioral;

