library ieee;
use ieee.std_logic_1164.all;
library work;
use work.IITB_RISC_Components.all;

--Grand Entity
entity IITB_RISC is port(
	clk: in std_logic;
	clk_50: in std_logic;
	instr_data_in: in std_logic_vector(15 downto 0);
	addr_wr: in std_logic_vector(15 downto 0);
	mem_bit: in std_logic;
	rst: in std_logic;
	load_mem: in std_logic
);
end entity IITB_RISC;


architecture Struct of IITB_RISC is
   signal T_arr: std_logic_vector(0 to 31);
   signal IR_val: std_logic_vector(15 downto 0);
   signal Carry,Zero,DoneCP: std_logic;
   signal P: std_logic_vector(4 downto 0);
   signal Mem_Dout,Mem_Din,Mem_Ain, bitwise_and_i,bitwise_and_d, RAM_d_in,RAM_a_in:std_logic_vector(15 downto 0);
   signal mem_write:std_logic:='0';
   signal mem_loaded:std_logic:='0';
   signal reset:std_logic;
   signal start_state:std_logic;
begin
	reset <= (mem_bit or (load_mem and (not mem_loaded))) or rst ;
	start_state <= (not mem_bit) and ((not load_mem) or (mem_loaded));
    CP: ControlPath 
	     port map(	T_arr => T_arr,   -- control 0 upto 31
		P=> P,
		IR_val=> IR_val,
		start_state=>start_state,
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
	  CLK=>clk,
	  IR_val => IR_val	
	);
	
	bitwise_and_i <= (others => mem_bit);
	bitwise_and_d <= (others => (not mem_bit));
	mem_write <= (T_arr(26) or mem_bit) ;
	RAM_d_in <= (instr_data_in and bitwise_and_i) or (Mem_Din and bitwise_and_d); 
	RAM_a_in <= (addr_wr and bitwise_and_i) or (Mem_Ain and bitwise_and_d);
    
    RAM_Port: hRAM port map (
	clock  => clk,
    	writeEN=>mem_write ,
	load_mem=>load_mem,
	mem_loaded=>mem_loaded,
    	address => RAM_a_in,
    	datain  => RAM_d_in,
    	dataout =>Mem_Dout
	);

end Struct;
