-- Caleb Kugel and Sam Craft
-- Iowa State University
-- Department of Electrical and Computer Engineering
-- File: singleCycleCPU.vhd
-- Description: This file contains the VHDL code for the single cycle CPU.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- combine the following components into a single entity: ALU, RegisterFile, Memory, Control Unit, Program Counter, Program Counter Incrementer
entity singleCycleCPU is 
end singleCycleCPU;

architecture structurual is
    signal instruction : std_logic_vector(31 downto 0); -- output of instruction memory
    signal aluResult : std_logic_vector(31 downto 0); -- output of AL
    

    component ALU is
		port(
			A : in std_logic_vector(31 downto 0);
			B : in std_logic_vector(31 downto 0);
			ALUControl : in std_logic_vector(3 downto 0);
			result : out std_logic_vector(31 downto 0);
			zero : out std_logic
		);
	end component;

	component RegisterFile is
		port(
			readReg1 : in std_logic_vector(4 downto 0);
			readReg2 : in std_logic_vector(4 downto 0);
			writeReg : in std_logic_vector(4 downto 0);
			writeData : in std_logic_vector(31 downto 0);
			regWrite : in std_logic;
			readData1 : out std_logic_vector(31 downto 0);
			readData2 : out std_logic_vector(31 downto 0)
		);
	end component;

	component Memory is
		port(
			address : in std_logic_vector(31 downto 0);
			writeData : in std_logic_vector(31 downto 0);
			memWrite : in std_logic;
			memRead : in std_logic;
			readData : out std_logic_vector(31 downto 0)
		);
	end component;

	component ControlUnit is
		port(
			opcode : in std_logic_vector(6 downto 0);
			RegDst : out std_logic;
			Jump : out std_logic;
			Branch : out std_logic;
			MemRead : out std_logic;
			MemtoReg : out std_logic;
			ALUOp : out std_logic_vector(2 downto 0);
			MemWrite : out std_logic;
			ALUSrc : out std_logic;
			RegWrite : out std_logic
		);
	end component;

	component ProgramCounter is
		port(
			clk : in std_logic;
			reset : in std_logic;
			enable : in std_logic;
			PC : out std_logic_vector(31 downto 0)
		);
	end component;

	component ProgramCounterIncrementer is
		port(
			clk : in std_logic;
			reset : in std_logic;
			enable : in std_logic;
			PC : in std_logic_vector(31 downto 0);
			PCPlus4 : out std_logic_vector(31 downto 0)
		);
	end component;

	component shifter_2 is
		port(
			input : in std_logic_vector(31 downto 0);
			output : out std_logic_vector(31 downto 0)
		);
	end component;

	component mux2t1_N is
	    generic( N : integer := 16);
	    port(
		i_S : in std_logic;
		i_D0 : in std_logic_vector(N-1 downto 0);
		i_D1 : in std_logic_vector(N-1 downto 0);
		o_Q : out std_logic_vector(N-1 downto 0)
	    );
    	end component;

	component sign_extender_16_32 is
	    port(
		input : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(31 downto 0)
	    );
	end component;

	signal currentPC : std_logic_vector(31 downto 0); -- coming out of the PC register
	signal nextPC : std_logic_vector(31 downto 0); -- coming out of the mux on the top right in diagram
	signal PCPlus4 : std_logic_vector(31 downto 0); -- coming out of the PC+4 incrementer

	signal jump_address : std_logic_vector(31 downto 0); -- coming out of the shifter with pc + 4 being the top four bits

	--TODO: add the Zero signal from the ALU

	signal regDst : std_logic;
	signal jump : std_logic;
	signal branch : std_logic;
	signal memRead : std_logic;
	signal memtoReg : std_logic;
	signal aluOp : std_logic_vector(2 downto 0);
	signal memWrite : std_logic;
	signal aluSrc : std_logic;
	signal regWrite : std_logic;

	signal write_data_reg : std_logic_vector(31 downto 0);
	signal reg_o_s : std_logic_vector(31 downto 0);
	signal reg_o_t : std_logic_vector(31 downto 0);

	signal immeditate_extended : std_logic_vector(31 downto 0);
	signal dmem_read_data : std_logic_vector(31 downto 0);

	signal ALU_result : std_logic_vector(31 downto 0);


end structural;

