library ieee;
use ieee.std_logic_1164.all;

entity shiftLeft2_eightBits is 
	
	port (
		input_instr : IN STD_LOGIC_VECTOR(7 downto 0);
		
		output : OUT STD_LOGIC_VECTOR(7 downto 0));

end shiftLeft2_eightBits;

architecture struct of shiftLeft2_eightBits is 
	
	signal concat : STD_LOGIC_VECTOR(7 downto 0);
	
	begin 
	
	concat <= input_instr(5 downto 0) & "00";
	
	output <= concat;
	
end struct; 