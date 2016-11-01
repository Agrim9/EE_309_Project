library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;

entity Pilot is
port 
(
reset: in std_logic;
clk: in std_logic;
clk_50: in std_logic

);
end entity;
architecture Behave of Pilot is

component IITB_RISC is port(
	rst: in std_logic;
	load_mem: in std_logic;
	clk: in std_logic;
	clk_50: in std_logic;
	instr_data_in: in std_logic_vector(15 downto 0);
	addr_wr: in std_logic_vector(15 downto 0);
	mem_bit: in std_logic
);
end component;

signal load_mem: std_logic;
signal mem_bit:std_logic:='1';
signal instr_data_in, addr_wr: std_logic_vector(15 downto 0);

begin
 instr_data_in <= "0000000000000000";
     mem_bit <= '0';    
     addr_wr <= "0000000000000000";
     load_mem <= '1';
dut:
	IITB_RISC port map (rst=>reset,load_mem=>load_mem, clk => clk,clk_50 => clk_50, instr_data_in => instr_data_in, addr_wr => addr_wr, mem_bit => mem_bit);
end Behave;
