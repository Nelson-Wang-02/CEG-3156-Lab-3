LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regM IS
	PORT(
		i_resetBar		: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Branch, i_MemRead, i_MemWrite : IN STD_LOGIC; 
		o_Branch, o_MemRead, o_MemWrite : OUT STD_LOGIC);
END regM;

ARCHITECTURE rtl OF regM IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(2 downto 0);

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
			  i_d => i_Branch,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_Value(2),
	        o_qBar => int_notValue(2));

mid: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_MemRead,
			  i_enable => '1', 
			  i_clock => i_clock,
			  o_q => int_Value(1),
	        o_qBar => int_notValue(1));

bot: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => i_MemWrite, 
			  i_enable => '1',
			  i_clock => i_clock,
			  o_q => int_Value(0),
	        o_qBar => int_notValue(0));		  
				 
	-- Output Driver
	o_Branch <= int_Value(2);
	o_MemRead <= int_Value(1);
	o_MemWrite <= int_Value(0);

END rtl;
