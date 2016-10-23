library std;
use std.textio.all;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------- HARSHVARDHAN ---------------------------------
-----** --------------------PRIORITY ENCODER----------------
----- input DATA and outputs 3 bit location of first appearance of '1', an err signal for all 0s case and data with bit cleared at location
-----------------------------------------------------------------------------
entity PriorityEncoder is
port ( x : in std_logic_vector(15 downto 0);
	s : out std_logic_vector(2 downto 0);	
	d: out std_logic_vector(15 downto 0);
	err_flag: out std_logic	 ) ;
end PriorityEncoder ;
architecture comb of PriorityEncoder is
signal location : integer range 0 to 7;
signal s1: std_logic_vector(2 downto 0);


function to_int(x: std_logic_vector) return integer is
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
  end to_int;

begin
--err_flag <= not ( x(7) or x(6) or x(5) or x(4) or x(3) or x(2) or x(1) or x(0) ) ;
s1(0) <= ( x(1) and not x(0) ) or
	( x(3) and not x(2) and not x(1) and not x(0) ) or
	( x(5) and not x(4) and not x(3) and not x(2) and
	not x(1) and not x(0) ) or
	( x(7) and not x(6) and not x(5) and not x(4)
	and not x(3) and not x(2) and not x(1)
	and not x(0) ) ;
s1(1) <= ( x(2) and not x(1) and not x(0) ) or
	( x(3) and not x(2) and not x(1) and not x(0) ) or
	( x(6) and not x(5) and not x(4) and not x(3) and
	not x(2) and not x(1) and not x(0) ) or
	( x(7) and not x(6) and not x(5) and not x(4) and
	not x(3) and not x(2) and not x(1) and not x(0) ) ;
s1(2) <= ( x(4) and not x(3) and not x(2) and
	not x(1) and not x(0) ) or
	( x(5) and not x(4) and not x(3) and not x(2) and
	not x(1) and not x(0) ) or
	( x(6) and not x(5) and not x(4) and not x(3)
	and not x(2) and not x(1) and not x(0) ) or
	( x(7) and not x(6) and not x(5) and not x(4) and not x(3)
	and not x(2) and not x(1) and not x(0) ) ;
s<=s1;
location <= to_int(s1);


process(location,x)
variable dat: std_logic_vector (15 downto 0);
variable gengar: std_logic:='0';
variable count: integer:=0;
begin
dat:=x;
---
for I in 0 to 7 loop
	if(dat(i)='1') then
		count:=count+1;
	end if;
end loop;
---
if (count=1 or count =0) then
	gengar:='1';
else 
	gengar:='0';
end if;
count:=0;
dat(location):='0';
d<=dat;
err_flag<=gengar;
end process;

end comb ;
