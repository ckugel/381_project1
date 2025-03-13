-- Caleb Kugel and Sam Craft
-- Iowa State University
-- Department of Electrical and Computer Engineering
-- File: barrelShifter.vhd
-- Description: This file contains the VHDL code for the 32 bit barrel shifter.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity barrelShifter is
	port(
		i_input : in std_logic_vector(31 downto 0);
		i_shiftAmount : in std_logic_vector(4 downto 0);
		i_shiftDirection : in std_logic; -- 0 = right, 1 = left
		i_shiftArOrLo : in std_logic; -- 0 = arithmetic, 1 = logical
		o_result : out std_logic_vector(31 downto 0)
	);
end barrelShifter;

architecture structural of barrelShifter is
	component mux2t1_N is
	    generic(
		N : integer := 32
	    );
	    port(
	    i_S : in std_logic;
	    i_D0 : in std_logic_vector(N-1 downto 0);
	    i_D1 : in std_logic_vector(N-1 downto 0);
	    o_Q : out std_logic_vector(N-1 downto 0)
	    );
	end component;

	component mux2t1 is
	    port(
	    i_S : in std_logic;
	    i_D0 : in std_logic;
	    i_D1 : in std_logic;
	    o_Q : out std_logic
	    );
	end component;

	signal shift_bit : std_logic;

	signal left_shift_in, left_shift_out, shifted : std_logic_vector(31 downto 0);
	signal shift_amount_0_in, shift_amount_1_in, shift_amount_2_in, shift_amount_3_in, shift_amount_4_in : std_logic_vector(31 downto 0);
	signal shift_amount_0_out, shift_amount_1_out, shift_amount_2_out, shift_amount_3_out, shift_amount_4_out : std_logic_vector(31 downto 0);
	signal s_data : std_logic_vector(31 downto 0);

begin

    left_shift_in(0) <= i_input(31);
    left_shift_in(1) <= i_input(30);
    left_shift_in(2) <= i_input(29);
    left_shift_in(3) <= i_input(28);
    left_shift_in(4) <= i_input(27);
    left_shift_in(5) <= i_input(26);
    left_shift_in(6) <= i_input(25);
    left_shift_in(7) <= i_input(24);
    left_shift_in(8) <= i_input(23);
    left_shift_in(9) <= i_input(22);
    left_shift_in(10) <= i_input(21);
    left_shift_in(11) <= i_input(20);
    left_shift_in(12) <= i_input(19);
    left_shift_in(13) <= i_input(18);
    left_shift_in(14) <= i_input(17);
    left_shift_in(15) <= i_input(16);
    left_shift_in(16) <= i_input(15);
    left_shift_in(17) <= i_input(14);
    left_shift_in(18) <= i_input(13);
    left_shift_in(19) <= i_input(12);
    left_shift_in(20) <= i_input(11);
    left_shift_in(21) <= i_input(10);
    left_shift_in(22) <= i_input(9);
    left_shift_in(23) <= i_input(8);
    left_shift_in(24) <= i_input(7);
    left_shift_in(25) <= i_input(6);
    left_shift_in(26) <= i_input(5);
    left_shift_in(27) <= i_input(4);
    left_shift_in(28) <= i_input(3);
    left_shift_in(29) <= i_input(2);
    left_shift_in(30) <= i_input(1);
    left_shift_in(31) <= i_input(0);

    -- determine if left or right shift 
    shiftDir : mux2t1_N
    generic map( N => 32)
    port map(
    i_S => i_shiftDirection,
    i_D0 => i_input,
    i_D1 => left_shift_in,
    o_Q => s_data
    );

    shiftType : mux2t1
    port map(
    i_S => i_shiftArOrLo,
    i_D0 => '0',
    i_D1 => s_data(31),
    o_Q => shift_bit
	);

    shift_amount_0_in(30 downto 0) <= s_data(31 downto 1);
    shift_amount_0_in(31) <= shift_bit;

    shift_amount_mux0 : mux2t1_N
    generic map( N => 32)
    port map(
    i_S => i_shiftAmount(0),
    i_D0 => s_data,
    i_D1 => shift_amount_0_in,
    o_Q => shift_amount_0_out
	);


    shift_amount_1_in(29 downto 0) <= shift_amount_0_out(31 downto 2);
    shift_amount_1_in(31) <= shift_bit;
    shift_amount_1_in(30) <= shift_bit;


    shift_amount_mux1 : mux2t1_N
    generic map( N => 32)
    port map(
    i_S => i_shiftAmount(1),
    i_D0 => shift_amount_0_out,
    i_D1 => shift_amount_1_in,
    o_Q => shift_amount_1_out
);

    shift_amount_2_in(27 downto 0) <= shift_amount_1_out(31 downto 4);
	shift_amount_2_in(31) <= shift_bit;
	shift_amount_2_in(30) <= shift_bit;
	shift_amount_2_in(29) <= shift_bit;
	shift_amount_2_in(28) <= shift_bit;

	shift_amount_mux2 : mux2t1_N
	generic map( N => 32)
	port map(
	i_S => i_shiftAmount(2),
	i_D0 => shift_amount_1_out,
	i_D1 => shift_amount_2_in,
	o_Q => shift_amount_2_out
);

	shift_amount_3_in(23 downto 0) <= shift_amount_2_out(31 downto 8);
	shift_amount_3_in(31) <= shift_bit;
	shift_amount_3_in(30) <= shift_bit;
	shift_amount_3_in(29) <= shift_bit;
	shift_amount_3_in(28) <= shift_bit;
	shift_amount_3_in(27) <= shift_bit;
	shift_amount_3_in(26) <= shift_bit;
	shift_amount_3_in(25) <= shift_bit;
	shift_amount_3_in(24) <= shift_bit;

	shift_amount_mux3 : mux2t1_N
	generic map( N => 32)
	port map(
	i_S => i_shiftAmount(3),
	i_D0 => shift_amount_2_out,
	i_D1 => shift_amount_3_in,
	o_Q => shift_amount_3_out
);

	shift_amount_4_in(15 downto 0) <= shift_amount_3_out(31 downto 16);
	shift_amount_4_in(31) <= shift_bit;
	shift_amount_4_in(30) <= shift_bit;
	shift_amount_4_in(29) <= shift_bit;
	shift_amount_4_in(28) <= shift_bit;
	shift_amount_4_in(27) <= shift_bit;
	shift_amount_4_in(26) <= shift_bit;
	shift_amount_4_in(25) <= shift_bit;
	shift_amount_4_in(24) <= shift_bit;
	shift_amount_4_in(23) <= shift_bit;
	shift_amount_4_in(22) <= shift_bit;
	shift_amount_4_in(21) <= shift_bit;
	shift_amount_4_in(20) <= shift_bit;
	shift_amount_4_in(19) <= shift_bit;
	shift_amount_4_in(18) <= shift_bit;
	shift_amount_4_in(17) <= shift_bit;
	shift_amount_4_in(16) <= shift_bit;

	shift_amount_mux4 : mux2t1_N
	generic map( N => 32)
	port map(
	i_S => i_shiftAmount(4),
	i_D0 => shift_amount_3_out,
	i_D1 => shift_amount_4_in,
	o_Q => shift_amount_4_out
);

	left_shift_out(0) <= shift_amount_4_out(31);
	left_shift_out(1) <= shift_amount_4_out(30);
	left_shift_out(2) <= shift_amount_4_out(29);
	left_shift_out(3) <= shift_amount_4_out(28);
	left_shift_out(4) <= shift_amount_4_out(27);
	left_shift_out(5) <= shift_amount_4_out(26);
	left_shift_out(6) <= shift_amount_4_out(25);
	left_shift_out(7) <= shift_amount_4_out(24);
	left_shift_out(8) <= shift_amount_4_out(23);
	left_shift_out(9) <= shift_amount_4_out(22);
	left_shift_out(10) <= shift_amount_4_out(21);
	left_shift_out(11) <= shift_amount_4_out(20);
	left_shift_out(12) <= shift_amount_4_out(19);
	left_shift_out(13) <= shift_amount_4_out(18);
	left_shift_out(14) <= shift_amount_4_out(17);
	left_shift_out(15) <= shift_amount_4_out(16);
	left_shift_out(16) <= shift_amount_4_out(15);
	left_shift_out(17) <= shift_amount_4_out(14);
	left_shift_out(18) <= shift_amount_4_out(13);
	left_shift_out(19) <= shift_amount_4_out(12);
	left_shift_out(20) <= shift_amount_4_out(11);
	left_shift_out(21) <= shift_amount_4_out(10);
	left_shift_out(22) <= shift_amount_4_out(9);
	left_shift_out(23) <= shift_amount_4_out(8);
	left_shift_out(24) <= shift_amount_4_out(7);
	left_shift_out(25) <= shift_amount_4_out(6);
	left_shift_out(26) <= shift_amount_4_out(5);
	left_shift_out(27) <= shift_amount_4_out(4);
	left_shift_out(28) <= shift_amount_4_out(3);
	left_shift_out(29) <= shift_amount_4_out(2);
	left_shift_out(30) <= shift_amount_4_out(1);
	left_shift_out(31) <= shift_amount_4_out(0);

	shiftDirectionOutputMux : mux2t1_N
	generic map( N => 32)
	port map(
	i_S => i_shiftDirection,
	i_D0 => shift_amount_4_out, 
	i_D1 => left_shift_out,
	o_Q => o_result
    );


end structural;

