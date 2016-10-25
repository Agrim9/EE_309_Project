library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity RAM is
  port (
    clock   : in  std_logic;
    writeEN : in  std_logic;
    address : in  std_logic_vector;
    datain  : in  std_logic_vector;
    dataout : out std_logic_vector
  );
end entity RAM;

architecture RTL of RAM is

   type ram_type is array (0 to (2**address'length)-1) of std_logic_vector(datain'range);
   signal ram : ram_type;
   signal read_address : std_logic_vector(address'range);
function CONV_INTEGER(x: std_logic_vector) return integer is
      variable ret_val: integer:=0;
      alias lx : std_logic_vector (x'length-1 downto 0) is x;
	variable pow: integer:=1;
  begin 
	for I in 0 to x'length-1 loop 	
		if (lx(I) = '1') then
      			ret_val := ret_val + pow;
		end if;
		pow:=pow*2;
	end loop;
      return(ret_val);
  end CONV_INTEGER;
begin
	dataout <= ram(CONV_INTEGER(address)); 
  RamProc: process(clock) is
  begin
    if rising_edge(clock) then
      if writeEN = '1' then
        ram(CONV_INTEGER(address)) <= datain;
	--dataout <= "0000000000000000"; 
	--else 
	--dataout <= ram(CONV_INTEGER(address));  
	    
	end if;
      
	
    end if;
  
  end process RamProc;

  

end architecture RTL;
