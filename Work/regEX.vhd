LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regEX IS
	PORT(
		i_resetBar		: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_RegDst, i_ALUOp1, i_ALUOp0, i_ALUSrc : IN STD_LOGIC; 
		o_RegDst, o_ALUOp1, o_ALUOp0, o_ALUSrc : OUT STD_LOGIC);
END regEX;

ARCHITECTURE rtl OF regEX IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(3 downto 0);

	COMPONENT enARdFF_2 
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END component;

BEGIN

regdst: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_RegDst,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_Value(3),
	        o_qBar => int_notValue(3));

aluop1: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_ALUOp1,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_Value(2),
	        o_qBar => int_notValue(2));

aluop2: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_ALUOp0,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_Value(1),
	        o_qBar => int_notValue(1));

alusrc: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_ALUSrc, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_Value(0),
	        o_qBar => int_notValue(0));		  
				 
	-- Output Driver
	o_RegDst <= int_Value(3);
	o_ALUOp1 <= int_Value(2);
	o_ALUOp0 <= int_Value(1);
	o_ALUSrc <= int_Value(0);

END rtl;
