--Sign Extender 
-- 9 bits
-- 6 bits

library ieee;
use ieee.std_logic_1164.all;

entity SignExtend_9 is
port( 	--- Input
		IN_9:in std_logic_vector(9 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end entity SignExtend_9;

architecture dataflow of SignExtend_9 is
begin
	process(IN_9)
	begin
		OUT_16(16) <= IN_9(9);		-- add the sign bit
		OUT_16(8 downto 1)<=IN_9(8 downto 1); -- add the data 
		
		if(IN_9(9)='1') then		-- number is -ve
			OUT_16(15 downto 9)<="1111111";		-- add one to all places for twos complement representation
		else
			OUT_16(15 downto 9)<="0000000";
		end if;
		end process;
end dataflow;

library ieee;
use ieee.std_logic_1164.all;


entity SignExtend_6 is
port( 	--- Input
		IN_6:in std_logic_vector(6 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end entity SignExtend_6;

architecture dataflow of SignExtend_6 is
	begin
	process(IN_6)
	begin
		OUT_16(16) <= IN_6(6);		-- add the sign bit
		OUT_16(5 downto 1)<=IN_6(5 downto 1); -- add the data 
		
		if(IN_6(6)='1') then		-- number is -ve
			OUT_16(15 downto 6)<="1111111111";		-- add one to all places for twos complement representation
		else
			OUT_16(15 downto 6)<="0000000000";
		end if;
		end process;
end dataflow;
--16 bit nand

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity nand16 is 
port(A,B: in std_logic_vector(16 downto 1);
		C: out std_logic_vector(16 downto 1)
		);
end entity nand16;

architecture arch of nand16 is
begin
C<=A nand B;
end arch;
		

library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
entity SignExtend is
port( IN_6: in std_logic_vector(6 downto 1);
		IN_9: in Std_logic_vector(9 downto 1);
		C,E: in std_logic_vector(16 downto 1);
		A,B,D,F : out std_logic_vector(16 downto 1)
		);
end entity SignExtend;

architecture arch of SignExtend is
component SignExtend_6 is
port( 	--- Input
		IN_6:in std_logic_vector(6 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end component SignExtend_6;

component SignExtend_9 is
port( 	--- Input
		IN_9:in std_logic_vector(9 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end component SignExtend_9;


component nand16 is 
port(A,B: in std_logic_vector(16 downto 1);
		C: out std_logic_vector(16 downto 1)
		);
end component nand16;


component Add_1 is 
port(
	I: in std_logic_vector(16 downto 1);
	O: out std_logic_vector(16 downto 1)
	);
end component Add_1;
begin
	S9: SignExtend_9 port map(IN_9=>IN_9,OUT_16=>A);
	S6: SignExtend_6 port map(IN_6=>IN_6,OUT_16=>B) ;
	Add1: Add_1 port map(I=>C,O=>D);
	N: Nand16 port map(A=>C,B=>E,C=>F);
end arch;
