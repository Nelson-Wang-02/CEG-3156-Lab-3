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

ENTITY eightBitAddSub IS
	PORT(
		i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(7 downto 0);
		i_Op				: IN STD_LOGIC;
		o_Zero         : OUT STD_LOGIC;
		o_CarryOut		: OUT	STD_LOGIC;
		o_Diff			: OUT	STD_LOGIC_VECTOR(7 downto 0));
END eightBitAddSub;

ARCHITECTURE rtl OF eightBitAddSub IS
	SIGNAL int_Sum, int_CarryOut : STD_LOGIC_VECTOR(7 downto 0);
	
	signal b_Comp : STD_LOGIC_VECTOR(7 downto 0);
	
	COMPONENT oneBitAdder
	PORT(
		i_CarryIn		: IN	STD_LOGIC;
		i_Ai, i_Bi		: IN	STD_LOGIC;
		o_Sum, o_CarryOut	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

	-- Concurrent Signal Assignment	
	b_Comp(7) <= i_Op xor i_Bi(7);
	b_Comp(6) <= i_Op xor i_Bi(6);	
	b_Comp(5) <= i_Op xor i_Bi(5);
	b_Comp(4) <= i_Op xor i_Bi(4);
	b_Comp(3) <= i_Op xor i_Bi(3);
	b_Comp(2) <= i_Op xor i_Bi(2); 
	b_Comp(1) <= i_Op xor i_Bi(1);
	b_Comp(0) <= i_Op xor i_Bi(0);
	
add7: oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(6), 
			  i_Ai => i_Ai(7),
			  i_Bi => b_Comp(7),
			  o_Sum => int_Sum(7),
			  o_CarryOut => int_CarryOut(7));
			  
add6: oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(5), 
			  i_Ai => i_Ai(6),
			  i_Bi => b_Comp(6),
			  o_Sum => int_Sum(6),
			  o_CarryOut => int_CarryOut(6));
			  
add5: oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(4), 
			  i_Ai => i_Ai(5),
			  i_Bi => b_Comp(5),
			  o_Sum => int_Sum(5),
			  o_CarryOut => int_CarryOut(5));

add4: oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(3), 
			  i_Ai => i_Ai(4),
			  i_Bi => b_Comp(4),
			  o_Sum => int_Sum(4),
			  o_CarryOut => int_CarryOut(4));

add3:	oneBitAdder 
	PORT MAP (i_CarryIn => int_CarryOut(2), 
			  i_Ai => i_Ai(3),
			  i_Bi => b_Comp(3),
			  o_Sum => int_Sum(3),
			  o_CarryOut => int_CarryOut(3));
	
add2: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(1), 
			  i_Ai => i_Ai(2),
			  i_Bi => b_Comp(2),
			  o_Sum => int_Sum(2),
			  o_CarryOut => int_CarryOut(2));

add1: oneBitAdder
	PORT MAP (i_CarryIn => int_CarryOut(0), 
			  i_Ai => i_Ai(1),
			  i_Bi => b_Comp(1),
			  o_Sum => int_Sum(1),
			  o_CarryOut => int_CarryOut(1));

add0: oneBitAdder
	PORT MAP (i_CarryIn => i_Op, 
			  i_Ai => i_Ai(0),
			  i_Bi => b_Comp(0),
			  o_Sum => int_Sum(0),
			  o_CarryOut => int_CarryOut(0));

	-- Output Driver
	o_Zero <= not(int_Sum(7) or int_Sum(6) or int_Sum(5) or int_Sum(4) or int_Sum(3) or int_Sum(2) or int_Sum(1) or int_Sum(0));
	o_Diff <= int_Sum;
	o_CarryOut <= int_CarryOut(7);

END rtl;