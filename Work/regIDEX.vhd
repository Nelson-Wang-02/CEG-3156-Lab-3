LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regIDEX IS
	PORT(
		i_resetBar		: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_WB		: IN STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
		i_M		: IN STD_LOGIC_VECTOR(2 downto 0); --Branch, MemRead, MemWrite
		i_EX		: IN STD_LOGIC_VECTOR(3 downto 0); --RegDst, ALUOp1, ALUOp0, ALUSrc
		
		i_readReg1		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_readReg2		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_instr15_0		: IN STD_LOGIC_VECTOR(15 downto 0); --address
		i_instr25_21	: IN STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rs
		i_instr20_16 	: IN STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rt
		i_instr15_11	: IN STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rd
		
		o_WB		: OUT STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
		o_M		: OUT STD_LOGIC_VECTOR(2 downto 0); --Branch, MemRead, MemWrite
		o_EX		: OUT STD_LOGIC_VECTOR(3 downto 0); --RegDst, ALUOp1, ALUOp0, ALUSrc
		o_readReg1		: OUT	STD_LOGIC_VECTOR(7 downto 0);
		o_readReg2		: OUT	STD_LOGIC_VECTOR(7 downto 0);
		o_instr15_0		: OUT STD_LOGIC_VECTOR(15 downto 0); --address
		o_instr25_21	: OUT STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rs
		o_instr20_16 	: OUT STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rt
		o_instr15_11	: OUT STD_LOGIC_VECTOR(4 downto 0)); --IF/ID_rd);
		
END regIDEX;

ARCHITECTURE rtl OF regIDEX IS
	SIGNAL sig_WB : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL sig_M : STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL sig_EX : STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL sig_readReg1	: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL sig_readReg2	: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL sig_instr15_0	: STD_LOGIC_VECTOR(15 downto 0); --address
	SIGNAL sig_instr25_21	: STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rs
	SIGNAL sig_instr20_16 : STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rt
	SIGNAL sig_instr15_11	: STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rd);

	COMPONENT eightBitRegister
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;
	
	component fiveBitRegister 
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(4 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(4 downto 0));
	END component;
	
	COMPONENT regWB
		PORT(		
			i_resetBar		: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_regWrite, i_MemtoReg : IN STD_LOGIC; 
			o_regWrite, o_MemtoReg : OUT STD_LOGIC);
	END component;
	
	COMPONENT regM 
		PORT(
			i_resetBar		: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Branch, i_MemRead, i_MemWrite : IN STD_LOGIC; 
			o_Branch, o_MemRead, o_MemWrite : OUT STD_LOGIC);
	END component;	

	COMPONENT regEX
		PORT(
			i_resetBar		: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_RegDst, i_ALUOp1, i_ALUOp0, i_ALUSrc : IN STD_LOGIC; 
			o_RegDst, o_ALUOp1, o_ALUOp0, o_ALUSrc : OUT STD_LOGIC);
	END component;	
	
BEGIN

wb: regWB
		PORT MAP(
			i_resetBar	=> i_resetBar,
			i_clock		=> i_clock,
			i_regWrite	=> i_WB(1),
			i_MemtoReg 	=> i_WB(0),
			o_regWrite	=> sig_WB(1),
			o_MemtoReg 	=> sig_WB(0));	
			
m: regM 
		PORT MAP(
			i_resetBar => i_resetBar,
			i_clock	=> i_clock,
			i_Branch => i_M(2), 
			i_MemRead => i_M(1), 
			i_MemWrite => i_M(0),
			o_Branch => sig_M(2), 
			o_MemRead => sig_M(1), 
			o_MemWrite => sig_M(0));	

ex: regEX
		PORT MAP(
			i_resetBar => i_resetBar,
			i_clock => i_clock,
			i_RegDst => i_EX(3), 
			i_ALUOp1 => i_EX(2), 
			i_ALUOp0 => i_EX(1), 
			i_ALUSrc => i_EX(0), 
			o_RegDst => sig_EX(3), 
			o_ALUOp1 => sig_EX(2), 
			o_ALUOp0 => sig_EX(1),
			o_ALUSrc => sig_EX(0));			

readReg1: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_readReg1, 
			  i_load => '1',
			  i_clock => i_clock,
			  o_Value => sig_readReg1);
			  
readReg2: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_readReg2, 
			  i_load => '1',
			  i_clock => i_clock,
			  o_Value => sig_readReg2);
				 
addr15_0_1: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_instr15_0(15 downto 8), 
			  i_load => '1',
			  i_clock => i_clock,
			  o_Value => sig_instr15_0(15 downto 8));				

addr15_0_0: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_instr15_0(7 downto 0), 
			  i_load => '1',
			  i_clock => i_clock,
			  o_Value => sig_instr15_0(7 downto 0));	  
			  
IFID_Rs: fiveBitRegister 
		PORT MAP(
			i_resetBar => i_resetBar, 
			i_load	=> '1',
			i_clock	=> i_clock,
			i_Value	=> i_instr25_21,
			o_Value	=> sig_instr25_21);
				 
IFID_Rt: fiveBitRegister 
		PORT MAP(
			i_resetBar => i_resetBar, 
			i_load	=> '1',
			i_clock	=> i_clock, 
			i_Value	=> i_instr20_16,
			o_Value	=> sig_instr20_16);
	
IFID_Rd: fiveBitRegister 
		PORT MAP(
			i_resetBar => i_resetBar, 
			i_load	=> '1',
			i_clock	=> i_clock, 
			i_Value	=> i_instr15_11,
			o_Value	=> sig_instr15_11);
			
	-- Output Driver
		o_WB		<= sig_WB;
		o_M		<= sig_M;
		o_EX		<= sig_EX;
		o_readReg1		<= sig_readReg1;
		o_readReg2		<= sig_readReg2;
		o_instr15_0		<= sig_instr15_0;
		o_instr25_21	<= sig_instr25_21;
		o_instr20_16 	<= sig_instr20_16;
		o_instr15_11	<= sig_instr15_11;

END rtl;
