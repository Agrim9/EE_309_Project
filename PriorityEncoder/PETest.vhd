library std;
use std.textio.all;

library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity PETest is
end PETest ;
architecture test of PETest is
signal x: std_logic_vector(15 downto 0);
signal d: std_logic_vector(15 downto 0);
signal s: std_logic_vector(2 downto 0);
signal N : std_logic := '0';
signal loc: integer;
function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;


function to_string_vec(x: std_logic_vector) return string is
      variable ret_var: string(x'length-1 downto 0);
      alias lx : std_logic_vector(x'length-1 downto 0) is x;
  begin  
      for I in 0 to x'length-1 loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
	end if;
     end loop;
	return(ret_var);
  end to_string_vec;

function to_string_bit(x: std_logic) return character is
      variable ret_val: character;
      alias lx : std_logic is x;
  begin 
	if(lx ='1') then 
      		ret_val := '1';
	else
		ret_val := '0';
	end if;
      return(ret_val);
  end to_string_bit;

component PriorityEncoder
port ( x : in std_logic_vector(15 downto 0);
	s : out std_logic_vector(2 downto 0);
	loc: out integer;
	d: out std_logic_vector(15 downto 0);
	err_flag: out std_logic	 ) ;
end component ;
begin
process
variable xv : std_logic_vector(15 downto 0);
variable sv : std_logic_vector(2 downto 0);
variable fail: integer range 0 to 255;
variable success: integer range 0 to 256;
FILE OUTFILE: text  open write_mode is "out.txt";
 	variable INPUT_LINE1,INPUT_LINE2: Line;
    	variable OUTPUT_LINE: Line;
  	variable LINE_COUNT: integer := 0;
begin

for i in 0 to 255 loop
xv := std_logic_vector ( to_unsigned (i ,16) ) ;
wait for 0 ns ;
x<=xv;
wait for 30 ns;
 write(OUTPUT_LINE,to_string_vec(x));
 write(OUTPUT_LINE,to_string("   "));
 write(OUTPUT_LINE,to_string_vec(s));
 write(OUTPUT_LINE,to_string("   "));
 write(OUTPUT_LINE,to_string_bit(N));
 write(OUTPUT_LINE,to_string("   "));
 write(OUTPUT_LINE,to_string_vec(d));
 write(OUTPUT_LINE,to_string("   "));
 write(OUTPUT_LINE,integer'image(loc));
 writeline(OUTFILE, OUTPUT_LINE);
 wait for 5 ns;	
end loop ;
end process ;

dut : PriorityEncoder
port map ( x=>x ,
s=>s ,loc=>loc, d=>d, err_flag => N ) ;
end test ;
