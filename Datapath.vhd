
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- MUX1, MUX2, DataRegister, Regfile, ALU, PriorityEncoder, SignExtend_6, SignExtend_9, padder, ADD_1
entity datapath is
port(T: in std_logic_vector(0 to 31);
	  P: out std_logic_vector(4 downto 0);
	  Mem_Dout: in std_logic_vector(15 downto 0);  -- data output from memory 
	  Mem_Din,Mem_Ain: out std_logic_vector(15 downto 0);    -- data and address input to memory
	  CLK : in std_logic;
	  IR_val: out std_logic_vector (15 downto 0)
	  );
end entity datapath;


architecture arch of datapath is

component Mux1 is
generic (bits:integer);
port( I0,I1:in std_logic_vector(bits-1 downto 0);
		O : OUT STD_logic_vector(bits-1 DOWnto 0);
		Sel: in std_logic);
end component;
component Mux2 is
generic (bits:integer);
port( I0,I1,I2,I3:in std_logic_vector(bits-1 downto 0);
		O : OUT STD_logic_vector(bits-1 DOWnto 0);
		Sel: in std_logic_vector(1 downto 0));
end component;
component DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0);
	      clk, enable: in std_logic);
end component;
component regfile is port(
	clk : in std_logic;
	pc_wr : in std_logic;
	rf_wr : in std_logic;
	a1rf  : in std_logic_vector(2 downto 0);
	a2rf  : in std_logic_vector(2 downto 0);
	a3rf  : in std_logic_vector(2 downto 0);
	d1rf  : out std_logic_vector(15 downto 0);
	d2rf  : out std_logic_vector(15 downto 0);
	d3rf  : in std_logic_vector(15 downto 0);
	d4rf  : in std_logic_vector(15 downto 0);
	d5rf  : out std_logic_vector(15 downto 0));
end component;
component ALU is
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
end component;

component SignExtend_6 is
port( 	--- Input
		IN_6:in std_logic_vector(6 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end component ;

component SignExtend_9 is
port( 	--- Input
		IN_9:in std_logic_vector(9 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end component ;
component padder is 
port ( I : in std_logic_vector(8 downto 0);
		 O : out std_logic_vector(15 downto 0));
end component;

component Add_1 is 
port(
	I: in std_logic_vector(16 downto 1);
	O: out std_logic_vector(16 downto 1)
	);
end component Add_1;

component PriorityEncoder is
port ( x : in std_logic_vector(15 downto 0);	--T2_sig
	    s : out std_logic_vector(2 downto 0);	-- PE1
		 d: out std_logic_vector(15 downto 0); -- PE2
		 err_flag: out std_logic	) ;
end component ;
------------------------------------------------
signal d1_sig,d2_sig,d5_sig,IR_sig,T1_sig,T2_sig,T3_sig,T4_sig,T1_in:  std_logic_vector(15 downto 0);
signal M1_out,M2_out,M3_out,M4_out,M5_out,M6_out,M7_out,M8_out,M9_out: std_logic_vector(15 downto 0);
signal M10_out,M11_out,M12_out : std_logic_vector(2 downto 0);
signal PAD_sig,alu_a_sig,alu_b_sig,alu_out_sig,None_sig,SE6_out,SE9_out,PE2_sig: std_logic_vector(15 downto 0);
signal C_sig,Z_sig: std_logic_vector(0 downto 0);
signal PE1_sig: STD_logic_vector(2 downto 0);


begin

Mem_Ain<=M1_out;
Mem_Din<=T3_sig;

None_sig<="0000000000000000";

IR : DataRegister 	generic map(data_width => 16) port map(Din =>Mem_Dout , Dout =>IR_sig	, clk =>CLK , enable =>T(22));

IR_val<= IR_sig;



RF : regfile port map(
	clk =>CLK,
	pc_wr=>T(27),
	rf_wr =>T(28),
	a1rf  =>M10_out,
	a2rf  =>M11_out,
	a3rf  =>M12_out,
	d1rf  =>d1_sig,
	d2rf  =>d2_sig,
	d3rf  =>M9_out,
	d4rf  =>M8_out,
	d5rf  =>d5_sig
);

M1 : Mux1 generic map (bits=>16) port map(I0=>T4_sig,I1=>D5_sig,O=>M1_out,SEl=>T(0));
M2 : Mux2 generic map (bits=>16) port map(I0=>None_sig,I1=>T1_in,I2=>D1_sig,I3=>aLU_out_sig,O=>M2_out,SEl(1)=>T(1),sel(0)=>T(2));
M3 : Mux1 generic map (bits=>16) port map(I0=>T2_sig,I1=>D5_sig,O=>M3_out,SEl=>T(3));
M4 : Mux2 generic map (bits=>16) port map(I0=>None_sig,I1=>SE6_out,I2=>SE9_out,I3=>T3_sig,O=>M4_out,SEl(1)=>T(4),sel(0)=>T(5));
M5 : Mux2 generic map (bits=>16) port map(I0=>None_sig,I1=>SE9_out,I2=>D1_sig,I3=>PE2_sig,O=>M5_out,SEl(1)=>T(6),sel(0)=>T(7));
M6 : Mux2 generic map (bits=>16) port map(I0=>D2_sig,I1=>Mem_Dout,I2=>SE6_out,I3=>SE9_out,O=>M6_out,SEl(1)=>T(8),sel(0)=>T(9));
M7 : Mux1 generic map (bits=>16) port map(I0=>T4_sig,I1=>D5_sig,O=>M7_out,SEl=>T(10));
M8 : Mux2 generic map (bits=>16) port map(I0=>T4_sig,I1=>T1_sig,I2=>None_sig,I3=>None_sig,O=>M8_out,SEl(0)=>T(11),sel(1)=>T(31));
M9 : Mux2 generic map (bits=>16) port map(I0=>T4_sig,I1=>PAD_sig,I2=>T3_sig,I3=>T1_sig,O=>M9_out,SEl(1)=>T(12),sel(0)=>T(13));
M10 : Mux1 generic map (bits=>3) port map(I0=>IR_sig(11 downto 9),I1=>IR_sig(8 downto 6),O=>M10_out,SEl=>T(14));
M11 : Mux2 generic map (bits=>3) port map(I0=>"000",I1=>PE1_sig,I2=>IR_sig(5 downto 3),I3=>IR_sig(11 downto 9),O=>M11_out,SEl(1)=>T(15),sel(0)=>T(16));
M12 : Mux1 generic map (bits=>3) port map(I0=>PE1_sig,I1=>IR_sig(11 downto 9),O=>M12_out,SEl=>T(17));

PE : PriorityEncoder port map(
	x =>T2_sig,
	s => PE1_sig,
	d =>PE2_sig,
	err_flag=>P(2)
	);
ALU0 : ALU port map(
			alu_a=> M3_out,
			alu_b=> M4_out,
			alu_out=>alu_out_sig,
			alu_c_out=>C_sig(0),
			alu_z_out=>Z_sig(0),
			op_code(1)=>T(29),
			op_code(0)=>T(30)
			);
AddOne : Add_1 port map(I=>M7_out,O=>T1_in);
T1 : DataRegister 	generic map(data_width => 16) port map(Din =>T1_in , Dout => T1_sig, clk =>CLK , enable =>T(18));
T2 : DataRegister 	generic map(data_width => 16) port map(Din =>M5_out, Dout =>T2_sig 	, clk =>CLK , enable =>T(19));
T3 : DataRegister 	generic map(data_width => 16) port map(Din =>M6_out, Dout => T3_sig	, clk =>CLK , enable =>T(20));
T4 : DataRegister 	generic map(data_width => 16) port map(Din => M2_out, Dout =>T4_sig 	, clk =>CLK , enable =>T(21));
C : DataRegister 	generic map(data_width => 1) port map(Din =>C_sig, Dout(0) => P(1), clk =>CLK , enable =>T(23));
Z : DataRegister 	generic map(data_width => 1) port map(Din =>Z_sig, Dout(0) => P(0), clk =>CLK , enable =>T(24));
P(3)<=Z_sig(0);
P(4)<= '1' when T3_sig="0000000000000000" else '0';		--Gengar Wishes!*!
SE9 : SignExtend_9 port map(In_9=>IR_sig(8 downto 0),OUT_16=>SE9_out); 
SE6 : SignExtend_6 port map(In_6=>IR_sig(5 downto 0),OUT_16=>SE6_out);
PAD : padder port map(I=>IR_sig(8 downto 0),O=>Pad_sig);


end arch;

------------------------------COMPONENTS------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity Mux1 is
generic (bits:integer);
port( I0,I1:in std_logic_vector(bits-1 downto 0);
		O : OUT STD_logic_vector(bits-1 DOWnto 0);
		Sel: in std_logic);
end entity mux1;
architecture dataflow of mux1 is
begin
O<=I1 when sel ='1' else I0;
end dataflow;
---------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
entity Mux2 is
generic (bits:integer);
port( I0,I1,I2,I3:in std_logic_vector(bits-1 downto 0);
		O : OUT STD_logic_vector(bits-1 DOWnto 0);
		Sel: in std_logic_vector(1 downto 0));
end entity mux2;
architecture dataflow of mux2 is
begin
O<= I0 when Sel="00" else I1 when sel="01" else I2 when sel="10" else I3 when sel="11";
end dataflow;

-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0);
	      clk, enable: in std_logic);
end entity;
architecture Behave of DataRegister is
begin
    process(clk)
    begin
       if(clk'event and (clk  = '1')) then
           if(enable = '1') then
               Dout <= Din;
           end if;
       end if;
    end process;
end Behave;
-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity padder is 
port ( I : in std_logic_vector(8 downto 0);
		 O : out std_logic_vector(15 downto 0));
end padder;
architecture arch of padder is
begin
O(15 downto 7)<=I(8 downto 0);
O(6 downto 0)<="0000000";
end arch;

-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
entity SignExtend_9 is
port( 	--- Input
		IN_9:in std_logic_vector(9 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end entity SignExtend_9;

architecture dataflow of SignExtend_9 is
begin
		OUT_16(8 downto 1)<=IN_9(8 downto 1); -- add the data 
		OUT_16(16 downto 9)<="11111111" when IN_9(9)='1' else "00000000";		-- add one to all places for twos complement representation
end dataflow;

-------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity SignExtend_6 is
port( 	--- Input
		IN_6:in std_logic_vector(6 downto 1);
		OUT_16: out std_logic_vector(16 downto 1)
		);
end entity SignExtend_6;

architecture dataflow of SignExtend_6 is
	begin
	OUT_16(5 downto 1)<=IN_6(5 downto 1); -- add the data 
		OUT_16(16 downto 6)<="11111111111" when IN_6(6)='1' else "00000000000";		-- add one to all places for twos complement representation
end dataflow;
-------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Add_1 is 
port(
	I: in std_logic_vector(15 downto 0);
	O: out std_logic_vector(15 downto 0)
	);
end entity Add_1;

architecture Dataflow of Add_1 is
begin
	O<= std_logic_vector(unsigned(I)+1);
end dataflow;
---------------------------------------------------------------		 
