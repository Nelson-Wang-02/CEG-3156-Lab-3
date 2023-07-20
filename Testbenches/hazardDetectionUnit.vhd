LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity hazardDetectionUnit is 

	port (
		IDEX_MemRead : IN STD_LOGIC;
		IDEX_Rt, IFID_Rs, IFID_Rt : IN STD_LOGIC_VECTOR(4 downto 0);
		
		o_PCWrite, o_IFIDWrite, o_stallMuxSel : OUT STD_LOGIC);

end hazardDetectionUnit; 

architecture rtl of hazardDetectionUnit is 

	component fiveBitComparator IS
		PORT(
			i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(4 downto 0);
			o_GT, o_LT, o_EQ		: OUT	STD_LOGIC_VECTOR(4 downto 0));
	END component;
	
	signal sig_FA1, sig_FA0, sig_FB1, sig_FB0 : STD_LOGIC;
	
	signal sig_ExMem_Zero : STD_LOGIC;
	signal sig_MemWb_Zero : STD_LOGIC;
	
	signal sig_GT1, sig_LT1, sig_EQRtRs : std_logic_vector(4 downto 0);
	signal sig_GT0, sig_LT0, sig_EQRt : std_logic_vector(4 downto 0);
	
	signal sig_stallMuxSel: std_logic;
	
	begin 
	
	--concurrent signal assignment
	sig_stallMuxSel <= not(IDEX_MemRead and (sig_EQRtRs(0) or sig_EQRt(0))); 

	
	comp1: fiveBitComparator
		port map(
			i_Ai => IDEX_Rt,
			i_Bi => IFID_Rs,
			o_GT => sig_GT1, 
			o_LT => sig_LT1, 
			o_EQ => sig_EQRtRs);
		
	comp2: fiveBitComparator
		port map(
			i_Ai => IDEX_Rt,
			i_Bi => IFID_Rt,
			o_GT => sig_GT0, 
			o_LT => sig_LT0, 
			o_EQ => sig_EQRt);
		
		
	--output driver
	o_stallMuxSel <= sig_stallMuxSel;
	o_PCWrite <= sig_stallMuxSel;
	o_IFIDWrite <= sig_stallMuxSel;	

end rtl;