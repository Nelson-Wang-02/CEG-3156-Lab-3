LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY regIFID IS
	PORT(
		i_resetBar, i_IFIDWrite, i_IFFlush	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(39 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(39 downto 0));
END regIFID;

ARCHITECTURE rtl OF regIFID IS
	SIGNAL int_Value, int_notValue : STD_LOGIC_VECTOR(39 downto 0);
	SIGNAL sig_ResetBar : STD_LOGIC;

	COMPONENT eightBitRegister
		PORT(
			i_resetBar, i_load	: IN	STD_LOGIC;
			i_clock			: IN	STD_LOGIC;
			i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0));
	END COMPONENT;

BEGIN

--concurrent signal assignment
sig_ResetBar <= i_resetBar or i_IFFlush;

b4: eightBitRegister
	PORT MAP (i_resetBar => sig_ResetBar,
			  i_Value => i_Value(39 downto 32), 
			  i_load => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(39 downto 32));
			  
b3: eightBitRegister
	PORT MAP (i_resetBar => sig_ResetBar,
			  i_Value => i_Value(31 downto 24), 
			  i_load => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(31 downto 24));
				 
b2: eightBitRegister
	PORT MAP (i_resetBar => sig_ResetBar,
			  i_Value => i_Value(23 downto 16), 
			  i_load => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(23 downto 16));				 	 
				 
b1: eightBitRegister
	PORT MAP (i_resetBar => sig_ResetBar,
			  i_Value => i_Value(15 downto 8), 
			  i_load => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(15 downto 8));	

b0: eightBitRegister
	PORT MAP (i_resetBar => sig_ResetBar,
			  i_Value => i_Value(7 downto 0), 
			  i_load => i_IFIDWrite,
			  i_clock => i_clock,
			  o_Value => int_Value(7 downto 0));				  
				 
	-- Output Driver
	o_Value		<= int_Value;

END rtl;
