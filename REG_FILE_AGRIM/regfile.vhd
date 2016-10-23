LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY regfile is port(
	done : out std_logic;
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
end regfile;

ARCHITECTURE Behavorial of regfile IS
	type registerFile is array(0 to 7) of std_logic_vector(15 downto 0);
	SIGNAL RF:registerFile;
	SIGNAL done_1,done_3,done_4: std_logic := '0';

function CONV_INTEGER(x: std_logic_vector) return integer is
      variable ret_val: integer:=0;
      alias lx : std_logic_vector (x'length-1 downto 0) is x;
	variable pow: integer:=1;
  begin 
	for I in 0 to x'length-1 loop 	
		if (lx(I) = '1') then
      			ret_val := ret_val + pow;
		end if;
		pow:=pow*2;
	end loop;
      return(ret_val);
  end CONV_INTEGER;
BEGIN
	RF_PC_Write:Process(clk)
	BEGIN
	done_1 <= '0';
	if(clk'EVENT and clk = '1') THEN
		if(rf_wr='1') THEN 
			RF(CONV_INTEGER(a3rf)) <= d3rf;
		--report "yo1";		
		end if; 
		if(pc_wr='1') THEN 
			RF(7) <= d4rf;
		--report "yo2";	
		end if; 
		
	end if;
		
	done_1<='1';
	end process;

	Read:Process(clk)
	BEGIN
	done_3 <= '0';
	
	if(clk'EVENT and clk = '0') THEN	
	--report "yo3";	
	if(rf_wr='0') then
		d1rf <= RF(CONV_INTEGER(a1rf));
		d2rf <= RF(CONV_INTEGER(a2rf));
	else 
		d1rf <= (others => '0');
		d2rf <= (others => '0');

	end if;
	end if;
	
	done_3<='1';
	end process;	

	PC_read:Process(clk)
	begin
	done_4 <= '0';	
	if(clk'EVENT and clk = '0') THEN	
		
	if(pc_wr = '0') then
		d5rf <= RF(7);
		--report "yo4";
	else 
		d5rf <= (others => '0');
	
	end if;
	end if;
	done_4<='1';
	end process;
	
	done <= done_1 and done_3 and done_4;
end Behavorial;