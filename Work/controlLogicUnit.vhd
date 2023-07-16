LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity controlLogicUnit is 
	port (
		op : in std_logic_vector(5 downto 0);
		
		RegDst, ALUSrc : OUT STD_LOGIC;
		MemtoReg, RegWrite : OUT STD_LOGIC;
		MemRead, MemWrite : OUT STD_LOGIC;
		Branch : OUT STD_LOGIC;
		BranchNotEqual : OUT STD_LOGIC;
		Jump : OUT STD_LOGIC;
		ALUOp1, ALUOp0 : OUT STD_LOGIC);

end controlLogicUnit; 
	
architecture rtl of controlLogicUnit is 

	signal rFormat, lw, sw, beq, bne, j : STD_LOGIC;
	
	signal o_ALUSrc, o_RegWrite, o_Branch : STD_LOGIC;
	
	begin
	
	--concurrent signal assignment
	rFormat <= not(op(5)) and not(op(4)) and not(op(3)) and not(op(2)) and not(op(1)) and not(op(0));
	lw <= op(5) and not(op(4)) and not(op(3)) and not(op(2)) and op(1) and op(0);
	sw <= op(5) and not(op(4)) and op(3) and not(op(2)) and op(1) and op(0);
	beq <= not(op(5)) and not(op(4)) and not(op(3)) and op(2) and not(op(1)) and not(op(0));
	bne <= not(op(5)) and not(op(4)) and not(op(3)) and op(2) and not(op(1)) and op(0); 
	j <= not(op(5)) and not(op(4)) and not (op(3)) and not(op(2)) and op(1) and not(op(0));
	
	
	o_ALUSrc <= lw or sw; 
	o_RegWrite <= rFormat or lw;
	o_Branch <= beq;
	
	--output drivers
	RegDst <= rFormat;
	ALUSrc <= o_ALUSrc;
	MemtoReg <= lw; 
	RegWrite <= o_RegWrite;
	MemRead <= lw; 
	MemWrite <= sw; 
	Branch <= o_Branch; 
	BranchNotEqual <= bne;
	Jump <= j;
	ALUOp1 <= rFormat; 
	ALUOp0 <= beq; 
	
end rtl; 
	
	
	