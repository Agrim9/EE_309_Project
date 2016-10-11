library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
library work;
use work.RISC_proj.all;

entity Testbench is
end entity;
architecture Behave of Testbench is

 	signal clk :  std_logic := '0';
	signal write_ctr: std_logic_vector(1 downto 0);
	signal a1rf  :  std_logic_vector(2 downto 0);
	signal a2rf  :  std_logic_vector(2 downto 0);
	signal a3rf  :  std_logic_vector(2 downto 0);
	signal d1rf  :  std_logic_vector(15 downto 0);
	signal d2rf  :  std_logic_vector(15 downto 0);
	signal d3rf  :  std_logic_vector(15 downto 0);
	signal d4rf  :  std_logic_vector(15 downto 0);
	signal d5rf  :  std_logic_vector(15 downto 0);

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_std_logic_vector(x: bit_vector) return std_logic_vector is
    alias lx: bit_vector(1 to x'length) is x;
    variable ret_var : std_logic_vector(1 to x'length);
  begin
     for I in 1 to x'length loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
	end if;
     end loop;
     return(ret_var);
  end to_std_logic_vector;

begin
  clk <= not clk after 5 ns; -- assume 10ns clock.

  -- reset process
  process
  begin
     wait until clk = '1';
  end process;

  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
  	variable write_ctr_var : bit_vector(1 downto 0);
	variable a1rf_var  : bit_vector(2 downto 0);
	variable a2rf_var  : bit_vector(2 downto 0);
	variable a3rf_var  : bit_vector(2 downto 0);
	variable d1rf_var  : bit_vector(15 downto 0);
	variable d2rf_var  : bit_vector(15 downto 0);
	variable d3rf_var  : bit_vector(15 downto 0);
	variable d4rf_var  : bit_vector(15 downto 0);
	variable d5rf_var  : bit_vector(15 downto 0);

    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin

    wait until clk = '1';

   
    while not endfile(INFILE) loop 
    	  wait until clk = '0';

          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, write_ctr_var);
          read (INPUT_LINE, a1rf_var);
	  read (INPUT_LINE, a2rf_var);
	  read (INPUT_LINE, a3rf_var);
	  read (INPUT_LINE, d1rf_var);
	  read (INPUT_LINE, d2rf_var);
	  read (INPUT_LINE, d3rf_var);
	  read (INPUT_LINE, d4rf_var);
	  read (INPUT_LINE, d5rf_var);

          --------------------------------------
          -- from input-vector to DUT inputs
	  write_ctr <= to_std_logic_vector(write_ctr_var);
	  a1rf <= to_std_logic_vector(a1rf_var);
       	  a2rf <= to_std_logic_vector(a2rf_var);
	  a3rf <= to_std_logic_vector(a3rf_var);
	  d3rf <= to_std_logic_vector(d3rf_var);
	  d4rf <= to_std_logic_vector(d4rf_var);

          --------------------------------------


        wait until clk = '0';
	wait until clk = '1';
          --------------------------------------
	  -- check outputs
	
	  if (d1rf /= to_std_logic_vector(d1rf_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in d1rf, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
	if (d2rf /= to_std_logic_vector(d2rf_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in d2rf, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
	if (d5rf /= to_std_logic_vector(d5rf_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in d5rf, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut: regfile
     port map(
	clk  => clk,
	pc_wr => write_ctr(1),
	rf_wr => write_ctr(0),
	a1rf=>a1rf,
	a2rf=>a2rf,
	a3rf=>a3rf,
	d1rf=>d1rf,
	d2rf=>d2rf,
	d3rf=>d3rf,
	d4rf=>d4rf,
	d5rf=>d5rf
);

end Behave;

