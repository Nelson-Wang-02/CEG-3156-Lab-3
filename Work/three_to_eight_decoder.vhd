library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity three_to_eight_decoder is
    port(
        A : in STD_LOGIC_VECTOR(2 downto 0);
        Y : out STD_LOGIC_VECTOR(7 downto 0)
    );
end three_to_eight_decoder;

architecture rtl of three_to_eight_decoder is

	signal sel : STD_LOGIC_VECTOR(7 downto 0);

begin
    sel(0) <= (not A(2)) and (not A(1)) and (not A(0));
    sel(1) <= (not A(2)) and (not A(1)) and A(0);
    sel(2) <= (not A(2)) and A(1) and (not A(0));
    sel(3) <= (not A(2)) and A(1) and A(0);
    sel(4) <= A(2) and (not A(1)) and (not A(0));
    sel(5) <= A(2) and (not A(1)) and A(0);
    sel(6) <= A(2) and A(1) and (not A(0));
    sel(7) <= A(2) and A(1) and A(0);
	 
	 Y <= sel;
	 
end rtl;
