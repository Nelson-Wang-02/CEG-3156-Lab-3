library ieee;
use ieee.std_logic_1164.all;

entity oneBit2to1Mux is
	port 
		(
			input0, input1 : IN STD_LOGIC;
			sel : in std_logic;
			mux_out : out std_logic
		);
end oneBit2to1Mux;


architecture struct of oneBit2to1Mux is 
signal sig_muxOut : STD_LOGIC;
begin 

	sig_muxOut <= (not(sel) and input0) or (sel and input1);
	
	mux_out <= sig_muxOut;
	
end struct;
