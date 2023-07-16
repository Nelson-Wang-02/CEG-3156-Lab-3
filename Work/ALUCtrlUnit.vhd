LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

Entity ALUCtrlUnit is
	port(
		F: 				IN std_logic_vector(5 downto 0);
		AluOp:			IN std_logic_vector(1 downto 0);
		Operation:		OUT std_logic_vector(2 downto 0)
		);
		
END;
	
ARCHITECTURE struct OF ALUCtrlUnit is
		
BEGIN
			Operation(0) <= ALUOp(1) AND (F(3) OR F(0));
			Operation(1) <= not(F(2)) OR not(AluOp(1));
			Operation(2) <= (F(1) AND ALUOp(1)) OR ALUOp(0);
			
END struct;


			