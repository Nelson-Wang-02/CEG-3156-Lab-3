library ieee;
use ieee.std_logic_1164.all;

entity singleCycleProcessor is 

	port (
		GClock, GReset : IN STD_LOGIC; 
		ValueSelect : IN STD_LOGIC_VECTOR(2 downto 0);
		
		MuxOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		InstructionOut : OUT STD_LOGIC_VECTOR(31 downto 0);
		
		BranchOut, ZeroOut, MemWriteOut, RegWriteOut : OUT STD_LOGIC);

end singleCycleProcessor; 

architecture rtl of singleCycleProcessor is 

	component eightBitRegister
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));		
	end component;
	
	component eightBitAddSub
		PORT(
			i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_Op				: IN STD_LOGIC;
			o_Zero         : OUT STD_LOGIC;
			o_CarryOut		: OUT	STD_LOGIC;
			o_Diff			: OUT	STD_LOGIC_VECTOR(7 downto 0));	
	end component;
	
	component instrMem 
		PORT
		(
			address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		);
	END component;

	component dataMem 
		PORT
		(
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			rdaddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			rden		: IN STD_LOGIC  := '1';
			wraddress		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			wren		: IN STD_LOGIC  := '0';
			q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	END component;
	
	
	component alu 
		PORT(
			rData1, rData2 : IN STD_LOGIC_VECTOR(7 downto 0);
			Op 		: IN STD_LOGIC_VECTOR(2 downto 0);
			ALUResult	: OUT STD_LOGIC_VECTOR(7 downto 0);
			Zero : OUT STD_LOGIC);
			
	END component;
	
	component registerFile 
		port (
			i_clk : IN STD_LOGIC;
			i_resetBar : IN STD_LOGIC; 
			i_load : IN STD_LOGIC;
			
			i_readReg1, i_readReg2 : IN STD_LOGIC_VECTOR(2 downto 0);
			
			i_writeRegAddr : IN STD_LOGIC_VECTOR(2 downto 0);
			i_writeData : IN STD_LOGIC_VECTOR(7 downto 0);
		
			o_readData1, o_readData2 : OUT STD_LOGIC_VECTOR(7 downto 0));		
		
	end component; 
	
	component controlLogicUnit 
		port (
			op : in std_logic_vector(5 downto 0);
			
			RegDst, ALUSrc : OUT STD_LOGIC;
			MemtoReg, RegWrite : OUT STD_LOGIC;
			MemRead, MemWrite : OUT STD_LOGIC;
			Branch : OUT STD_LOGIC;
			BranchNotEqual : OUT STD_LOGIC;
			Jump : OUT STD_LOGIC;
			ALUOp1, ALUOp0 : OUT STD_LOGIC);
	
	end component;

	component ALUControlUnit 
		PORT(
			ALUOp : IN STD_LOGIC_VECTOR(1 downto 0);
			F 		: IN STD_LOGIC_VECTOR(5 downto 0);
			Op		: OUT STD_LOGIC_VECTOR(2 downto 0));
	
	end component;
	
	component threeBit2to1Mux
		port (
			input0, input1 : IN STD_LOGIC_VECTOR(2 downto 0);
			sel : in std_logic;
			mux_out : out std_logic_vector(2 downto 0)
		);
	end component;
	
	component eightBit2to1Mux 
		port 
		(
			input0, input1 : IN STD_LOGIC_VECTOR(7 downto 0);
			sel : in std_logic;
			mux_out : out std_logic_vector(7 downto 0));
	end component;
	
	component shiftLeft2 
		port (
			input_instr : IN STD_LOGIC_VECTOR(1 downto 0);
			
			output : OUT STD_LOGIC_VECTOR(3 downto 0));	
	
	end component;
	
	component shiftLeft2_eightBits 
		port (
			input_instr : IN STD_LOGIC_VECTOR(7 downto 0);
			output : OUT STD_LOGIC_VECTOR(7 downto 0));
			
	end component;

	component eightBit6to1Mux 
		port (
			data_in0   : in  std_logic_vector(7 downto 0);
			data_in1   : in  std_logic_vector(7 downto 0);
			data_in2   : in  std_logic_vector(7 downto 0);
			data_in3   : in  std_logic_vector(7 downto 0);
			data_in4   : in  std_logic_vector(7 downto 0);
			data_in5   : in  std_logic_vector(7 downto 0);
			
			select_in  : in  std_logic_vector(2 downto 0);
			
			mux_out    : out std_logic_vector(7 downto 0));
			
	END component;

	signal sig_PCOut : STD_LOGIC_VECTOR(7 downto 0);
	
	signal sig_jumpMuxOut : STD_LOGIC_VECTOR(7 downto 0); 
	
	signal sig_instrMemAddress : STD_LOGIC_VECTOR(31 downto 0);
	
	signal pc4_zero, pc4_cOut : STD_LOGIC;
	signal pc4_diff : STD_LOGIC_VECTOR(7 downto 0);
	
	signal sig_shiftLeft2JOut : STD_LOGIC_VECTOR(3 downto 0);
	signal sig_JumpAddress : STD_LOGIC_VECTOR(7 downto 0);
	
	signal sig_fileRegMuxOut : STD_LOGIC_VECTOR(2 downto 0);
	
	--fileRegister outputs
	signal sig_readData1, sig_readData2 : STD_LOGIC_VECTOR(7 downto 0);
	
	--control signals
	signal sig_RegDst, sig_ALUSrc, sig_MemtoReg, sig_MemRead, sig_MemWrite, sig_Branch, sig_BNE, sig_Jump, sig_RegWrite : STD_LOGIC;
	signal sig_ALUOp : STD_LOGIC_VECTOR(1 downto 0);
	
	--ALU
	signal sig_aluMuxOut : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_ALUOpOut : STD_LOGIC_VECTOR(2 downto 0);
	signal sig_ALUResult : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_ALUZero   : STD_LOGIC;
	
	--branch shift output
	signal sig_branchShiftOut : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_shiftALUOut : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_shiftALUZero : STD_LOGIC;
	signal sig_shiftALUCarryOut : STD_LOGIC;
	
	--branch
	signal sig_branchSel: STD_LOGIC;
	signal sig_branchMuxOut : STD_LOGIC_VECTOR(7 downto 0);	
	
	--Data memory
	signal sig_ReadData : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_dataMuxOut : STD_LOGIC_VECTOR(7 downto 0);
	
	--output 
	signal sig_outputMuxOut : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_otherOutput : STD_LOGIC_VECTOR(7 downto 0);
	
	begin 
	
	--signal assignment
	sig_JumpAddress <= pc4_diff(7 downto 4) & sig_shiftLeft2JOut;
	sig_branchSel <= (sig_Branch and sig_ALUZero) or (sig_BNE and not(sig_ALUZero)); 
	sig_otherOutput <= '0' & sig_RegDst & sig_Jump & sig_MemRead & sig_MemtoReg & sig_ALUOp & sig_ALUSrc;
	
	pcRegister: eightBitRegister
		port map(
			i_resetBar => GReset, 
			i_load => '1',
			i_clock => GClock,		
			i_Value => sig_jumpMuxOut,		
			o_Value =>	sig_PCOut);
			
	pcPlus4: eightBitAddSub
			port map(
			i_Ai => sig_PCOut, 
			i_Bi => "00000100",
			i_Op => '0',
			o_Zero => pc4_zero,
			o_CarryOut => pc4_cOut,
			o_Diff => pc4_diff);	
			
	insMemory: instrMem
		port map(
			address => sig_PCOut,
			clock	=> GClock,
			q => sig_instrMemAddress);
	
	
	lShift2J: shiftLeft2
		port map(
			input_instr => sig_instrMemAddress(1 downto 0),
			output => sig_shiftLeft2JOut);
			
	control: controlLogicUnit
		port map (
			op => sig_instrMemAddress(31 downto 26),
			
			RegDst => sig_RegDst, 
			ALUSrc => sig_ALUSrc,
			MemtoReg => sig_MemtoReg, 
			RegWrite => sig_RegWrite, 
			MemRead => sig_MemRead, 
			MemWrite => sig_MemWrite, 
			Branch => sig_Branch, 
			BranchNotEqual => sig_BNE,
			Jump => sig_Jump, 
			ALUOp1 => sig_ALUOp(1), 
			ALUOp0 => sig_ALUOp(0));
			
	regFileMux: threeBit2to1Mux 
		port map (
		
			input0 => sig_instrMemAddress(18 downto 16),
			input1 => sig_instrMemAddress(13 downto 11),
			sel => sig_RegDst, 
			mux_out => sig_fileRegMuxOut);
	
	regFile: registerFile 
		port map(
			i_clk => GClock,
			i_resetBar => GReset,
			i_load => sig_RegWrite,
			
			i_readReg1 => sig_instrMemAddress(23 downto 21), 
			i_readReg2 => sig_instrMemAddress(18 downto 16),
			
			i_writeRegAddr => sig_fileRegMuxOut,
			i_writeData => sig_dataMuxOut,
		
			o_readData1 => sig_readData1, 
			o_readData2 => sig_readData2);
	
	aluCtrl: ALUControlUnit
		port map(
			ALUOp => sig_ALUOp, 
			F     => sig_instrMemAddress(5 downto 0),
			Op		=> sig_ALUOpOut);
	
	aluMux: eightBit2to1Mux
		port map (
			input0 => sig_readData2, 
			input1 => sig_instrMemAddress(7 downto 0),
			sel => sig_ALUSrc,
			mux_out => sig_aluMuxOut);
			
	arithmeticUnit: alu 
		port map(
			rData1 => sig_readData1, 
			rData2 => sig_aluMuxOut,
			Op => sig_ALUOpOut, 
			ALUResult => sig_ALUResult,
			Zero =>	sig_ALUZero);

	branchShift: shiftLeft2_eightBits
		port map(
			input_instr => sig_instrMemAddress(7 downto 0),
			output => sig_BranchShiftOut);
			
	branchALU: eightBitAddSub 
		port map(
			i_Ai => pc4_diff, 
			i_Bi => sig_BranchShiftOut,
			i_Op => '0',
			o_Zero => sig_shiftALUZero,
			o_CarryOut => sig_shiftALUCarryOut,
			o_Diff => sig_shiftALUOut
		);
		
	branchMux: eightBit2to1Mux
		port map(
			input0 => pc4_diff, 
			input1 => sig_shiftALUOut,
			sel => sig_branchSel,
			mux_out => sig_branchMuxOut);	
			
	jumpMux: eightBit2to1Mux
		port map(
			input0 => sig_branchMuxOut, 
			input1 => sig_JumpAddress,
			sel => sig_Jump,
			mux_out => sig_jumpMuxOut);
	
	dataMemory: dataMem 
		PORT MAP (
			clock => GClock,
			data	=> sig_readData2,
			rdaddress => sig_ALUResult,
			rden => sig_MemRead,
			wraddress => sig_ALUResult,
			wren	=> sig_MemWrite,
			q		=> sig_ReadData);
	
	dataMemMux: eightBit2to1Mux
		port map(
			input0 => sig_ALUResult, 
			input1 => sig_ReadData,
			sel => sig_MemtoReg,
			mux_out => sig_dataMuxOut);
	
	outputMux: eightBit6to1Mux 
		port map(
			data_in0   => sig_PCOut,
			data_in1   => sig_ALUResult,
			data_in2   => sig_readData1,
			data_in3   => sig_readData2,
			data_in4   => sig_dataMuxOut, 
			data_in5   => sig_otherOutput,
			
			select_in  => ValueSelect,
			
			mux_out    => sig_outputMuxOut);
	
	--output driver
	MuxOut <= sig_outputMuxOut;
	instructionOut <= sig_instrMemAddress;
	BranchOut <= sig_Branch;
	ZeroOut <= sig_ALUZero;
	MemWriteOut <= sig_MemWrite;
	RegWriteOut <= sig_RegWrite;
	
	
end rtl; 