--------------------------------------------------------------------------------
-- Title         : 3-bit Comparator
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : threeBitComparator.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2003/05/17
-- Last modified : 2007/09/25
-------------------------------------------------------------------------------
-- Description : This file creates a 3-bit binary comparator as defined in the VHDL
--		 Synthesis lecture.  The architecture is done at the RTL
--		 abstraction level and the implementation is done in structural
--		 VHDL.
-------------------------------------------------------------------------------
-- Modification history :
-- 2003.05.17 	R. Abielmona		Creation
-- 2004.09.22 	R. Abielmona		Ported for CEG 3550
-- 2007.09.25 	R. Abielmona		Modified copyright notice
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBitComparatorZero IS
	PORT(
		i_Ai : IN STD_LOGIC_VECTOR(7 downto 0);
		o_Zero : OUT STD_LOGIC);
END eightBitComparatorZero;

ARCHITECTURE rtl OF eightBitComparatorZero IS
	SIGNAL sig_Zero : STD_LOGIC;


BEGIN

	-- Concurrent Signal Assignment
	sig_Zero <= not(i_Ai(7) or i_Ai(6) or i_Ai(5) or i_Ai(4) or i_Ai(3) or i_Ai(2) or i_Ai(1) or i_Ai(0));

	o_Zero <= sig_Zero;
	
END rtl;
