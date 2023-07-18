LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regWB IS
	PORT(
		i_resetBar, i_IFIDWrite	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(39 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(39 downto 0));
END regWB;

ARCHITECTURE rtl OF regIDEX IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(39 downto 0);

	COMPONENT eightBitRegister
		PORT(
			i_resetBar, i_enable	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;

BEGIN

--msb: b4
b4: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_Value(39 downto 32), 
			  i_enable => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(39 downto 32));
			  
b3: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_Value(31 downto 24), 
			  i_enable => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(31 downto 24));
				 
b2: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_Value(23 downto 16), 
			  i_enable => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(23 downto 16));				 	 
				 
b1: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_Value(15 downto 8), 
			  i_enable => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(15 downto 8));	

b0: eightBitRegister
	PORT MAP (i_resetBar => i_resetBar,
			  i_Value => i_Value(7 downto 0), 
			  i_enable => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(7 downto 0));				  
				 
	-- Output Driver
	o_Value		<= int_Value;

END rtl;
