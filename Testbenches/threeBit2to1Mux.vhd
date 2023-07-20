library ieee;
use ieee.std_logic_1164.all;

entity threeBit2to1Mux is
	port 
		(
			input0, input1 : IN STD_LOGIC_VECTOR(2 downto 0);
			sel : in std_logic;
			mux_out : out std_logic_vector(2 downto 0)
		);
end threeBit2to1Mux;


architecture struct of threeBit2to1Mux is 

	component oneBit2to1Mux 
		port 
			(
				input0, input1 : IN STD_LOGIC;
				sel : in std_logic;
				mux_out : out std_logic
			);	
	end component;

signal sig_muxOut : STD_LOGIC_VECTOR(2 downto 0);

begin 

	mux2: oneBit2to1Mux
		port map (
			input0 => input0(2),
			input1 => input1(2),
			sel => sel,
			mux_out => sig_muxOut(2));


	mux1: oneBit2to1Mux
		port map (
			input0 => input0(1),
			input1 => input1(1),
			sel => sel,
			mux_out => sig_muxOut(1));
			

	mux0: oneBit2to1Mux
		port map (
			input0 => input0(0),
			input1 => input1(0),
			sel => sel,
			mux_out => sig_muxOut(0));
	
	mux_out <= sig_muxOut;
	
end struct;
