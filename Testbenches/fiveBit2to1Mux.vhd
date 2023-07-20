library ieee;
use ieee.std_logic_1164.all;

entity fiveBit2to1Mux is
	port 
		(
			input0, input1 : IN STD_LOGIC_VECTOR(4 downto 0);
			sel : in std_logic;
			mux_out : out std_logic_vector(4 downto 0));
end fiveBit2to1Mux;

architecture struct of fiveBit2to1Mux is 
signal sig_muxOut : STD_LOGIC_VECTOR(4 downto 0);

	component oneBit2to1Mux 
		port 
			(
				input0, input1 : IN STD_LOGIC;
				sel : in std_logic;
				mux_out : out std_logic);
	end component;

begin 

	mux0: oneBit2to1Mux 
		port map(
			input0 => input0(0),
			input1 => input1(0),
			sel => sel,
			mux_out => sig_muxOut(0));	

	mux1: oneBit2to1Mux 
		port map(
			input0 => input0(1),
			input1 => input1(1),
			sel => sel,
			mux_out => sig_muxOut(1));	
			
	mux2: oneBit2to1Mux 
		port map(
			input0 => input0(2),
			input1 => input1(2),
			sel => sel,
			mux_out => sig_muxOut(2));	

	mux3: oneBit2to1Mux 
		port map(
			input0 => input0(3),
			input1 => input1(3),
			sel => sel,
			mux_out => sig_muxOut(3));	
		
	mux4: oneBit2to1Mux 
		port map(
			input0 => input0(4),
			input1 => input1(4),
			sel => sel,
			mux_out => sig_muxOut(4));	

	mux_out <= sig_muxOut;
			
end struct;
