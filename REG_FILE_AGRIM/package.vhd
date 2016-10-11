LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


package RISC_proj is 


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
end package;
