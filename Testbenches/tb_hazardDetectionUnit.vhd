LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_hazardDetectionUnit IS
END tb_hazardDetectionUnit;

ARCHITECTURE testbench OF tb_hazardDetectionUnit IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT hazardDetectionUnit
    	port (
			IDEX_MemRead : IN STD_LOGIC;
			IDEX_Rt, IFID_Rs, IFID_Rt : IN STD_LOGIC_VECTOR(4 downto 0);
			
			o_PCWrite, o_IFIDWrite, o_stallMuxSel : OUT STD_LOGIC);
    END COMPONENT;


   --Inputs
   signal tb_IDEX_MemRead : STD_LOGIC; 
	signal tb_IDEX_Rt, tb_IFID_Rs, tb_IFID_Rt : STD_LOGIC_VECTOR(4 downto 0);
	
    --Outputs
	 signal tb_o_PCWrite, tb_o_IFIDWrite, tb_o_stallMuxSel : STD_LOGIC;

BEGIN 

	-- Instantiate the Unit Under Test (UUT)
   uut: hazardDetectionUnit 
		PORT MAP (
         IDEX_MemRead => tb_IDEX_MemRead,
			IDEX_Rt => tb_IDEX_Rt,
			IFID_Rs => tb_IFID_Rs,
			IFID_Rt => tb_IFID_Rt,
			o_PCWrite => tb_o_PCWrite, 
			o_IFIDWrite => tb_o_IFIDWrite, 
			o_stallMuxSel => tb_o_stallMuxSel);

   -- Stimulus process
   stim_proc: process
   begin	
      -- hold reset state for 100 ns.
		tb_IDEX_MemRead <= '1';
		tb_IDEX_Rt <= "00001";
		tb_IFID_Rs <= "00001";
		tb_IFID_Rt <= "00000";
		
		wait for 50 ns;	

		assert tb_o_PCWrite = '0' and tb_o_IFIDWrite = '0' and tb_o_stallMuxSel = '0' report "Outputs should all be 0" severity ERROR; 
		
		tb_IDEX_MemRead <= '1';
		tb_IDEX_Rt <= "00001";
		tb_IFID_Rs <= "00000";
		tb_IFID_Rt <= "00001";
		
		
		wait for 50 ns;	
		
		assert tb_o_PCWrite = '0' and tb_o_IFIDWrite = '0' and tb_o_stallMuxSel = '0' report "Outputs should all be 0"  severity ERROR; 
		
		tb_IDEX_MemRead <= '1';
		tb_IDEX_Rt <= "00001";
		tb_IFID_Rs <= "00001";
		tb_IFID_Rt <= "00001";
		
		wait for 50 ns;	
		
		assert tb_o_PCWrite = '0' and tb_o_IFIDWrite = '0' and tb_o_stallMuxSel = '0' report "Outputs should all be 0"  severity ERROR; 		
      
      wait;
   end process;

END;
