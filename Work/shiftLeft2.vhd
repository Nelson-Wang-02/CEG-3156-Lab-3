library ieee;
use ieee.std_logic_1164.all;

entity shiftLeft2 is 
	
	port (
		input_instr : IN STD_LOGIC_VECTOR(1 downto 0);
		
		output : OUT STD_LOGIC_VECTOR(3 downto 0));

end shiftLeft2;

architecture struct of shiftLeft2 is 
	
	signal concat : STD_LOGIC_VECTOR(3 downto 0);
	
	begin 
	
	concat <= input_instr & "00";
	
	output <= concat;
	
end struct; 