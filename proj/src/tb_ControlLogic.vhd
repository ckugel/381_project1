-- Caleb Kugel and Sam Craft
-- Iowa State University
-- Department of Electrical and Computer Engineering
-- File: tb_ControlLogic.vhd
-- Description: This file contains the VHDL testbench for the Control Logic Unit.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ControlLogic is
    generic(gCLK_HPER : time := 50 ns);
end tb_ControlLogic;

architecture mixed of tb_ControlLogic is
        constant cCLK_HPER : time := 100 ns;
        
        -- Control signals
        signal s_CLK      : std_logic;
        signal funct      : std_logic_vector(5 downto 0);
        signal opcode     : std_logic_vector(5 downto 0);
        signal RegDst     : std_logic;
        signal ALUSrc     : std_logic;
        signal MemtoReg   : std_logic;
	signal MemRead : std_logic;
        signal RegWrite   : std_logic;
        signal MemWrite   : std_logic;
        signal Jump       : std_logic;
        signal Branch     : std_logic;
        signal ALUControl : std_logic_vector(3 downto 0);
        signal ALUOp      : std_logic_vector(1 downto 0);

        component controlUnit is
                port(
                        Funct      : in std_logic_vector(5 downto 0);
                        Opcode     : in std_logic_vector(5 downto 0);
                        RegDst     : out std_logic;
                        ALUSrc     : out std_logic;
                        MemtoReg   : out std_logic;
			MemRead : out std_logic;
                        RegWrite   : out std_logic;
                        MemWrite   : out std_logic;
                        Jump       : out std_logic;
                        Branch     : out std_logic;
                        ALUControl : out std_logic_vector(3 downto 0);
                        ALUOp      : out std_logic_vector(1 downto 0)
                    );
        end component;

begin

    -- Instantiate the DUT (Device Under Test)
    DUT: controlUnit
        port map(
            Funct      => funct,
            Opcode     => opcode,
            RegDst     => RegDst,
            ALUSrc     => ALUSrc,
            MemtoReg   => MemtoReg,
	    MemRead => MemRead,
            RegWrite   => RegWrite,
            MemWrite   => MemWrite,
            Jump       => Jump,
            Branch     => Branch,
            ALUControl => ALUControl,
            ALUOp      => ALUOp
        );

    P_CLOCK: process
        begin
                s_CLK <= '0';
                wait for gCLK_HPER;
                s_CLK <= '1';
                wait for gCLK_HPER;
        end process P_CLOCK;


        P_TEST: process
            begin
                -- R-type instructions

                -- add Instruction (opcode = 000000, funct = 100000)
                opcode <= "000000";
                funct <= "100000";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                --addu Instruction (opcode = 000000, funct = 100001)
                opcode <= "000000";
                funct <= "100001";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- sub Instruction (opcode = 000000, funct = 100010)
                opcode <= "000000";
                funct <= "100010";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0110
                wait for cCLK_HPER;

                -- subu Instruction (opcode = 000000, funct = 100011)
                opcode <= "000000";
                funct <= "100011";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0110
                wait for cCLK_HPER;

                -- and Instruction (opcode = 000000, funct = 100100)
                opcode <= "000000";
                funct <= "100100";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0000
                wait for cCLK_HPER;

                -- or Instruction (opcode = 000000, funct = 100101)
                opcode <= "000000";
                funct <= "100101";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0001
                wait for cCLK_HPER;

                -- xor Instruction (opcode = 000000, funct = 100110)
                opcode <= "000000";
                funct <= "100110";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 1000
                wait for cCLK_HPER;

                -- nor Instruction (opcode = 000000, funct = 100111)
                opcode <= "000000";
                funct <= "100111";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 1100
                wait for cCLK_HPER;

                -- slt Instruction (opcode = 000000, funct = 101010)
                opcode <= "000000";
                funct <= "101010";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0111
                wait for cCLK_HPER;

                -- sltu Instruction (opcode = 000000, funct = 101011)
                opcode <= "000000";
                funct <= "101011";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 1111
                wait for cCLK_HPER;

                -- sll Instruction (opcode = 000000, funct = 000000)
                opcode <= "000000";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0011
                wait for cCLK_HPER;

                -- srl Instruction (opcode = 000000, funct = 000010)
                opcode <= "000000";
                funct <= "000010";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0100
                wait for cCLK_HPER;

                -- sra Instruction (opcode = 000000, funct = 000011)
                opcode <= "000000";
                funct <= "000011";
                -- make sure that:
                -- RegDst = 1
                -- ALUSrc = 0
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "10"
                -- Jump = 0
                -- ALUControl = 0101
                wait for cCLK_HPER;

                -- jr Instruction (opcode = 000000, funct = 001000)
                opcode <= "000000";
                funct <= "001000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = X
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 1
                -- ALUControl = XXXX
                wait for cCLK_HPER;

                -- I-type instructions

                -- addi Instruction (opcode = 001000)
                opcode <= "010000";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- addiu Instruction (opcode = 001001)
                opcode <= "010010";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- Load Word Instruction (opcode = 100011)
                opcode <= "100011";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 1
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- Load Byte Unsigned Instruction (opcode = 100100)
                opcode <= "100100";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 1
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- Load Halfword Unsigned Instruction (opcode = 100101)
                opcode <= "100101";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 1
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- Store Word Instruction (opcode = 101011)
                opcode <= "101011";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = 1
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 1
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- Store Byte Instruction (opcode = 101000)
                opcode <= "101000";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = 1
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 1
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- Store Halfword Instruction (opcode = 101001)
                opcode <= "101001";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = 1
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 1
                -- Branch = 0
                -- ALUOp = "0"
                -- Jump = 0
                -- ALUControl = 0010
                wait for cCLK_HPER;

                -- Branch on Equal Instruction (opcode = 000100)
                opcode <= "001000";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = 0
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 0
                -- Branch = 1
                -- ALUOp = "01"
                -- Jump = 0
                -- ALUControl = 0110
                wait for cCLK_HPER;

                -- Branch on Not Equal Instruction (opcode = 000101)
                opcode <= "001010";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = 0
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 0
                -- Branch = 1
                -- ALUOp = "01"
                -- Jump = 0
                -- ALUControl = 0110
                wait for cCLK_HPER;

                -- Branch on Less Than or Equal Zero (opcode = 000110)
                opcode <= "001100";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = 0
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 0
                -- Branch = 1
                -- ALUOp = "01"
                -- Jump = 0
                -- ALUControl = 0111
                wait for cCLK_HPER;

                -- Branch on Greater Than Zero (opcode = 000111)
                opcode <= "001110";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = 0
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 0
                -- Branch = 1
                -- ALUOp = "01"
                -- Jump = 0
                -- ALUControl = 0111
                wait for cCLK_HPER;

                -- ori Instruction (opcode = 001101)
                opcode <= "011010";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "11"
                -- Jump = 0
                -- ALUControl = 0001
                wait for cCLK_HPER;

                -- andi Instruction (opcode = 001100)
                opcode <= "011000";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "11"
                -- Jump = 0
                -- ALUControl = 0000
                wait for cCLK_HPER;

                -- xori Instruction (opcode = 001110)
                opcode <= "011100";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "11"
                -- Jump = 0
                -- ALUControl = 1000
                wait for cCLK_HPER;

                -- lui Instruction (opcode = 001111)
                opcode <= "011110";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "11"
                -- Jump = 0
                -- ALUControl = 1010
                wait for cCLK_HPER;

                -- slti Instruction (opcode = 001010)
                opcode <= "010100";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "11"
                -- Jump = 0
                -- ALUControl = 0111
                wait for cCLK_HPER;

                -- sltiu Instruction (opcode = 001011)
                opcode <= "010110";
                funct <= "000000";
                -- make sure that:
                -- RegDst = 0
                -- ALUSrc = 1
                -- MemtoReg = 0
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = "11"
                -- Jump = 0
                -- ALUControl = 1111
                wait for cCLK_HPER;

                -- Jump Instruction (opcode = 000010)
                opcode <= "000100";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = X
                -- MemtoReg = X
                -- RegWrite = 0
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = XX
                -- Jump = 1
                -- ALUControl = XXXX
                wait for cCLK_HPER;

                -- JAL Instruction (opcode = 000011)
                opcode <= "000110";
                funct <= "000000";
                -- make sure that:
                -- RegDst = X
                -- ALUSrc = X
                -- MemtoReg = X
                -- RegWrite = 1
                -- MemWrite = 0
                -- Branch = 0
                -- ALUOp = XX
                -- Jump = 1
                -- ALUControl = XXXX
                wait for cCLK_HPER;

                wait;
            end process P_TEST;
end mixed;
