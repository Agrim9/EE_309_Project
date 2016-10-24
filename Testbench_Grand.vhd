library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use ieee.numeric_std.all ;

library work;


entity Testbench_Grand is

end entity;

architecture Behave of Testbench_Grand is
component IITB_RISC is port(
	start_mc: in std_logic;
	reset: in std_logic;
	clk: in std_logic;
	instr_data_in: in std_logic_vector(15 downto 0);
	addr_wr: in std_logic_vector(15 downto 0);
	mem_bit: in std_logic
);
end component;

 function to_std_logic_vector(x: bit_vector) return std_logic_vector is
    alias lx: bit_vector(x'length-1 downto 0) is x;
    variable ret_var : std_logic_vector(x'length-1 downto 0);
    variable I:integer range 0 to 15;
  begin
     for I in 0 to x'length-1 loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
	end if;
     end loop;
     return(ret_var);
  end to_std_logic_vector;
  
function to_std_logic(x: bit) return std_logic is
    alias lx: bit is x;
    variable ret_var : std_logic;
  begin
     
        if(lx = '1') then
           ret_var :=  '1';
        else 
           ret_var :=  '0';
		end if;
    return(ret_var);
  end to_std_logic;

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


signal start_mc, reset, mem_bit, clk: std_logic;
signal instr_data_in, addr_wr: std_logic_vector(15 downto 0);


begin

  clk <= not clk after 50 ns; -- assume 10ns clock.

  

 process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable mem_bit_var: bit;
    variable instr_var, addr_var: bit_vector (15 downto 0);
    variable reset_var: std_logic := '1';
    variable start_mc_var: std_logic := '0';
    
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin


    wait until clk = '1';
   	    
	     start_mc <= start_mc_var;
	     reset <= reset_var;
	      
    while not endfile(INFILE) loop 
    	  wait until clk = '0';

          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, mem_bit_var);
	      read (INPUT_LINE, instr_var);
	      read (INPUT_LINE, addr_var);
	    
      instr_data_in <= to_std_logic_vector(instr_var);
      mem_bit <= to_std_logic(mem_bit_var);    
      addr_wr <= to_std_logic_vector(addr_var);
      
      wait until clk = '1';
 
    end loop;
    
    	start_mc_var := '1';
    	reset_var := '0';
      	
      	
	     start_mc <= start_mc_var;
	     reset <= reset_var;
	      
      	
    wait;
    
    
    
  end process;




dut:
	IITB_RISC port map (start_mc => start_mc, reset => reset, clk => clk, instr_data_in => instr_data_in, addr_wr => addr_wr, mem_bit => mem_bit);


end Behave;
