LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity oneBit6to1Mux is 
	port (
		i_0, i_1, i_2, i_3, i_4, i_5 : IN STD_LOGIC;
		i_sel : IN STD_LOGIC_VECTOR(2 downto 0);
		i_out : OUT STD_LOGIC);
		
end oneBit6to1Mux;

architecture rtl of oneBit6to1Mux is 

	signal choice : STD_LOGIC;
	
	begin 
	
	choice <= (not(i_sel(2)) and not(i_sel(1)) and not(i_sel(0)) and i_0) or --000
				 (not(i_sel(2)) and not(i_sel(1)) and i_sel(0) and i_1) or --001
				 (not(i_sel(2)) and i_sel(1) and not(i_sel(0)) and i_2) or --010
				 (not(i_sel(2)) and i_sel(1) and i_sel(0) and i_3) or --011
				 (i_sel(2) and not(i_sel(1)) and not(i_sel(0)) and i_4) or --100
				 (i_sel(2) and not(i_sel(1)) and i_sel(0) and i_5) or --101
				 (i_sel(2) and i_sel(1) and not(i_sel(0)) and i_5) or --110
				 (i_sel(2) and i_sel(1) and i_sel(0) and i_5); --111
	i_out <= choice; 
	
end rtl;