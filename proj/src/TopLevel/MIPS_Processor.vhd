-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is
  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  signal s_carryOut : std_logic; -- carry out signal from the ALU

    signal currentPC : std_logic_vector(31 downto 0); -- coming out of the PC register
    signal nextPC : std_logic_vector(31 downto 0); -- coming out of the mux on the top right in diagram
    signal PCPlus4 : std_logic_vector(31 downto 0); -- coming out of the PC+4 incrementer
    signal jumpAddress : std_logic_vector(31 downto 0); -- coming out of the shifter with pc + 4 being the top four bits
    signal aluJump : std_logic_vector(31 downto 0); -- coming out of the jump adder

    signal immediate_shifted_2 : std_logic_vector(31 downto 0); -- coming out of the shifter for the jump adder
    signal aluZeroAndBranch : std_logic;

	signal regDst : std_logic;
	signal jump : std_logic;
	signal branch : std_logic;
	signal memRead : std_logic;
	signal memtoReg : std_logic;
	signal aluOp : std_logic_vector(1 downto 0);
	signal memWrite : std_logic;
	signal aluSrc : std_logic;
	signal s_RegWr : std_logic;

	signal write_data_reg : std_logic_vector(31 downto 0);
	signal s_o_zero : std_logic;

	signal immediate_extended : std_logic_vector(31 downto 0);
	signal dmem_read_data : std_logic_vector(31 downto 0);
	signal ALU_B : std_logic_vector(31 downto 0); -- ALU second input either port s or immediate depending on mux
	signal ALU_operation : std_logic_vector(31 downto 0); -- post ALU op controller into ALU

	 
	signal s_jump_high_mux_in : std_logic_vector(31 downto 0);



  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

    component ALU is
		port(
			A : in std_logic_vector(31 downto 0);
			B : in std_logic_vector(31 downto 0);
			ALUControl : in std_logic_vector(3 downto 0);
			carryOut : out std_logic;
			overflow : out std_logic;
			result : out std_logic_vector(31 downto 0);
			zero : out std_logic
		);
	end component;

	component RegisterFile is
		port(
			i_rs : in std_logic_vector(4 downto 0); -- source register
			i_rt : in std_logic_vector(4 downto 0); -- source register
			i_rd : in std_logic_vector(4 downto 0); -- destination register
			i_wd : in std_logic_vector(31 downto 0); -- data to write
			i_we : in std_logic;
			o_s : out std_logic_vector(31 downto 0); -- output of register specified by i_rs
			o_t : out std_logic_vector(31 downto 0) -- output of register specified by i_rt
		);
	end component;

	component ControlUnit is
	    port(
		Funct : in std_logic_vector(5 downto 0);
		opcode : in std_logic_vector(5 downto 0);
		RegDst : out std_logic;
		ALUSrc : out std_logic;
		MemtoReg : out std_logic;
		MemRead: out std_logic;
		RegWrite : out std_logic;
		MemWrite : out std_logic;
		Jump : out std_logic;
		Branch : out std_logic;
		ALUControl : out std_logic_vector(3 downto 0);
		ALUOp : out std_logic_vector(1 downto 0)
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

	component reg_n is
	    generic(n : integer := 32);
	    port(
		    i_CLK : std_logic;
		    i_RST : std_logic;
		    i_WE : std_logic;
		    i_Data : std_logic_vector(n - 1 downto 0);
		    o_Q : std_logic_vector(n-1 downto 0)
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

	component andg2 is 
	    port (
		i_A : in std_logic;
		i_B : in std_logic;
		o_F : out std_logic
		    );
	end component;

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


	component shifterJump is
	    port(
		instruction : in std_logic_vector(31 downto 0);
		PCPlus4 : in std_logic_vector(31 downto 0);
		output : out std_logic_vector(31 downto 0)
	    );
	end component;

begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU
    s_DMemAddr <= oALUOut;
    s_DMemData <= o_s;

    MainALU: ALU
	port map(
		A =>  reg_o_t,
		B => ALU_B,
		ALUControl => ALU_operation,
		carryOut => s_carryOut,
		overflow => s_Ovfl,
		result => oALUOut,
		zero => s_o_zero
	    );
	-- define the second input (B) for the ALU
	ALU_B_mux : mux2t1_N
	generic map(N => 32)
	port map(
		i_S => aluSrc,
		i_D0 => reg_o_t,
		i_D1 => immeditate_extended,
		o_Q => ALU_B
		);

	-- define the control unit
	controlUnit : controlUnit
	port map(
		opcode => s_Inst(31 downto 26),
		RegDst => regDst,
		Jump => jump,
		Branch => branch,
		MemRead => memRead,
		MemtoReg => memtoReg,
		ALUOp => aluOp,
		MemWrite => s_DMemWr,
		ALUSrc => aluSrc,
		RegWrite => s_RegWr
		);

	-- define the mux for the ALU result or the data memory read data
	memToRegMux : mux2t1_N
	generic map(N => 32)
	port map(
	i_S => memtoReg,
	i_D0 => oALUOut,
	i_D1 => s_DMemOut,
	o_Q => write_data_reg
	);

	-- define the mux for which register to write to
	regDstMux : mux2t1_N
	generic map(N => 5)
	port map(
		i_S => regDst,
		i_D0 => s_Inst(20 downto 16),
		i_D1 => s_Inst(15 downto 11),
		o_Q => writeReg
		);

	-- define the sign extender
	signExtender : sign_extender_16_32
	port map(
		input => s_Inst(15 downto 0),
		output => immeditate_extended
		);

	-- Define the program counter
	programCounterReg : reg_n
	generic map(n => 32)
	port map(
		    i_CLK => iCLK,
		    i_RST => iRST,
		    i_WE => '1',
		    i_Data => s_NextInstAddr,
		    o_Q => currentPC
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
		instruction => s_Inst,
		PCPlus4 => PCPlus4,
		output => s_jump_high_mux_in
		);

-- define the mux for the ALU second input into jump address
    preNextPCmux : mux2t1_N
    generic map(N => 32)
    port map(
	i_S => aluZeroAndBranch,
	i_D0 => nextPC,
	i_D1 => aluJump,
	o_Q => jumpAddress
	);

    nextPCmux : mux2t1_N
    generic map(N => 32)
    port map(
	i_S => jump,
	i_D0 => PCPlus4,
	i_D1 => jumpAddress,
	o_Q => nextPC
    );

	-- define the jump adder
    jumpAdder : Adder 
    generic map(N => 32)
    port map(
	Cin => '0',
	i_A => nextPC,
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


end structure;

