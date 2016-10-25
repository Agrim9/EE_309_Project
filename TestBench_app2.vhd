library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.IITB_RISC_Components.all;

entity Grand_Test is
end entity;
architecture Behave of Grand_Test is

    signal start_mc, reset: std_logic;
signal mem_bit:std_logic:='1';
signal clk: std_logic:='0';
signal instr_data_in, addr_wr: std_logic_vector(15 downto 0);

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_std_logic_vector(x: bit_vector) return std_logic_vector is
    alias lx: bit_vector(x'length-1 downto 0) is x;
    variable ret_var : std_logic_vector(x'length-1 downto 0);
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

  function bit_to_string(x: bit_vector) return string is
    alias lx: bit_vector(1 to x'length) is x;
    variable ret_var : string(1 to x'length);
  begin
     for I in 1 to x'length loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
	end if;
     end loop;
     return(ret_var);
  end bit_to_String;

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
    while not endfile(INFILE) loop 
    	  wait until clk = '0';
          LINE_COUNT := LINE_COUNT + 1;
			
			report "NEW INNPUT READ";
	  	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, mem_bit_var);
	      read (INPUT_LINE, instr_var);
	      read (INPUT_LINE, addr_var);

          --------------------------------------
          -- from input-vector to DUT inputs
 	
	  instr_data_in <= to_std_logic_vector(instr_var);
      mem_bit <= to_std_logic(mem_bit_var);    
      addr_wr <= to_std_logic_vector(addr_var);
      start_mc<= not to_std_logic(mem_bit_var);
      reset <= to_std_logic(mem_bit_var);
	 
          --------------------------------------
	     while (true) loop
             wait until clk='1';
	     
		--report "NOT HERE";
		--if(done='1') then		
			exit;
		--end if;
         end loop;
        
        --write(OUTPUT_LINE,to_string("Data Output: "));
		--write(OUTPUT_LINE,to_string_vec(dataout));

          --   writeline(OUTFILE, OUTPUT_LINE);
            -- err_flag := true;
		
          --------------------------------------
    end loop;

    

    wait;
  end process;

dut:
	IITB_RISC port map (start_mc => start_mc, reset => reset, clk => clk, instr_data_in => instr_data_in, addr_wr => addr_wr, mem_bit => mem_bit);

end Behave;
