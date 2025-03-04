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
			ADD_WIDTH : natural := 32
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

	signal globalReset : std_logic; -- anywhere reset can be done it should be done throught this for the start of the program

	signal currentPC : std_logic_vector(31 downto 0); -- coming out of the PC register
	signal nextPC : std_logic_vector(31 downto 0); -- coming out of the mux on the top right in diagram
	signal PCPlus4 : std_logic_vector(31 downto 0); -- coming out of the PC+4 incrementer

	signal jump_address : std_logic_vector(31 downto 0); -- coming out of the shifter with pc + 4 being the top four bits

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
	
	-- dwfine program counter incrementer
	PCInc : ProgramCounterIncrementer
	port map(
		PC => currentPC,
		PCPlus4 => PCPlus4
		)


end structural;

