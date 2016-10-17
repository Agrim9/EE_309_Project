library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ALU_Components.all;

entity ALU is
	port (  -- operands and result
			alu_a: in std_logic_vector(15 downto 0);            -- operand 1
			alu_b: in std_logic_vector(15 downto 0);			-- operand 2
			alu_out: out std_logic_vector(15 downto 0);			-- output
			-- to and fro communication with Condition code registers
			alu_c_out: out std_logic;							-- input to carry register
			alu_z_out: out std_logic;							-- input to zero register
			-- opcode
			op_code: in std_logic_vector(1 downto 0)					-- (00)add, (01)nand, (1x) xor
	
			);
end entity ALU;

architecture behave of ALU  is
	signal ga, gn, gx, fa, fn, fx: std_logic_vector(15 downto 0); 
	signal gca, gcn, gcx, gza, gzn, gzx, fca, fcn, fcx, fza, fzn, fzx: std_logic; 
	signal t1, t2: std_logic;
	
begin
	Adder: b16_adder port map (x => alu_a, y => alu_b, s => ga, carry_out => gca, zero_out => gza );
	Nander: b16_nander port map (x=> alu_a, y => alu_b, s => gn, carry_out => gcn, zero_out => gzn );
	Xorer: b16_xorer port map (x => alu_a, y => alu_b, s => gx, carry_out => gcx, zero_out => gzx );
	
	t1 <= (not op_code(1)) and (not op_code(0));
	t2 <= (not op_code(1)) and (    op_code(0));
	
	Add_out: b16_conditional_repeater port map (op => t1,         input => ga, output => fa, carry_in => gca, zero_in => gza, carry_out => fca, zero_out => fza);
	Nand_out: b16_conditional_repeater port map (op => t2,        input => gn, output => fn, carry_in => gcn, zero_in => gzn, carry_out => fcn, zero_out => fzn);
	XOr_out: b16_conditional_repeater port map (op => op_code(1), input => gx, output => fx, carry_in => gcx, zero_in => gzx, carry_out => fcx, zero_out => fzx);
	
	alu_out <= fa or fn or fx;
	alu_c_out <= fca or fcn or fcx;
	alu_z_out <= fza or fzn or fzx;

end behave;

------------------------------------------------------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
entity b16_conditional_repeater is
	port (  
			input: in std_logic_vector(15 downto 0);            -- operand 1
			output: out std_logic_vector(15 downto 0);			-- operand 2
			
			carry_in: in std_logic;							
			zero_in: in std_logic;							
			carry_out: out std_logic;							
			zero_out: out std_logic;							
			-- opcode
			op: std_logic						-- (00)add, (01)nand, (1x) xor
	
			);
end entity;

architecture behave of b16_conditional_repeater is
begin
	
	carry_out <= carry_in and op;
	zero_out <= zero_in and op;
	output(15) <= input(15) and op;
	output(14) <= input(14) and op;
	output(13) <= input(13) and op;
	output(12) <= input(12) and op;
	output(11) <= input(11) and op;
	output(10) <= input(10) and op;
	output(9) <= input(9) and op;
	output(8) <= input(8) and op;
	output(7) <= input(7) and op;
	output(6) <= input(6) and op;
	output(5) <= input(5) and op;
	output(4) <= input(4) and op;
	output(3) <= input(3) and op;
	output(2) <= input(2) and op;
	output(1) <= input(1) and op;
	output(0) <= input(0) and op;

end behave;

--------------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity b16_adder is
	port (  
			x: in std_logic_vector(15 downto 0);            -- operand 1
			y: in std_logic_vector(15 downto 0);			-- operand 2
			s: out std_logic_vector(15 downto 0);
		
			carry_out: out std_logic;							
			zero_out: out std_logic							
			
			);
end entity;

architecture behave of b16_adder is
		signal g, z: std_logic_vector(15 downto 0);
		
		component OneBitAdder is
		port (a, b, cin: in std_logic; s,cout : out std_logic);
		end component;
	
begin
	
	
   zero_out <= z(0) and z(1) and z(2) and z(3) and z(4) and z(5) and z(6) and z(7) and z(8) and z(9) and z(10) and z(11) and z(12) and z(13) and z(14) and z(15);
   
   o1:  OneBitAdder port map(a=>x(0)  ,b=>y(0)  ,cin=>'0'   ,s=>z(0)  ,cout=>g(1));
   o2:  OneBitAdder port map(a=>x(1)  ,b=>y(1)  ,cin=>g(1)  ,s=>z(1)  ,cout=>g(2));
   o3:  OneBitAdder port map(a=>x(2)  ,b=>y(2)  ,cin=>g(2)  ,s=>z(2)  ,cout=>g(3));
   o4:  OneBitAdder port map(a=>x(3)  ,b=>y(3)  ,cin=>g(3)  ,s=>z(3)  ,cout=>g(4));
   o5:  OneBitAdder port map(a=>x(4)  ,b=>y(4)  ,cin=>g(4)  ,s=>z(4)  ,cout=>g(5));
   o6:  OneBitAdder port map(a=>x(5)  ,b=>y(5)  ,cin=>g(5)  ,s=>z(5)  ,cout=>g(6));
   o7:  OneBitAdder port map(a=>x(6)  ,b=>y(6)  ,cin=>g(6)  ,s=>z(6)  ,cout=>g(7));
   o8:  OneBitAdder port map(a=>x(7)  ,b=>y(7)  ,cin=>g(7)  ,s=>z(7)  ,cout=>g(8));
   o9:  OneBitAdder port map(a=>x(8)  ,b=>y(8)  ,cin=>g(8)  ,s=>z(8)  ,cout=>g(9));
   o10: OneBitAdder port map(a=>x(9)  ,b=>y(9)  ,cin=>g(9)  ,s=>z(9)  ,cout=>g(10));
   o11: OneBitAdder port map(a=>x(10) ,b=>y(10) ,cin=>g(10) ,s=>z(10) ,cout=>g(11));
   o12: OneBitAdder port map(a=>x(11) ,b=>y(11) ,cin=>g(11) ,s=>z(11) ,cout=>g(12));
   o13: OneBitAdder port map(a=>x(12) ,b=>y(12) ,cin=>g(12) ,s=>z(12) ,cout=>g(13));
   o14: OneBitAdder port map(a=>x(13) ,b=>y(13) ,cin=>g(13) ,s=>z(13) ,cout=>g(14));
   o15: OneBitAdder port map(a=>x(14) ,b=>y(14) ,cin=>g(14) ,s=>z(14) ,cout=>g(15));
   o16: OneBitAdder port map(a=>x(15) ,b=>y(15) ,cin=>g(15) ,s=>z(15) ,cout=> carry_out );

   s <= z;
   
end behave;

--------------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity b16_nander is
	port (  
			x: in std_logic_vector(15 downto 0);            -- operand 1
			y: in std_logic_vector(15 downto 0);			-- operand 2
			s: out std_logic_vector(15 downto 0);
			
			carry_out: out std_logic;							
			zero_out: out std_logic							
			
			);
end entity;

architecture behave of b16_nander is
		signal g, z: std_logic_vector(15 downto 0);
begin
	
	
   zero_out <= z(0) and z(1) and z(2) and z(3) and z(4) and z(5) and z(6) and z(7) and z(8) and z(9) and z(10) and z(11) and z(12) and z(13) and z(14) and z(15);
   z <=  x nand y;
   s <= z;
   carry_out <= '0';
   
end behave;
-----------------------------------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity b16_xorer is
	port (  
			x: in std_logic_vector(15 downto 0);            -- operand 1
			y: in std_logic_vector(15 downto 0);			-- operand 2
			s: out std_logic_vector(15 downto 0);
			
			carry_out: out std_logic;							
			zero_out: out std_logic							
			
			);
end entity;

architecture behave of b16_xorer is
		signal g, z: std_logic_vector(15 downto 0);
begin
	
	
   zero_out <= z(0) and z(1) and z(2) and z(3) and z(4) and z(5) and z(6) and z(7) and z(8) and z(9) and z(10) and z(11) and z(12) and z(13) and z(14) and z(15);
   z <=  x xor y;
   s <= z;
   carry_out <= '0';
   
end behave;


-------------------------------------------------supporting components-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity OneBitAdder is
  port (a,b,cin: in std_logic; s,cout: out std_logic);
end entity OneBitAdder;

architecture Behave of OneBitAdder is
begin
	-- s = (a xor b) xor cin
	s <= (a xor b) xor cin ;
	-- cout
	cout <= ( cin and (a xor b) ) or (a and b);
end Behave;
-----------------------------------------------------------------------------------------------------------------------
