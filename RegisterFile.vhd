library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
  port(
    regASel     : in  std_logic_vector(2 downto 0);  --- A1
    regBSel     : in  std_logic_vector(2 downto 0);  ----A2
    writeRegSel : in  std_logic_vector(2 downto 0);  ----A3
    data_input  : in  std_logic_vector(15 downto 0); ----D3    
    D1          : out std_logic_vector(15 downto 0);
    D2          : out std_logic_vector(15 downto 0);
    PC          : out std_logic_vector(15 downto 0);  --D4 (PC)
    readAEnable : in std_logic;
    readBEnable : in std_logic;
    writeEnable : in  std_logic;
    clk         : in  std_logic
    );
end RegisterFile;


architecture behavioral of RegisterFile is
  type registerFile is array(0 to 7) of std_logic_vector(15 downto 0);
  signal registers : registerFile;
begin
  regFile : process (clk) is
  begin
    if rising_edge(clk) then
	-- Read A and B 
	if (readAEnable = '1') then
	outA <= registers(to_integer(unsigned(regASel)));
	end if;
	if (readBEnable='1') then	      
	outB <= registers(to_integer(unsigned(regBSel)));
	end if;	
	
	PC<=registers(7);      
	-- Write
  	if writeEnable = '1' then
		registers(to_integer(unsigned(writeRegSel))) <= data_input;
	end if;
	
    end if;
  end process;
end behavioral;
