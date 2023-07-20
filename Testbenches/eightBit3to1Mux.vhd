library ieee;
use ieee.std_logic_1164.all;

entity eightBit3to1Mux is
	port 
		(
			input0, input1, input2 : IN STD_LOGIC_VECTOR(7 downto 0);
			sel : in std_logic_vector(1 downto 0);
			mux_out : out std_logic_vector(7 downto 0));
end eightBit3to1Mux;

architecture struct of eightBit3to1Mux is 
signal sig_muxOut : STD_LOGIC_VECTOR(7 downto 0);

	component oneBit3to1Mux 
		port 
			(
				input0, input1, input2 : IN STD_LOGIC;
				sel : in std_logic_vector(1 downto 0);
				mux_out : out std_logic);
	end component;

begin 

	mux0: oneBit3to1Mux 
		port map(
			input0 => input0(0),
			input1 => input1(0),
			input2 => input2(0),
			sel => sel,
			mux_out => sig_muxOut(0));	

	mux1: oneBit3to1Mux 
		port map(
			input0 => input0(1),
			input1 => input1(1),
			input2 => input2(1),
			sel => sel,
			mux_out => sig_muxOut(1));	
			
	mux2: oneBit3to1Mux 
		port map(
			input0 => input0(2),
			input1 => input1(2),
			input2 => input2(2),
			sel => sel,
			mux_out => sig_muxOut(2));	

	mux3: oneBit3to1Mux 
		port map(
			input0 => input0(3),
			input1 => input1(3),
			input2 => input2(3),
			sel => sel,
			mux_out => sig_muxOut(3));	
		
	mux4: oneBit3to1Mux 
		port map(
			input0 => input0(4),
			input1 => input1(4),
			input2 => input2(4),
			sel => sel,
			mux_out => sig_muxOut(4));	
		
	mux5: oneBit3to1Mux 
		port map(
			input0 => input0(5),
			input1 => input1(5),
			input2 => input2(5),
			sel => sel,
			mux_out => sig_muxOut(5));	


	mux6: oneBit3to1Mux 
		port map(
			input0 => input0(6),
			input1 => input1(6),
			input2 => input2(6),
			sel => sel,
			mux_out => sig_muxOut(6));	

	mux7: oneBit3to1Mux 
		port map(
			input0 => input0(7),
			input1 => input1(7),
			input2 => input2(7),
			sel => sel,
			mux_out => sig_muxOut(7));	

	mux_out <= sig_muxOut;
			
end struct;
