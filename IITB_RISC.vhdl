library ieee;
use ieee.std_logic_1164.all;
library work;
use work.IITB_RISC_Components.all;

--Grand Entity
entity IITB_RISC is port(
	start_mc: in std_logic;
	reset: in std_logic;
	clk: in std_logic
);
end entity IITB_RISC;


architecture Struct of IITB_RISC is
   signal T_arr: std_logic_vector(0 to 31);
   signal IR_val: std_logic_vector(15 downto 0);
   signal Carry,Zero,DoneCP: std_logic;
   signal P: std_logic_vector(4 downto 0);
   signal Mem_Dout,Mem_Din,Mem_Ain:std_logic_vector(15 downto 0);
begin

    CP: ControlPath 
	     port map(	T_arr => T_arr,   -- control 0 upto 31
		P=> P,
		IR_val=> IR_val,
		start_state=>start_mc,
		done_state =>DoneCP,
		clk=>clk,
		reset=>reset 
		);

    DP: DataPath
	     port map (
	  T=>T_arr,
	  P=>P,
	  Mem_Dout=>Mem_Dout,  -- data output from memory 
	  Mem_Din=>Mem_Din,
	  Mem_Ain=>Mem_Ain,     -- data and address input to memory
	  CLK=>clk);

    RAM_Port: RAM port map (
	clock  => clk,
    writeEN=>T_arr(26),
    address => Mem_Ain,
    datain  => Mem_Din,
    dataout =>Mem_Dout
	);

end Struct;


	 
