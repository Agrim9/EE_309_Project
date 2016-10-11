LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY regfile is port(
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
	SUBTYPE reg IS std_logic_vector(15 DOWNTO 0);
	TYPE	regArray IS array(0 to 7) OF reg;
	SIGNAL RF:regArray;
function CONV_INTEGER(x: std_logic_vector(2 downto 0)) return integer is
      variable ret_val: integer;
  begin  
      	if (x = "000") then
        ret_val := 0;
      	elsif (x="001") then 
        ret_val := 1;
	elsif (x="010") then 
        ret_val := 2;
	elsif (x="011") then 
        ret_val := 3;
	elsif (x="100") then 
        ret_val := 4;
	elsif (x="101") then 
        ret_val := 5;
	elsif (x="110") then 
        ret_val := 6;
	elsif (x="111") then 
        ret_val := 7;
	else ret_val := -1;
      end if;
      return(ret_val);
  end CONV_INTEGER;
BEGIN
	RF_Write:Process(clk)
	BEGIN
	if(clk'EVENT and clk = '0') THEN
		if(rf_wr='1') THEN 
			RF(CONV_INTEGER(a3rf)) <= d3rf;
		end if; 
	end if;
	end process;

	PC_write:Process(clk)
	BEGIN
	if(clk'EVENT and clk = '0') THEN
		if(pc_wr='1') THEN 
			RF(7) <= d4rf;
		end if; 
	end if;
	end process;

	Read:Process(a1rf,a2rf)
	BEGIN
	if(rf_wr='0') then
		d1rf <= RF(CONV_INTEGER(a1rf));
		d2rf <= RF(CONV_INTEGER(a2rf));
	else 
		d1rf <= (others => '0');
		d2rf <= (others => '0');

	end if;
	end process;	

	PC_read:Process
	begin
	if(pc_wr = '0') then
		d5rf <= RF(7);
	else 
		d5rf <= (others => '0');
	
	end if;
	end process;
	

end Behavorial;
