LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regMEMWB IS
	PORT(
		i_resetBar		: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_WB		: IN STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
		
		i_data : IN STD_LOGIC_VECTOR(7 downto 0); 
		i_instr	: IN STD_LOGIC_VECTOR(4 downto 0); 
		
		o_WB		: OUT STD_LOGIC_VECTOR(1 downto 0); --regWrite, MemtoReg
		o_data		: OUT	STD_LOGIC_VECTOR(7 downto 0);
		o_instr	: OUT STD_LOGIC_VECTOR(4 downto 0));

END regMEMWB;

ARCHITECTURE rtl OF regMEMWB IS
	SIGNAL sig_WB : STD_LOGIC_VECTOR(1 downto 0);
	SIGNAL sig_data	: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL sig_instr	: STD_LOGIC_VECTOR(4 downto 0); 

	COMPONENT eightBitRegister
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;
	
	component fiveBitRegister 
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(4 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(4 downto 0));
	END component;
	
	COMPONENT regWB
		PORT(
			i_resetBar		: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_regWrite, i_MemtoReg : IN STD_LOGIC; 
			o_regWrite, o_MemtoReg : OUT STD_LOGIC);
	END component;
	
BEGIN

wb: regWB
		PORT MAP(
			i_resetBar	=> i_resetBar,
			i_clock		=> i_clock,
			i_regWrite	=> i_WB(1),
			i_MemtoReg 	=> i_WB(0),
			o_regWrite	=> sig_WB(1),
			o_MemtoReg 	=> sig_WB(0));	
		
dataMem: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
				  i_load => '1',
			  i_Value => i_data, 
			  i_clock => i_clock,
			  o_Value => sig_data);

instr: fiveBitRegister 
		PORT MAP(
			i_resetBar => i_resetBar, 
			i_load	=> '1',
			i_clock	=> i_clock,
			i_Value	=> i_instr,
			o_Value	=> sig_instr);
			
	-- Output Driver
		o_WB		<= sig_WB;
		o_data <= sig_data;
		o_instr <= sig_instr; 

END rtl;
