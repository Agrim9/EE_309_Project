-- 16 bit +1 Adder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Add_1 is 
port(
	I: in std_logic_vector(16 downto 1);
	O: out std_logic_vector(16 downto 1)
	);
end entity Add_1;

architecture Dataflow of Add_1 is
begin
	O<= std_logic_vector(signed(I)+1);
end dataflow;