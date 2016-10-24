library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.IITB_RISC_Components.all;

entity RAM_Test is
end entity;
architecture Behave of RAM_Test is

    signal clk   : std_logic:='0';
    signal writeEN : std_logic_vector(0 downto 0);
    signal address : std_logic_vector(15 downto 0);
    signal datain  : std_logic_vector(15 downto 0);
    signal dataout : std_logic_vector(15 downto 0);

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

begin
 
 clk <= not clk after 50 ns; -- assume 10ns clock.
  process
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE_RAM.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS_RAM.txt";
	
    ---------------------------------------------------
    -- edit the next few lines to customize
  	variable wenable_var : bit_vector(0 downto 0);
	variable address_var  : bit_vector(15 downto 0);
	variable datain_var  : bit_vector(15 downto 0);
	variable dataout_var  : bit_vector(15 downto 0);
	

    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
	
	
  --wait until clk = '1';
    while not endfile(INFILE) loop 
    	  report "it starts";
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, wenable_var);
          read (INPUT_LINE, datain_var);
	  read (INPUT_LINE, address_var);

          --------------------------------------
          -- from input-vector to DUT inputs
 	
	  writeEN <= to_std_logic_vector(wenable_var);
	  address <= to_std_logic_vector(address_var);
	  datain <= to_std_logic_vector(datain_var);
	 wait until clk = '0';
          --------------------------------------
	     while (true) loop
             wait until clk='1';
	     
		report "NOT HERE";
		--if(done='1') then		
			exit;
		--end if;
             end loop;
             write(OUTPUT_LINE,to_string("Data Output: "));
		write(OUTPUT_LINE,to_string_vec(dataout));

             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;

          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut:RAM port map (
	clock  => clk,
    writeEN=>writeEN(0) ,
    address => address,
    datain  => datain,
    dataout => dataout
	);

end Behave;
