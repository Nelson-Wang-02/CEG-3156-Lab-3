LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY eightBit6to1Mux IS
	port (
		data_in0   : in  std_logic_vector(7 downto 0);
		data_in1   : in  std_logic_vector(7 downto 0);
		data_in2   : in  std_logic_vector(7 downto 0);
		data_in3   : in  std_logic_vector(7 downto 0);
		data_in4   : in  std_logic_vector(7 downto 0);
		data_in5   : in  std_logic_vector(7 downto 0);
		
		select_in  : in  std_logic_vector(2 downto 0);
		
		mux_out    : out std_logic_vector(7 downto 0));
		
END eightBit6to1Mux;

ARCHITECTURE rtl OF eightBit6to1Mux IS

	component oneBit6to1Mux  
		port (
			i_0, i_1, i_2, i_3, i_4, i_5 : IN STD_LOGIC;
			i_sel : IN STD_LOGIC_VECTOR(2 downto 0);
			i_out : OUT STD_LOGIC);
			
	end component;

	signal sig_out : std_logic_vector(7 downto 0);

BEGIN

	-- Concurrent Signal Assignment
	
	mux7: oneBit6to1Mux  
		port map (
			i_0 => data_in0(7),
			i_1 => data_in1(7),
			i_2 => data_in2(7),
			i_3 => data_in3(7),
			i_4 => data_in4(7),
			i_5 => data_in5(7),
			i_sel => select_in,
			i_out => sig_out(7));
		
	mux6: oneBit6to1Mux  
		port map (
			i_0 => data_in0(6),
			i_1 => data_in1(6),
			i_2 => data_in2(6),
			i_3 => data_in3(6),
			i_4 => data_in4(6),
			i_5 => data_in5(6),
			i_sel => select_in,
			i_out => sig_out(6));
			
	mux5: oneBit6to1Mux  
		port map (
			i_0 => data_in0(5),
			i_1 => data_in1(5),
			i_2 => data_in2(5),
			i_3 => data_in3(5),
			i_4 => data_in4(5),
			i_5 => data_in5(5),
			i_sel => select_in,
			i_out => sig_out(5));
	
	mux4: oneBit6to1Mux  
		port map (
			i_0 => data_in0(4),
			i_1 => data_in1(4),
			i_2 => data_in2(4),
			i_3 => data_in3(4),
			i_4 => data_in4(4),
			i_5 => data_in5(4),
			i_sel => select_in,
			i_out => sig_out(4));

	mux3: oneBit6to1Mux  
		port map (
			i_0 => data_in0(3),
			i_1 => data_in1(3),
			i_2 => data_in2(3),
			i_3 => data_in3(3),
			i_4 => data_in4(3),
			i_5 => data_in5(3),
			i_sel => select_in,
			i_out => sig_out(3));	
 
	mux2: oneBit6to1Mux  
		port map (
			i_0 => data_in0(2),
			i_1 => data_in1(2),
			i_2 => data_in2(2),
			i_3 => data_in3(2),
			i_4 => data_in4(2),
			i_5 => data_in5(2),
			i_sel => select_in,
			i_out => sig_out(2));
	
	mux1: oneBit6to1Mux  
		port map (
			i_0 => data_in0(1),
			i_1 => data_in1(1),
			i_2 => data_in2(1),
			i_3 => data_in3(1),
			i_4 => data_in4(1),
			i_5 => data_in5(1),
			i_sel => select_in,
			i_out => sig_out(1));
	
	mux0: oneBit6to1Mux  
		port map (
			i_0 => data_in0(0),
			i_1 => data_in1(0),
			i_2 => data_in2(0),
			i_3 => data_in3(0),
			i_4 => data_in4(0),
			i_5 => data_in5(0),
			i_sel => select_in,
			i_out => sig_out(0));	
			
	--Output Driver
	mux_out <= sig_out;
	

	
END rtl;