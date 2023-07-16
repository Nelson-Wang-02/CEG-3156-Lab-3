LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity thirtyTwoBitAdder is 

	port (
		A, B : IN STD_LOGIC_VECTOR(31 downto 0);
		Sum : OUT STD_LOGIC_VECTOR(31 downto 0));

end thirtyTwoBitAdder; 

architecture rtl of thirtyTwoBitAdder is 

	signal sig_Sum : STD_LOGIC_VECTOR(31 downto 0);
	signal sig_carryOut : STD_LOGIC_VECTOR(3 downto 0);

	component eightBitAdder 
		PORT(
			i_Cin : 	IN STD_LOGIC; -- signal from control path. 
			i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
			
			o_CarryOut		: OUT	STD_LOGIC;
			o_Sum			: OUT	STD_LOGIC_VECTOR(7 downto 0));	
	end component;

	begin 
	
	b24to31: eightBitAdder
		port map (
			i_Cin => sig_carryOut(2),
			i_Ai => A(31 downto 24),
			i_Bi => B(31 downto 24),
			
			o_carryOut => sig_carryOut(3),
			o_Sum => sig_Sum(31 downto 24));
	
	
	b16to23: eightBitAdder
		port map (
			i_Cin => sig_carryOut(1),
			i_Ai => A(23 downto 16),
			i_Bi => B(23 downto 16),
			
			o_carryOut => sig_carryOut(2),
			o_Sum => sig_Sum(23 downto 16));
	
	b8to15: eightBitAdder
		port map (
			i_Cin => sig_carryOut(0),
			i_Ai => A(15 downto 8),
			i_Bi => B(15 downto 8),
			
			o_carryOut => sig_carryOut(1),
			o_Sum => sig_Sum(15 downto 8));
	
	b0to7: eightBitAdder
		port map (
			i_Cin => '0',
			i_Ai => A(7 downto 0),
			i_Bi => B(7 downto 0),
			
			o_carryOut => sig_carryOut(0),
			o_Sum => sig_Sum(7 downto 0));
			
	--output driver
	Sum <= sig_Sum;

end rtl;