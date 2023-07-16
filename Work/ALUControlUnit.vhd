LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ALUControlUnit IS
	PORT(
		ALUOp : IN STD_LOGIC_VECTOR(1 downto 0);
		F 		: IN STD_LOGIC_VECTOR(5 downto 0);
		Op		: OUT STD_LOGIC_VECTOR(2 downto 0));
END ALUControlUnit;

ARCHITECTURE rtl OF ALUControlUnit IS

	SIGNAL sig_op2, sig_op1, sig_op0 : STD_LOGIC;

BEGIN

	-- Concurrent Signal Assignment
	sig_op2 <= ALUOp(1) and F(3) and not(F(2)) and F(1) and not(F(0));
	sig_op1 <= (ALUOp(1) and not(ALUOp(0))) or ALUOp(0) or (ALUOp(1) and not(F(3)) and not(F(2)) and not(F(0)));
	sig_op0 <= ALUOp(0) or (ALUOp(1) and not(F(3)));

	--Output Driver
	Op <= sig_op2 & sig_op1 & sig_op0;	  

END rtl;