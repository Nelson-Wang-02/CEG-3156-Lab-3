LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regWB IS
	PORT(
		i_resetBar		: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_regWrite, i_MemtoReg : IN STD_LOGIC; 
		o_regWrite, o_MemtoReg : OUT STD_LOGIC);
END regWB;

ARCHITECTURE rtl OF regWB IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(1 downto 0);

	COMPONENT enARdFF_2 
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END component;

BEGIN

top: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_regWrite,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_Value(1),
	        o_qBar => int_notValue(1));

bot: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_MemtoReg, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_Value(0),
	        o_qBar => int_notValue(0));		  
				 
	-- Output Driver
	o_RegWrite <= int_Value(1);
	o_MemtoReg <= int_Value(0);

END rtl;
