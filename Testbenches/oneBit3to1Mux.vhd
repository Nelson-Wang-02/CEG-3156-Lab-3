library ieee;
use ieee.std_logic_1164.all;

entity oneBit3to1Mux is
	port 
		(
			input0, input1, input2 : IN STD_LOGIC;
			sel : in std_logic_vector(1 downto 0);
			mux_out : out std_logic
		);
end oneBit3to1Mux;


architecture struct of oneBit3to1Mux is 
signal sig_muxOut : STD_LOGIC;
begin 

	sig_muxOut <= (not(sel(1)) and not(sel(0)) and input0) or (not(sel(1)) and sel(0) and input1) or (sel(1) and not(sel(0)) and input2);
	
	mux_out <= sig_muxOut;
	
end struct;
