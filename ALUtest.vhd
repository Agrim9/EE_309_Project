library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;       
library work;
use work.ALU_Components.all;

entity ALUtest is
end entity;
architecture Behave of ALUtest is
  component ALU is
   port (
			alu_a: in std_logic_vector(15 downto 0);            -- operand 1
			alu_b: in std_logic_vector(15 downto 0);			-- operand 2
			alu_out: out std_logic_vector(15 downto 0);			-- output
			-- to and fro communication with Condition code registers
			alu_c_out: out std_logic;							-- input to carry register
			alu_z_out: out std_logic;							-- input to zero register
			-- opcode
			op_code: in std_logic_vector(1 downto 0)					-- (00)add, (01)nand, (1x) xor
	
			);
  end component;

  signal X,Y,Z: std_logic_vector(15 downto 0);
  signal op_code: std_logic_vector(1 downto 0);
  signal cs,zs:std_logic;

  function to_stdlogicvector(x: bit) return std_logic is
      variable ret_val: std_logic;
  begin  
      if (x = '1') then
        ret_val := '1';
      else 
        ret_val := '0';
      end if;
      return(ret_val);
  end to_stdlogicvector;

function to_std_logic(x: bit) return std_logic is
      variable ret_val: std_logic;
  begin  
      if (x = '1') then
        ret_val := '1';
      else 
        ret_val := '0';
      end if;
      return(ret_val);
  end to_std_logic;


  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;

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
  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "tracealu.txt";
    FILE OUTFILE: text  open write_mode is "outputs.txt";

    ---------------------------------------------------
    -- edit the next two lines to customize
    variable A: bit_vector ( 15 downto 0);
    variable B: bit_vector ( 15 downto 0);
    variable op: bit_vector (1 downto 0);
    variable cv,zv: bit;	
    variable Cx: bit_vector ( 15 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin
   
    while not endfile(INFILE) loop 
          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, A);
          read (INPUT_LINE, B);
          read (INPUT_LINE,op);
	  read (INPUT_LINE, Cx);
 	  read (INPUT_LINE, cv);
	  read (INPUT_LINE, zv);

          --------------------------------------
          -- from input-vector to DUT inputs
	  X <= to_stdlogicvector(A);
	  Y <= to_stdlogicvector(B);
    	  op_code <= to_stdlogicvector(op);	
          --------------------------------------


	  -- let circuit respond.
          wait for 10 ns;

          --------------------------------------
	  -- check outputs.
	 	
             write(OUTPUT_LINE,to_string("OUTPUT "));
		write(OUTPUT_LINE,to_string_vec(Z));
     
	 
             write(OUTPUT_LINE,to_string(" carry "));
		 write(OUTPUT_LINE,to_string_bit(cs));
		    
		     write(OUTPUT_LINE,to_string(" ZERO: "));	
		     write(OUTPUT_LINE,to_string_bit(zs));
		     writeline(OUTFILE, OUTPUT_LINE);
		     err_flag := true;

          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut: ALU
     port map(alu_a => X,alu_b => Y,alu_out => Z,op_code=>op_code,alu_c_out=>cs,alu_z_out=>zs
              );

end Behave;
