-- Caleb Kugel and Sam Craft
-- Iowa State University
-- Department of Electrical and Computer Engineering
-- File: singleCycleCPU.vhd
-- Description: This file contains the VHDL code for the single cycle CPU.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- combine the following components into a single entity: ALU, RegisterFile, Memory, Control Unit, Program Counter, Program Counter Incrementer
entity singleCycleCPU is 
    port(
	    i_clk : in std_logic;
	);
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

	component mem is
		generic(
			DATA_WIDTH : natural := 32,
			ADDR_WIDTH : natural := 32
		       );
		port(
		clk : in std_logic;
		addr : in std_logic_vector(ADDR_WIDTH - 1 downto 0);
		data : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		we : in std_logic := '1';
		q : out std_logic_vector(DATA_WIDTH-1 downto 0)
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

	component reg_n is
	    generic(n : integer : 32);
	    port(
		    i_CLK : std_logic;
		    i_RST : std_logic;
		    i_WE : std_logic;
		    i_Data : std_logic_vector(n - 1 downto 0);
		    o_Q : std_logic_vector(n-1 downto 0)
		);

	component sign_extender_16_32 is
	    port(
		input : in std_logic_vector(15 downto 0);
		output : out std_logic_vector(31 downto 0)
	    );
	end component;

	component andg2 is 
	    port (
		i_A : in std_logic;
		i_B : in std_logic;
		o_F : out std_logic;
		    );

	component Adder is
	    generic(N : integer := 16);
	    port(
	    Cin : in std_logic;
	    i_A : in std_logic_vector(N-1 downto 0);
	    i_B : in std_logic_vector(N-1 downto 0);
	Cout : out std_logic;
	    o_sum : out std_logic_vector(N-1 downto 0)
	    );
	end component;

	component registerFile is
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


	component shifterJump is
	    port(
		instruction : in std_logic_vector(31 downto 0);
		PCPlus4 : in std_logic_vector(31 downto 0);
		output : out std_logic_vector(31 downto 0)
	    );
	end component;

	component ALUControl is
	    port(
		ALUOp : in std_logic_vector(2 downto 0);
		ALUControl : out std_logic_vector(3 downto 0)
	    );
	end component;

	signal globalReset : std_logic; -- anywhere reset can be done it should be done throught this for the start of the program

	signal currentPC : std_logic_vector(31 downto 0); -- coming out of the PC register
	signal nextPC : std_logic_vector(31 downto 0); -- coming out of the mux on the top right in diagram
	signal PCPlus4 : std_logic_vector(31 downto 0); -- coming out of the PC+4 incrementer

	signal jump_address : std_logic_vector(31 downto 0); -- coming out of the shifter with pc + 4 being the top four bits
	signal aluJump : std_logic_vector(31 downto 0); -- coming out of the jump adder
	signal immediate_shifted_2 : std_logic_vector(31 downto 0); -- coming out of the shifter for the jump adder
	signal aluZeroAndBranch : std_logic;
	signal writeReg : std_logic_vector(4 downto 0); -- coming out of the mux for the register file


	--TODO: add the Zero signal from the ALU

	signal instruction : std_logic_vector(31 downto 0);

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
	signal s_o_zero : std_logic;

	signal immeditate_extended : std_logic_vector(31 downto 0);
	signal dmem_read_data : std_logic_vector(31 downto 0);
	signal ALU_B : std_logic_vector(31 downto 0); -- ALU second input either port s or immediate depending on mux
	signal ALU_operation : std_logic_vector(31 downto 0); -- post ALU op controller into ALU

	signal ALU_result : std_logic_vector(31 downto 0);
	 
	signal s_jump_high_mux_in : std_logic_vector(31 downto 0);

	-- Define ALU inputs and outputs
	ALU0: ALU
	port map(
		A =>  reg_o_t,
		B => ALU_B,
		ALUControl => ALU_operation,
		result => ALU_result,
		zero => s_o_zero,
	    );

	-- Define the program counter
	programCounterReg : reg_n
	generic map(n => 32);
	port map(
		    i_CLK => ,
		    i_RST => ,
		    i_WE => '1',
		    i_Data => nextPC,
		    o_Q => currentPC
		);

	-- define the read only instruction memory
	instructionMemory : mem 
	generic map (
	DATA_WIDTH => 32,
	ADDR_WIDTH => 10
		    );
		    port map(
		    clk => i_clk,
		    addr => currentPC, 
		    we => '0',
		    q => instruction
			    );
	
	-- define program counter incrementer
	PCInc : ProgramCounterIncrementer
	port map(
		PC => currentPC,
		PCPlus4 => PCPlus4
		);


-- define the mux for next PC
-- the select value in the mux should be from a control signal
-- The high value should be the shifted instruction 25 downto 0 bits and the top four bits should be the PC + 4
	shifter_jumper : shifterJump
	port map(
		instruction => instruction,
		PCPlus4 => PCPlus4,
		output => s_jump_high_mux_in
		);

-- define the mux for the ALU second input into jump address
    preNextPCmux : mux2t1_N
    generic map(N => 32);
    port map(
	i_S => aluZeroAndBranch,
	i_D0 => nextPC,
	i_D1 => aluJump,
	o_Q => jump_address
	);

    -- define the jump adder
    jumpAdder : Adder 
    generic map(N => 32);
    port map(
	Cin => '0',
	i_A nextPC,
	i_B => immediate_shifted_2,
	Cout => open,
	o_sum => aluJump
    );

    -- shifter for the jump alu
    shifter2_1 : shifter_2
    port map(
	input => immediate_extended,
	output => immediate_shifted_2
	);

-- define the and gate which makes up the select line for the second mux
    andGate : andg2
    port map(
    i_A => branch,
    i_B => s_o_zero,
    o_F => aluZeroAndBranch
	);
nextPCmux : mux2t1_N
generic map(N => 32);
port map(
    i_S => jump,
    i_D0 => PCPlus4,
    i_D1 => jump_address,
    o_Q => nextPC
	);

	-- define the control unit
	controlUnit : ControlUnit
	port map(
		opcode => instruction(31 downto 26),
		RegDst => regDst,
		Jump => jump,
		Branch => branch,
		MemRead => memRead,
		MemtoReg => memtoReg,
		ALUOp => aluOp,
		MemWrite => memWrite,
		ALUSrc => aluSrc,
		RegWrite => regWrite
		);

	-- define the mux for which register to write to
	regDstMux : mux2t1_N
	generic map(N => 5);
	port map(
		i_S => regDst,
		i_D0 => instruction(20 downto 16),
		i_D1 => instruction(15 downto 11),
		o_Q => writeReg
		);

	-- define the register file
	registerFile : RegisterFile
	port map(
		readReg1 => instruction(25 downto 21),
		readReg2 => instruction(20 downto 16),
		writeReg => writeReg,
		writeData => write_data_reg,
		regWrite => regWrite,
		readData1 => reg_o_s,
		readData2 => reg_o_t
		);

	-- define the sign extender
	signExtender : sign_extender_16_32
	port map(
		input => instruction(15 downto 0),
		output => immeditate_extended
		);

	-- define the ALU control
	aluctrl : ALUControl	
	port map(
		ALUOp => aluOp,
		ALUControl => ALU_operation
		);

	-- define the second input (B) for the ALU
	ALU_B_mux : mux2t1_N
	generic map(N => 32);
	port map(
		i_S => aluSrc,
		i_D0 => reg_o_t,
		i_D1 => immeditate_extended,
		o_Q => ALU_B
		);

	-- define the ALU
	alu : ALU
	port map(
		A => reg_o_s,
		B => ALU_B,
		ALUControl => ALU_operation,
		result => ALU_result,
		zero => s_o_zero
		);


	-- define the data memory
	--TODO: what is mem read???? I think its needed here?
	dataMemory : mem
	generic map(
		DATA_WIDTH => 32,
		ADDR_WIDTH => 32
		);
	port map(
	    clk => i_clk,
	    addr => ALU_result,
	    data => reg_o_t,
	    we => memWrite,
	    q => dmem_read_data
	);

-- define the mux for the ALU result or the data memory read data
	memToRegMux : mux2t1_N
	generic map(N => 32);
	port map(
	i_S => memtoReg,
	i_D0 => ALU_result,
	i_D1 => dmem_read_data,
	o_Q => write_data_reg
	);

	


end structural;

