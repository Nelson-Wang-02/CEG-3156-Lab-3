LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity forwardingUnit is 

	port (
		ExMem_RegWrite : IN STD_LOGIC;
		ExMem_Rd, IdEx_Rs, IdEx_Rt : IN STD_LOGIC_VECTOR(7 downto 0);
		
		MemWb_RegWrite : IN STD_LOGIC;
		MemWb_Rd : IN STD_LOGIC_VECTOR(7 downto 0); 
		
		FA1, FA0, FB1, FB0 : OUT STD_LOGIC);

end forwardingUnit; 

architecture rtl of forwardingUnit is 

	component eightBitComparatorZero 
		PORT(
			i_Ai : IN STD_LOGIC_VECTOR(7 downto 0);
			o_Zero : OUT STD_LOGIC);
	END component;

	component eightBitComparator IS
		PORT(
			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 downto 0);
			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC_VECTOR(7 downto 0));
	END component;
	
	signal sig_FA1, sig_FA0, sig_FB1, sig_FB0 : STD_LOGIC;
	
	signal sig_ExMem_Zero : STD_LOGIC;
	signal sig_MemWb_Zero : STD_LOGIC;
	
	signal sig_GT1, sig_LT1, sig_EQRdRs1, sig_GT1_2, sig_LT1_2, sig_EQRdRt1 : std_logic_vector(7 downto 0);
	signal sig_GT0, sig_LT0, sig_EQRdRs0, sig_GT0_2, sig_LT0_2, sig_EQRdRt0 : std_logic_vector(7 downto 0);
	
	begin 
	
	--concurrent signal assignment
	sig_FA1 <= ExMem_RegWrite and sig_ExMem_Zero and sig_EQRdRs1(0);
	sig_FB1 <= ExMem_RegWrite and sig_ExMem_Zero and sig_EQRdRt1(0);
	sig_FA0 <= MemWb_RegWrite and sig_MemWb_Zero and sig_EQRdRs0(0);
	sig_FB0 <= MemWb_RegWrite and sig_MemWb_Zero and sig_EQRdRt0(0);
	
	comp1_0: eightBitComparatorZero
		port map (
			i_Ai => ExMem_Rd,
			o_Zero => sig_ExMem_Zero);
	
	comp1_RdRs: eightBitComparator
		port map(
			i_Ai => ExMem_Rd,
			i_Bi => IdEx_Rt,
			o_GT => sig_GT1, 
			o_LT => sig_LT1, 
			o_EQ => sig_EQRdRs1);
		
	comp1_RdRt: eightBitComparator
		port map(
			i_Ai => ExMem_Rd,
			i_Bi => IdEx_Rt,
			o_GT => sig_GT1_2, 
			o_LT => sig_LT1_2, 
			o_EQ => sig_EQRdRt1);
	
	comp0_0: eightBitComparatorZero
		port map (
			i_Ai => MemWb_Rd,
			o_Zero => sig_MemWb_Zero);
	
	comp0_RdRs: eightBitComparator
		port map(
			i_Ai => MemWb_Rd,
			i_Bi => IdEx_Rt,
			o_GT => sig_GT0, 
			o_LT => sig_LT0, 
			o_EQ => sig_EQRdRs0);
		
	comp0_RdRt: eightBitComparator
		port map(
			i_Ai => MemWb_Rd,
			i_Bi => IdEx_Rt,
			o_GT => sig_GT0_2, 
			o_LT => sig_LT0_2, 
			o_EQ => sig_EQRdRt0);	
	
	--output driver
	FA1 <= sig_FA1;
	FA0 <= sig_FA0;
	FB1 <= sig_FB1;
	FB0 <= sig_FB0;
	

end rtl;