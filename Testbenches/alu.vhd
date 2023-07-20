LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY alu IS
	PORT(
		rData1, rData2 : IN STD_LOGIC_VECTOR(7 downto 0);
		Op 		: IN STD_LOGIC_VECTOR(2 downto 0);
		ALUResult	: OUT STD_LOGIC_VECTOR(7 downto 0);
		Zero : OUT STD_LOGIC);
		
END alu;

ARCHITECTURE rtl OF alu IS

	component eightBitAddSub 
		PORT(
			i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Op				: IN STD_LOGIC;
			o_Zero         : OUT STD_LOGIC;
			o_CarryOut		: OUT	STD_LOGIC;
			o_Diff			: OUT	STD_LOGIC_VECTOR(7 downto 0));	
	
	end component;
	
	component eightBitComparator 
		PORT(
			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component eightBit5to1Mux
		port (
		data_in0   : in  std_logic_vector(7 downto 0);
		data_in1   : in  std_logic_vector(7 downto 0);
		data_in2   : in  std_logic_vector(7 downto 0);
		data_in3   : in  std_logic_vector(7 downto 0);
		data_in4   : in  std_logic_vector(7 downto 0);
		
		select_in  : in  std_logic_vector(2 downto 0);
		
		mux_out    : out std_logic_vector(7 downto 0));
	end component;
	
	signal sig_andOut, sig_orOut : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_GT, sig_LT, sig_EQ : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_Zero, sig_CarryOut : STD_LOGIC;
	signal sig_Diff : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_muxOut : STD_LOGIC_VECTOR(7 downto 0);

BEGIN
	
	-- Concurrent Signal Assignment

	sig_andOut <= rData1 and rData2;
	sig_orOut <= rData1 or rData2;
	
	addSub: eightBitAddSub 
		port map (
			i_Ai => rData1,
			i_Bi => rData2,
			i_Op => Op(0),
			o_Zero => sig_Zero,
			o_CarryOut => sig_CarryOut,
			o_Diff => sig_Diff);
	
	comp: eightBitComparator
		port map(
			i_Ai => rData1,
			i_Bi => rData2, 
			o_GT => sig_GT,
			o_LT => sig_LT,
			o_EQ => sig_EQ);
	
	mux: eightBit5to1Mux 
		port map(
			data_in0 => sig_andOut,
			data_in1 => sig_orOut, 
			data_in2 => sig_Diff,
			data_in3 => sig_Diff, 
			data_in4 => sig_LT,
			select_in => Op,
			mux_out => sig_muxOut);
	
	--Output Driver
	ALUResult <= sig_muxOut; 
	Zero <= sig_Zero;
	
	
END rtl;