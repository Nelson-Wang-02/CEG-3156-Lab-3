--------------------------------------------------------------------------------
-- Title         : 8-bit Adder
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : eightBitAdder.vhd
-- Author        : Nelson Wang  <nwang027@uottawa.ca>
-- Created       : 2023/05/18
-- Last modified : 2023/05/21
-------------------------------------------------------------------------------
-- Description : This file creates a 8-bit binary full adder as defined in the VHDL
--		 Synthesis lecture.  The architecture is done at the RTL
--		 abstraction level and the implementation is done in structural
--		 VHDL.
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitAdder IS
	PORT(
		i_Cin : 	IN STD_LOGIC; -- signal from control path. 
		i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
		
		o_CarryOut		: OUT	STD_LOGIC;
		o_Sum			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitAdder;

ARCHITECTURE rtl OF eightBitAdder IS
	SIGNAL int_Sum, int_CarryOut : STD_LOGIC_VECTOR(7 downto 0);

	COMPONENT oneBitAdder
	PORT(
		i_CarryIn		: IN	STD_LOGIC;
		i_Ai, i_Bi		: IN	STD_LOGIC;
		o_Sum, o_CarryOut	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	-- Concurrent Signal Assignment

add7: oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(6), 
			  i_Ai => i_Ai(7),
			  i_Bi => i_Bi(7),
			  o_Sum => int_Sum(7),
			  o_CarryOut => int_CarryOut(7));
			  
add6: oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(5), 
			  i_Ai => i_Ai(6),
			  i_Bi => i_Bi(6),
			  o_Sum => int_Sum(6),
			  o_CarryOut => int_CarryOut(6));
			  
add5: oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(4), 
			  i_Ai => i_Ai(5),
			  i_Bi => i_Bi(5),
			  o_Sum => int_Sum(5),
			  o_CarryOut => int_CarryOut(5));

add4: oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(3), 
			  i_Ai => i_Ai(4),
			  i_Bi => i_Bi(4),
			  o_Sum => int_Sum(4),
			  o_CarryOut => int_CarryOut(4));

add3:	oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(2), 
			  i_Ai => i_Ai(3),
			  i_Bi => i_Bi(3),
			  o_Sum => int_Sum(3),
			  o_CarryOut => int_CarryOut(3));
	
add2: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(1), 
			  i_Ai => i_Ai(2),
			  i_Bi => i_Bi(2),
			  o_Sum => int_Sum(2),
			  o_CarryOut => int_CarryOut(2));

add1: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(0), 
			  i_Ai => i_Ai(1),
			  i_Bi => i_Bi(1),
			  o_Sum => int_Sum(1),
			  o_CarryOut => int_CarryOut(1));

add0: oneBitAdder
	PORT MAP (i_CarryIn => i_Cin, 
			  i_Ai => i_Ai(0),
			  i_Bi => i_Bi(0),
			  o_Sum => int_Sum(0),
			  o_CarryOut => int_CarryOut(0));

	-- Output Driver
	o_Sum <= int_Sum;
	o_CarryOut <= int_CarryOut(7);

END rtl;