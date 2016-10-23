library std;
library ieee;
use ieee.std_logic_1164.all;

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


library ieee;
use ieee.std_logic_1164.all;

library work;
use work.IITB_RISC_Components.all;
entity IITB_RISC is
end entity IITB_RISC;


architecture Struct of IITB_RISC is
   signal T_arr: std_logic_vector(25 downto 0);
   signal IR_val: std_logic_vector(15 downto 0);
   signal Carry,Zero: std_logic;
begin

    CP: ControlPath 
	     port map(	T_arr => T_arr,
			IR_val => IR_val,
			LM_last => LM_last,
			Carry => Carry,
			Zero => Zero,
			start => start,
			done => done,
			reset => reset,
			clk => clk);

    DP: DataPath
	     port map (A => A, B => B,
			RESULT => RESULT,
	     		T0 => T0,
			T1 => T1, 
			T2 => T2,
			T3 => T3,
			T4 => T4,
 			T5 => T5,
			T6 => T6,
			T7 => T7,
			T8 => T8,
			S => S,
			reset => reset,
			clk => clk);
end Struct;

library ieee;
use ieee.std_logic_1164.all;
entity ControlPath is
	port (
		T_arr: out std_logic_vector(25 downto 0);
		IR_val: in std_logic(15 downto 0);
		LM_last: in std_logic;
		carry: in std_logic;
		zero: in std_logic;
		start_state: in std_logic;
		done_state : out std_logic;
		clk, reset: in std_logic
	     );
end entity;

architecture Behave of ControlPath is
   type FsmState is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18);
   signal fsm_state : FsmState;
begin

   process(fsm_state, start, IR_val,carry,zero,LM_last, clk, reset)
      variable next_state: FsmState;
      variable Tvar: std_logic_vector(0 to 31);
      variable Instr_code : std_logic_vector(3 downto 0);
      variable logic1 : std_logic;
     -- variable done_var: std_logic;
   begin
       -- defaults
       Tvar := (others => '0');
       done_var := '0';
       next_state := fsm_state;
	Instr_code := IR_val ( 15 downto 12);
       case fsm_state is 
          when S0 =>
               if ((Instr_code = "0000") or (Instr_code = "0010")) then
                  next_state := S1;
		elsif (Instr_code = "0001") then
                  next_state := S4;
		elsif (Instr_code = "1100") then
		  next_state := S18;		
		elsif (Instr_code = "1000") then
		  next_state := S15;		
		elsif (Instr_code = "1001") then
		  next_state := S17;		
		elsif (Instr_code = "0011") then
		  next_state := S9;	
		elsif ((Instr_code = "0101") or (Instr_code = "0100")) then
		  next_state := S10;	
		elsif ((Instr_code = "0110") or (Instr_code = "0111")) then
		  next_state := S5;
		end if;
		Tvar := "10000001000000000010001001000000";
          when S1 =>
		logic1 := (zero and (not IR_val(1))) or ((not IR_val(1))and(not IR_val(0))) or (carry and (not IR_val(0)));
		if(logic1 = '1') then
               next_state := S2;
		else 
		next_state := S0;
		end if;
		Tvar := "00000010000100110001100000000000";
		if(logic1 = '1') then
		Tvar(27)='0';
		else TVar(27) ='1';
		end if;
	  when S2 =>
               next_state := S3;
               	Tvar := "01101100000000000000010000000000";
		Tvar(27) :=Instr_code(3);		
		if(Instr_code="1100") then	
		Tvar(29) :='1';
		Tvar(30) := '0';
		elsif(Instr_code="0010")then
		Tvar(29) :='0';
		Tvar(30) := '1';
		elsif((Instr_code = "0000") or (Instr_code="0001")) then 
		Tvar(29) :='0';
		Tvar(30) := '0';
		else 
		Tvar(29) :='1';
		Tvar(30) := '1';
		end if; 
	  when S3 =>
               next_state := S0;
		Tvar := "00000000000100000100000000000000"; 
		Tvar(27) :=((not (IR_val(9) and IR_val(10) and IR_val(11))) and (not Instr_code(3))) or ((not Zero) and (Instr_code(3)));
		Tvar(28) := not Instr_code(3);             
	  when S4 =>
               next_state := S2;
               Tvar := "00000010100000100001100000000000";
	  when S5 =>
		 if (Instr_code = "0110")  then
                  next_state := S6;
		else 
		  next_state :=S8;
		end if;
               Tvar := "01000001000000000001010000000000";

	  when S6 =>
               next_state := S7;
               Tvar := "00000000010000000000100001000000";

          when S7 =>
               if ((Instr_code = "0110") and (LM_last='0'))  then
                  next_state := S6;
		elsif ((Instr_code = "0111") and (LM_last='0')) then
		  next_state :=S8;
		elsif (last='1') then 
		  next_state :=S0;
		end if;
               Tvar := "00100011000110000001010000000000";	   
		Tvar(26) := Instr_code(0);
		Tvar(27) := LM_last and (not IR_val(6));
   	  when S8 =>
               next_state := S7;
               Tvar := "00000000000000001000100000000000";

	  when S9 =>
               next_state := S0;
               Tvar := "00000000000101000100000000001000";
	       Tvar(27) :=not (IR_val(9) and IR_val(10) and IR_val(11));
		
	  when S10 =>
               next_state := S11;
                Tvar := "00000010000000111001100000000000";		

	  when S11 =>
               if (Instr_code = "0100")  then
                  next_state := S12;
		else 
		  next_state :=S14;
		end if;
               Tvar :="01100100000000000000010000000000"; --Check
		
	  when S12 =>
               next_state := S13;
                Tvar := "00000000010000000000100001000000";
	  
       	  when S13 =>
               next_state := S0;
		Tvar := "00000000000110000100000000001000";
		Tvar(27) :=not (IR_val(9) and IR_val(10) and IR_val(11));
	 
	  when S14 =>
               next_state := S0;
		Tvar := "00000000000100000000000000110000";

	  when S15 =>
               next_state := S16;
		Tvar := "01111000000000000000010000000000";

	  when S16 =>
               next_state := S0;
                Tvar := "00000000000011000100000000011000";
		
	  when S17 =>
               next_state := S16;
		Tvar := "01000000000000100000000000000000";
               	
	  when S18 =>
               next_state := S2;
		Tvar := "01111010000000111001110000000000";
            
     end case;

     T_arr=Tvar;
  
     if(clk'event and (clk = '1')) then
	if(reset = '1') then
             fsm_state <= rst;
        else
             fsm_state <= next_state;
        end if;
     end if;
   end process;
end Behave;


library ieee;
use ieee.std_logic_1164.all;
library work;
use work.ShiftAddMulComponents.all;

entity DataPath is
	port (
		T0,T1,T2,T3,T4,T5,T6,T7,T8: in std_logic;
		S: out std_logic;
		A,B: in std_logic_vector(31 downto 0);
		RESULT: out std_logic_vector(31 downto 0);
		clk, reset: in std_logic
	     );
end entity;

architecture Mixed of DataPath is
    signal AREG, BREG: std_logic_vector(31 downto 0);
    signal COUNT: std_logic_vector(5 downto 0);
    signal TSUM: std_logic_vector(32 downto 0);
    signal PROD: std_logic_vector(63 downto 0);

    signal AREG_in, BREG_in, RESULT_in: std_logic_vector(31 downto 0);
    signal COUNT_in: std_logic_vector(5 downto 0);
    signal TSUM_in: std_logic_vector(32 downto 0);
    signal PROD_in: std_logic_vector(63 downto 0);
   
    signal addA,addB: std_logic_vector(31 downto 0);
    signal addRESULT: std_logic_vector(32 downto 0);

    signal decrIn, decrOut, count_reg_in: std_logic_vector(5 downto 0);
    constant C33 : std_logic_vector(5 downto 0) := "100001";
    constant C0 : std_logic_vector(0 downto 0) := "0";
    constant C6 : std_logic_vector(5 downto 0) := "000000";
    constant C32 : std_logic_vector(31 downto 0) := (others => '0');
    constant C64 : std_logic_vector(63 downto 0) := (others => '0');

    signal count_enable, 
             areg_enable, breg_enable, tsum_enable, prod_enable, result_enable: std_logic;

begin
    -- predicate
    S <= '1' when (COUNT = C6) else '0';

    --------------------------------------------------------
    --  count-related logic
    --------------------------------------------------------
    -- decrementer
    decr: Decrement6  port map (A => COUNT, B => decrOut);

    -- count register.
    count_enable <=  (T0 or T1);
    COUNT_in <= decrOut when T1 = '1' else C33;
    count_reg: DataRegister 
                   generic map (data_width => 6)
                   port map (Din => COUNT_in,
                             Dout => COUNT,
                             Enable => count_enable,
                             clk => clk);

    -------------------------------------------------
    -- AREG related logic.
    -------------------------------------------------
    areg_enable <= (T2 or T3);
    AREG_in <= A when T2 = '1' else (C0 & AREG(31 downto 1));
    ar: DataRegister 
             generic map (data_width => 32)
             port map (
			 Din => AREG_in, Dout => AREG,
				Enable => areg_enable, clk => clk);
    

    
    -------------------------------------------------
    -- BREG related logic..
    -------------------------------------------------
    BREG_in <= B;  -- not really needed, just being consistent.
    breg_enable <= T4;
    br: DataRegister generic map(data_width => 32)
			port map (Din => BREG_in, Dout => BREG, Enable => breg_enable, clk => clk);
   
    -------------------------------------------------
    -- TSUM related logic
    -------------------------------------------------
    addA <= BREG when (AREG(0) = '1') else C32;
    addB <= PROD(63 downto 32);
    ainst: Adder32 port map (addA, addB, addRESULT);
 
    TSUM_in <= addRESULT;
    tsum_enable <= T7;
    tr: DataRegister generic map(data_width => 33)
			port map(Din => TSUM_in, Dout => TSUM, Enable => tsum_enable, clk => clk);

    -------------------------------------------------
    -- PROD related logic
    -------------------------------------------------
    PROD_in <= C64 when (T5 = '1') else (TSUM & PROD(31 downto 1));
    PROD_enable <= (T5 or T6);
    pr: DataRegister generic map(data_width => 64)
			port map(Din => PROD_in, Dout => PROD, Enable => prod_enable, clk => clk);

    -------------------------------------------------
    -- RESULT related logic
    -------------------------------------------------
    RESULT_in <= PROD(31 downto 0);
    RESULT_enable <= T8;
    rr: DataRegister generic map(data_width => 32)
			port map(Din => RESULT_in, Dout => RESULT, Enable => result_enable, clk => clk);


end Mixed;

