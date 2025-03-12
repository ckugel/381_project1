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

constant cCLK_HPER : time := 100 ns;

architecture mixed of tb_ControlLogic is
	signal opcode : std_logic_vector(6 downto 0);
	signal RegDst : std_logic;
	signal ALUSrc : std_logic;
	signal MemtoReg : std_logic;
	signal RegWrite : std_logic;
	signal MemRead : std_logic;
	signal MemWrite : std_logic;
	signal Branch : std_logic;
	signal ALUOp : std_logic_vector(1 downto 0);
	signal Jump : std_logic;
	signal zero : std_logic;
	
	component ControlLogic is
		port(
			opcode : in std_logic_vector(6 downto 0);
			RegDst : out std_logic;
			ALUSrc : out std_logic;
			MemtoReg : out std_logic;
			RegWrite : out std_logic;
			MemRead : out std_logic;
			MemWrite : out std_logic;
			Branch : out std_logic;
			ALUOp : out std_logic_vector(1 downto 0);
			Jump : out std_logic
		);
	end component;

begin

    P_CLOCK: process
	begin
		s_CLK <= '0';
wait for gCLK_HPER;
		s_CLK <= '1';
		wait for gCLK_HPER;
	end process P_CLOCK;


	P_TEST: process
	    begin
		-- R-type instruction
		opcode <= "0000000";
		-- make sure that:
		-- RegDst = 1
		-- ALUSrc = 0
		-- MemtoReg = 0
		-- RegWrite = 1
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 0
		-- ALUOp = "10"
		-- Jump = 0
		wait for cCLK_HPER;

		-- Load Word Instruction (opcode = 100011)
		opcode <= "100011";
		-- make sure that:
		-- RegDst = 0
		-- ALUSrc = 1
		-- MemtoReg = 1
		-- RegWrite = 1
		-- MemRead = 1
		-- MemWrite = 0
		-- Branch = 0
		-- ALUOp = "00"
		-- Jump = 0
		wait for cCLK_HPER;

		-- Store Word Instruction (opcode = 101011)
		opcode <= "101011";
		-- make sure that:
		-- RegDst = X
		-- ALUSrc = 1
		-- MemtoReg = X
		-- RegWrite = 0
		-- MemRead = 0
		-- MemWrite = 1
		-- Branch = 0
		-- ALUOp = "00"
		-- Jump = 0
		wait for cCLK_HPER;

		-- Branch on Equal Instruction (opcode = 000100)
		opcode <= "000100";
		-- make sure that:
		-- RegDst = X
		-- ALUSrc = 0
		-- MemtoReg = X
		-- RegWrite = 0
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 1
		-- ALUOp = "01"
		-- Jump = 0
		wait for cCLK_HPER;

		-- Branch on Not Equal Instruction (opcode = 000101)
		opcode <= "000101";
		-- make sure that:
		-- RegDst = X
		-- ALUSrc = 0
		-- MemtoReg = X
		-- RegWrite = 0
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 1
		-- ALUOp = "01"
		-- Jump = 0
		wait for cCLK_HPER;

		-- ori Instruction (opcode = 001101)
		opcode <= "001101";
		-- make sure that:
		-- RegDst = 0
		-- ALUSrc = 1
		-- MemtoReg = 0
		-- RegWrite = 1
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 0
		-- ALUOp = "00"
		-- Jump = 0
		wait for cCLK_HPER;

		-- andi Instruction (opcode = 001100)
		opcode <= "001100";
		-- make sure that:
		-- RegDst = 0
		-- ALUSrc = 1
		-- MemtoReg = 0
		-- RegWrite = 1
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 0
		-- ALUOp = "00"
		-- Jump = 0
		wait for cCLK_HPER;

		-- lui Instruction (opcode = 001111)
		opcode <= "001111";
		-- make sure that:
		-- RegDst = 0
		-- ALUSrc = 1
		-- MemtoReg = 0
		-- RegWrite = 1
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 0
		-- ALUOp = "00"
		-- Jump = 0
		wait for cCLK_HPER;

		-- slti Instruction (opcode = 001010)
		opcode <= "001010";
		-- make sure that:
		-- RegDst = 0
		-- ALUSrc = 1
		-- MemtoReg = 0
		-- RegWrite = 1
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 0
		-- ALUOp = "00"
		-- Jump = 0
		wait for cCLK_HPER;


		-- Jump Instruction (opcode = 000010)
		opcode <= "000010";
		-- make sure that:
		-- RegDst = X
		-- ALUSrc = X
		-- MemtoReg = X
		-- RegWrite = 0
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 0
		-- ALUOp = XX
		-- Jump = 1
		wait for cCLK_HPER;

		-- JAL Instruction (opcode = 000011)
		opcode <= "000011";
		-- make sure that:
		-- RegDst = X
		-- ALUSrc = X
		-- MemtoReg = X
		-- RegWrite = 1
		-- MemRead = 0
		-- MemWrite = 0
		-- Branch = 0
		-- ALUOp = XX
		-- Jump = 1
		wait for cCLK_HPER;


		wait;
	    end process P_TEST;
	end mixed;

