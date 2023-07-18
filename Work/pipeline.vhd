LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity pipeline is 

	port (
		GClock, GReset : IN STD_LOGIC; 
		ValueSelect : IN STD_LOGIC_VECTOR(2 downto 0);
		
		MuxOut : OUT STD_LOGIC_VECTOR(7 downto 0);
		InstructionOut : OUT STD_LOGIC_VECTOR(31 downto 0);
		
		BranchOut, ZeroOut, MemWriteOut, RegWriteOut : OUT STD_LOGIC);

end pipeline; 

architecture rtl of pipeline is 

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

	component eightBitComparator IS
		PORT(
			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC_VECTOR(7 downto 0));
	end component;
	
	component forwardingUnit 
		port (
			ExMem_RegWrite : IN STD_LOGIC;
			ExMem_Rd, IdEx_Rs, IdEx_Rt : IN STD_LOGIC_VECTOR(4 downto 0);
			
			MemWb_RegWrite : IN STD_LOGIC;
			MemWb_Rd : IN STD_LOGIC_VECTOR(4 downto 0); 
			
			FA1, FA0, FB1, FB0 : OUT STD_LOGIC);
	end component; 
	
	component hazardDetectionUnit 

		port (
			IDEX_MemRead : IN STD_LOGIC;
			IDEX_Rt, IFID_Rs, IFID_Rt : IN STD_LOGIC_VECTOR(4 downto 0);
			
			o_PCWrite, o_IFIDWrite, o_stallMuxSel : OUT STD_LOGIC);

	end component; 
	
	component regIFID
		PORT(
			i_resetBar, i_IFIDWrite, i_IFFlush	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(39 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(39 downto 0));
	END component;
	
	component regIDEX 
		PORT(
			i_resetBar		: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_WB		: IN STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
			i_M		: IN STD_LOGIC_VECTOR(2 downto 0); --Branch, MemRead, MemWrite
			i_EX		: IN STD_LOGIC_VECTOR(3 downto 0); --RegDst, ALUOp1, ALUOp0, ALUSrc
			
			i_readReg1		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_readReg2		: IN	STD_LOGIC_VECTOR(7 downto 0);
			i_instr15_0		: IN STD_LOGIC_VECTOR(15 downto 0); --address
			i_instr25_21	: IN STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rs
			i_instr20_16 	: IN STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rt
			i_instr15_11	: IN STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rd
			
			o_WB		: OUT STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
			o_M		: OUT STD_LOGIC_VECTOR(2 downto 0); --Branch, MemRead, MemWrite
			o_EX		: OUT STD_LOGIC_VECTOR(3 downto 0); --RegDst, ALUOp1, ALUOp0, ALUSrc
			o_readReg1		: OUT	STD_LOGIC_VECTOR(7 downto 0);
			o_readReg2		: OUT	STD_LOGIC_VECTOR(7 downto 0);
			o_instr15_0		: OUT STD_LOGIC_VECTOR(15 downto 0); --address
			o_instr25_21	: OUT STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rs
			o_instr20_16 	: OUT STD_LOGIC_VECTOR(4 downto 0); --IF/ID_rt
			o_instr15_11	: OUT STD_LOGIC_VECTOR(4 downto 0)); --IF/ID_rd);
			
	END component;
	
	component regEXMEM 
		PORT(
			i_resetBar		: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_WB		: IN STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
			i_M		: IN STD_LOGIC_VECTOR(2 downto 0); --Branch, MemRead, MemWrite
			
			i_ALUResult 	: IN STD_LOGIC_VECTOR(7 downto 0); 
			i_instr	: IN STD_LOGIC_VECTOR(4 downto 0); 
			
			o_WB		: OUT STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
			o_M		: OUT STD_LOGIC_VECTOR(2 downto 0); --Branch, MemRead, MemWrite
			o_ALUResult		: OUT	STD_LOGIC_VECTOR(7 downto 0);
			o_instr	: OUT STD_LOGIC_VECTOR(4 downto 0));

	END component;

	component regMEMWB 
		PORT(
			i_resetBar		: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_WB		: IN STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
			
			i_data : IN STD_LOGIC_VECTOR(7 downto 0); 
			i_instr	: IN STD_LOGIC_VECTOR(4 downto 0); 
			
			o_WB		: OUT STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
			o_data		: OUT	STD_LOGIC_VECTOR(7 downto 0);
			o_instr	: OUT STD_LOGIC_VECTOR(4 downto 0));

	END component;
	
	component nineBit2to1Mux is
		port (
			input0, input1 : IN STD_LOGIC_VECTOR(8 downto 0);
			sel : in std_logic;
			mux_out : out std_logic_vector(8 downto 0));
	end component;
	
	component eightBit3to1Mux is
		port 
			(
				input0, input1, input2 : IN STD_LOGIC_VECTOR(7 downto 0);
				sel : in std_logic_vector(1 downto 0);
				mux_out : out std_logic_vector(7 downto 0));
	end component;
	
	
	component fiveBit2to1Mux 
		port 
			(
				input0, input1 : IN STD_LOGIC_VECTOR(4 downto 0);
				sel : in std_logic;
				mux_out : out std_logic_vector(4 downto 0));
	end component;
	
	component fiveBitComparator
		PORT(
			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(4 downto 0);
			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC_VECTOR(4 downto 0));
	END component;
	
	--IF signals
	--PC signals
	signal sig_PCMux : STD_LOGIC_VECTOR(7 downto 0); 
	signal sig_PCOut : STD_LOGIC_VECTOR(7 downto 0);
	
	
	--Instruction Memory Signals
	signal sig_instrMemAddress : STD_LOGIC_VECTOR(31 downto 0);
	
	--PC+4 Adder signals
	signal pc4_zero, pc4_cOut : STD_LOGIC;
	signal pc4_diff : STD_LOGIC_VECTOR(7 downto 0);
	
	
	--PCMux Signals 
	signal sig_PCSrc : STD_LOGIC;
	
	--IF/ID register signals
	signal sig_IFIDIn : STD_LOGIC_VECTOR(39 downto 0);
	signal sig_IFIDOut : STD_LOGIC_VECTOR(39 downto 0);
	
	--ID Signals
	--ID ALU signals
	signal sig_aluIDOut : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_aluIDCout : STD_LOGIC;
	signal sig_aluIDZero : STD_LOGIC;
	
	--Hazard detection unit signals 
	signal sig_IFIDWrite : STD_LOGIC;
	signal sig_PCWrite : STD_LOGIC; 
	signal sig_stallMuxSel : STD_LOGIC; 
	
	--control logic unit signals 
	signal sig_RegDst, sig_ALUSrc, sig_MemtoReg, sig_MemRead, sig_MemWrite, sig_Branch, sig_BNE, sig_Jump, sig_RegWrite : STD_LOGIC;
	signal sig_ALUOp : STD_LOGIC_VECTOR(1 downto 0);
	signal sig_controlSignals: STD_LOGIC_VECTOR(8 downto 0);
	signal sig_IFFlush : STD_LOGIC;
	
	--register file signals
	signal sig_readData1, sig_readData2 : STD_LOGIC_VECTOR(7 downto 0);
	
	--left shift address signals 
	signal sig_shiftLeft2Out : STD_LOGIC_VECTOR(7 downto 0);
	
	-- control MUX signals
	signal sig_controlMuxOut : STD_LOGIC_VECTOR(8 downto 0);
	
	--register file comparator signals 
	signal sig_regFileCompGT, sig_regFileCompLT, sig_regFileCompEQ : STD_LOGIC_VECTOR(7 downto 0);
	
	--ID/EX register signals 
	signal sig_WB : STD_LOGIC_VECTOR(1 downto 0);
	signal sig_M : STD_LOGIC_VECTOR(2 downto 0);
	signal sig_EX : STD_LOGIC_VECTOR(3 downto 0);
	
	signal sig_WB_out : STD_LOGIC_VECTOR(1 downto 0);
	signal sig_M_out : STD_LOGIC_VECTOR(2 downto 0);
	signal sig_EX_out : STD_LOGIC_VECTOR(3 downto 0);
	
	signal sig_IDEX_readReg1, sig_IDEX_readReg2 : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_instr15_0	 : STD_LOGIC_VECTOR(15 downto 0);
	signal sig_instr25_21, sig_instr20_16, sig_instr15_11 : STD_LOGIC_VECTOR(4 downto 0);

	
	--ID/EX multiplexer signals 
	signal sig_MuxALU1, sig_MuxALU2, sig_MuxALU3 : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_RegDstMuxOut : STD_LOGIC_VECTOR(4 downto 0);
	
	--ALU output 
	signal sig_ALUOpOut : STD_LOGIC_VECTOR(2 downto 0);
	signal sig_ALUZero : STD_LOGIC;
	signal sig_ALUResult : STD_LOGIC_VECTOR(7 downto 0);
	
	--EX/MEM register 
	signal sig_EXMEM_WB : STD_LOGIC_VECTOR(1 downto 0);
	signal sig_EXMEM_M : STD_LOGIC_VECTOR(2 downto 0);
	signal sig_EXMEM_ALUResult : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_EXMEM_instr		: STD_LOGIC_VECTOR(4 downto 0);
	signal sig_readData2Instant : STD_LOGIC_VECTOR(7 downto 0);
	
	
	--forwarding Unit signals 
	signal sig_FA1, sig_FA0, sig_FB1, sig_FB0 : STD_LOGIC;
	signal sig_FA, sig_FB : STD_LOGIC_VECTOR(1 downto 0);
	
	--data memory signal 
	signal sig_dataMemOut : STD_LOGIC_VECTOR(7 downto 0);
	
	--WB 
	--MEM/WB registers
	signal sig_MEMWB_dataMemAddr : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_MEMWB_WB : STD_LOGIC_VECTOR(1 downto 0);
	signal sig_MEMWB_data : STD_LOGIC_VECTOR(7 downto 0);
	signal sig_MEMWB_instr : STD_LOGIC_VECTOR(4 downto 0);
	
	--MEM/WB mux signals 
	signal sig_MEMWB_MUX_Out : STD_LOGIC_VECTOR(7 downto 0);
	
	begin 
	
	--concurrent signal assignment
	sig_IFIDIn <= pc4_diff & sig_instrMemAddress;
	sig_controlSignals <= sig_RegDst & sig_ALUOp & sig_ALUSrc & sig_Branch & sig_MemRead & sig_MemWrite & sig_RegWrite & sig_MemtoReg;
	sig_IFFlush <= sig_Branch;
	sig_PCSrc <= sig_regFileCompEQ(0);
	
	sig_WB <= sig_controlMuxOut(1 downto 0);
	sig_M <= sig_controlMuxOut(4 downto 2); 
	sig_EX <= sig_controlMuxOut(8 downto 5);
	
	sig_FA <= sig_FA1 & sig_FA0;
	sig_FB <= sig_FB1 & sig_FB0;
	
	--IF Stage
	pc: eightBitRegister 
		port map (
			i_resetBar => GReset, 
			i_load => sig_PCWrite,
			i_clock => GClock,
			i_Value => sig_PCMux,
			o_Value => sig_PCOut);
	
	insMemory: instrMem
		port map(
			address => sig_PCOut,
			clock	=> GClock,
			q => sig_instrMemAddress);
	
	pcPlus4: eightBitAddSub
			port map(
			i_Ai => sig_PCOut, 
			i_Bi => "00000100", --4
			i_Op => '0', --Add
			o_Zero => pc4_zero,
			o_CarryOut => pc4_cOut,
			o_Diff => pc4_diff);	
		
	PCMux: eightBit2to1Mux
		port map (
			input0 => pc4_diff, 
			input1 => sig_aluIDOut,
			sel => sig_PCSrc,
			mux_out => sig_PCMux);	
	
	reg_IFID: regIFID		
		PORT MAP(
			i_resetBar => GReset, 
			i_IFIDWrite	=> sig_IFIDWrite,
			i_IFFlush 	=> sig_IFFlush,
			i_clock		=> GClock,
			i_Value		=> sig_IFIDIn,
			o_Value		=> sig_IFIDOut);
	
	--ID stage 
	hazard: hazardDetectionUnit 
		port map(
			IDEX_MemRead => sig_M_out(1), 
			IDEX_Rt => sig_instr20_16, 
			IFID_Rs => sig_instrMemAddress(25 downto 21), 
			IFID_Rt => sig_instrMemAddress(20 downto 16),
			
			o_PCWrite => sig_PCWrite, 
			o_IFIDWrite => sig_IFIDWrite, 
			o_stallMuxSel => sig_stallMuxSel);
	
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
			
	controlMux: nineBit2to1Mux 
		port map(
			input0 => sig_controlSignals, 
			input1 => "000000000",
			sel => sig_stallMuxSel,			
			mux_out => sig_controlMuxOut);
			

	shift2_ID: shiftLeft2_eightBits 
		port map (
			input_instr => sig_instrMemAddress(7 downto 0),	
			output => sig_shiftLeft2Out);
			
	ALU_ID: eightBitAddSub
		port map(
			i_Ai => sig_IFIDOut(39 downto 32), --pc + 4 
			i_Bi => sig_shiftLeft2Out,
			i_Op => '0', --Add
			o_Zero => sig_aluIDZero,
			o_CarryOut => sig_aluIDCout,
			o_Diff => sig_aluIDOut);		
			
			
	regFile: registerFile --add signals later.
		port map(
			i_clk => GClock,
			i_resetBar => GReset,
			i_load => sig_MEMWB_WB(1), --RegWrite
			
			i_readReg1 => sig_instrMemAddress(23 downto 21), 
			i_readReg2 => sig_instrMemAddress(18 downto 16),
			
			i_writeRegAddr => sig_MEMWB_instr(2 downto 0),
			i_writeData => sig_MEMWB_MUX_Out,
		
			o_readData1 => sig_readData1, 
			o_readData2 => sig_readData2);	
	
	branchEqual: eightBitComparator 
		PORT MAP(
			i_Ai => sig_readData1, 
			i_Bi => sig_readData2,		
			o_GT => sig_regFileCompGT, 
			o_LT => sig_regFileCompLT, 
			o_EQ => sig_regFileCompEQ);
	
	reg_IDEX: regIDEX 
		PORT MAP(
			i_resetBar		=> GReset,
			i_clock			=> GClock,
			i_WB		=> sig_WB, --regWrite, MemtoReg
			i_M		=> sig_M, --Branch, MemRead, MemWrite
			i_EX		=> sig_EX, --RegDst, ALUOp1, ALUOp0, ALUSrc
			
			i_readReg1		=> sig_readData1,
			i_readReg2		=> sig_readData2, 
			i_instr15_0		=> sig_instrMemAddress(15 downto 0), --address
			i_instr25_21	=> sig_instrMemAddress(25 downto 21), --IF/ID_rs
			i_instr20_16 	=> sig_instrMemAddress(20 downto 16), --IF/ID_rt
			i_instr15_11	=> sig_instrMemAddress(15 downto 11), --IF/ID_rd
			
			o_WB		=>  sig_WB_out, --regWrite, MemtoReg
			o_M		=>  sig_M_out, --Branch, MemRead, MemWrite
			o_EX	 	=> sig_EX_out, --RegDst, ALUOp1, ALUOp0, ALUSrc
			o_readReg1		=> sig_IDEX_readReg1,
			o_readReg2		=> sig_IDEX_readReg2,
			o_instr15_0		=> sig_instr15_0, --address
			o_instr25_21	=> sig_instr25_21, --ID/EX_rs
			o_instr20_16 	=> sig_instr20_16, --ID/EX_rt
			o_instr15_11	=> sig_instr15_11); --ID/EX_rd);
			
	--EX stage 
	
	aluIN1: eightBit3to1Mux 
		port map(
				input0 => sig_IDEX_readReg1, 
				input1 => sig_EXMEM_ALUResult, 
				input2 => sig_MEMWB_MUX_Out,
				sel => sig_FA,
				mux_out => sig_MuxALU1);
	 
	aluIN2: eightBit3to1Mux 
		port map(
				input0 => sig_IDEX_readReg2, 
				input1 => sig_EXMEM_ALUResult, 
				input2 => sig_MEMWB_MUX_Out,
				sel => sig_FB,
				mux_out => sig_MuxALU2);	
	
	aluIN2_1: eightBit2to1Mux
		port map (
			input0 => sig_MuxALU2, 
			input1 => sig_instr15_0(7 downto 0),
			sel => sig_EX_out(0), --ALUSrc
			mux_out => sig_MuxALU3);
	 
	exALU: alu 
		PORT MAP(
			rData1 => sig_MuxALU1, 
			rData2 => sig_MuxALU3,
			Op 		=> sig_ALUOpOut,
			ALUResult	=> sig_ALUResult,
			Zero  => sig_ALUZero);		

	aluCtrl: ALUControlUnit
		port map(
			ALUOp => sig_EX_out(2 downto 1), 
			F     => sig_instr15_0(5 downto 0),
			Op		=> sig_ALUOpOut);	
	
	regDstMux: fiveBit2to1Mux 
		port map (
				input0 => sig_instr20_16, 
				input1 => sig_instr15_11, 
				sel => sig_EX_out(3), --RegDst
				mux_out => sig_RegDstMuxOut);
	
	reg_EXMEM: regEXMEM 
		PORT MAP(
			i_resetBar	=> GReset,
			i_clock		=> GClock,
			i_WB			=> sig_WB_out, --regWrite, MemtoReg
			i_M			=> sig_M_out,  --Branch, MemRead, MemWrite
			
			i_ALUResult => sig_ALUResult,
			i_instr		=> sig_RegDstMuxOut,
			
			o_WB			=> sig_EXMEM_WB, --regWrite, MemtoReg
			o_M			=> sig_EXMEM_M,  --Branch, MemRead, MemWrite
			o_ALUResult	=> sig_EXMEM_ALUResult,
			o_instr		=> sig_EXMEM_instr);

	readData2_inst: eightBitRegister 
		port map (
			i_resetBar => GReset, 
			i_load => '1',
			i_clock => GClock,
			i_Value => sig_IDEX_readReg2,
			o_Value => sig_readData2Instant);		
		
	fUnit: forwardingUnit 
		port map (
			ExMem_RegWrite => sig_EXMEM_WB(1),
			ExMem_Rd => sig_EXMEM_instr, 
			IdEx_Rs => sig_instr25_21, 
			IdEx_Rt => sig_instr20_16,
			
			MemWb_RegWrite => sig_MEMWB_WB(1), 
			MemWb_Rd => sig_MEMWB_instr,  
			
			FA1 => sig_FA1, 
			FA0 => sig_FA0, 
			FB1 => sig_FB1, 
			FB0 => sig_FB0);	 
	 
	 --MEM stage
	dataMemory: dataMem 
		PORT MAP (
			clock => GClock,
			data	=> sig_readData2Instant,
			rdaddress => sig_EXMEM_ALUResult,
			rden => sig_EXMEM_M(1), --MemRead
			wraddress => sig_EXMEM_ALUResult,
			wren	=> sig_EXMEM_M(0), --MemWrite
			q		=> sig_dataMemOut);	 
	 
	reg_MEMWB: regMEMWB 
		PORT MAP(
			i_resetBar => GReset,
			i_clock	  => GClock,
			i_WB		  => sig_EXMEM_WB, --regWrite, MemtoReg
			
			i_data 	  => sig_dataMemOut,
			i_instr	  => sig_EXMEM_instr,
			
			o_WB		  => sig_MEMWB_WB, --regWrite, MemtoReg
			o_data	  => sig_MEMWB_data,
			o_instr	  => sig_MEMWB_instr);
			
	reg_MEMWB_dataMemAddr: eightBitRegister 
		port map (
			i_resetBar => GReset, 
			i_load => '1',
			i_clock => GClock,
			i_Value => sig_EXMEM_ALUResult,
			o_Value => sig_MEMWB_dataMemAddr);
	 
	MEMWB_MUX: eightBit2to1Mux
		port map (
			input0 => sig_MEMWB_data, 
			input1 => sig_MEMWB_dataMemAddr,
			sel => sig_MEMWB_WB(0), --MemtoReg
			mux_out => sig_MEMWB_MUX_Out);
			
end rtl;