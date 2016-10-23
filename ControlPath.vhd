LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity ControlPath is
	port (
		T_arr: out std_logic_vector(0 to 31);
		P: in std_logic_vector(4 downto 0);
		IR_val: in std_logic_vector(15 downto 0);
		start_state: in std_logic;
		done_state : out std_logic;
		clk, reset: in std_logic
	     );
end entity;

architecture Behave of ControlPath is
   type FsmState is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14,S15,S16,S17,S18,rst);
   signal fsm_state : FsmState;
begin

   process(fsm_state,start_state, IR_val,P, clk, reset)
      variable next_state: FsmState;
      variable Tvar: std_logic_vector(0 to 31);
      variable Instr_code : std_logic_vector(3 downto 0);
      variable logic1 : std_logic;
      variable done_var : std_logic := '0';
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
		done_var := '0';
          when S1 =>
		logic1 := (P(0) and (not IR_val(1))) or ((not IR_val(1))and(not IR_val(0))) or (P(1) and (not IR_val(0)));
		if(logic1 = '1') then
               next_state := S2;
		else 
		done_var := '1';
		next_state := S0;
		end if;
		Tvar := "00000010000100110001100000000000";
		if(logic1 = '1') then
		Tvar(27):='0';
		else TVar(27) :='1';
		end if;
	  when S2 =>
               next_state := S3;
               	Tvar := "01101100000000000000010000000000";
		Tvar(27) :=Instr_code(3);		
		if(Instr_code="1100") then	
		Tvar(29) :='1';
		Tvar(30) :='0';
		
		elsif(Instr_code="0010")then
		Tvar(23) := '1';
		Tvar(24) := '0';
		Tvar(29) :='0';
		Tvar(30) := '1';
		elsif((Instr_code = "0000") or (Instr_code="0001")) then 
		Tvar(23) := '1';
		Tvar(24) := '1';
		Tvar(29) := '0';
		Tvar(30) := '0';
		else 
		Tvar(29) :='1';
		Tvar(30) := '1';
		end if; 
	  when S3 =>
		done_var := '1';
               next_state := S0;
		Tvar := "00000000000100000100000000000000"; 
		Tvar(27) :=((not (IR_val(9) and IR_val(10) and IR_val(11))) and (not Instr_code(3))) or ((not P(3)) and (Instr_code(3)));
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
               if ((Instr_code = "0110") and (P(2)='0'))  then
                  next_state := S6;
		elsif ((Instr_code = "0111") and (P(2)='0')) then
		  next_state :=S8;
		elsif (P(2)='1') then 
		done_var := '1';		
		  next_state :=S0;
		end if;
               Tvar := "00100011000110000001010000000000";	   
		Tvar(26) := Instr_code(0);
		Tvar(27) := P(2) and (not IR_val(6));
   	  when S8 =>
               next_state := S7;
               Tvar := "00000000000000001000100000000000";

	  when S9 =>
		done_var := '1';
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
		Tvar(24) := P(4);
	  
       	  when S13 =>
		done_var := '1';               
		next_state := S0;
		Tvar := "00000000000110000100000000001000";
		Tvar(27) :=not (IR_val(9) and IR_val(10) and IR_val(11));
	 
	  when S14 =>
		done_var := '1';
                next_state := S0;
		Tvar := "00000000000100000000000000110000";

	  when S15 =>
               next_state := S16;
		Tvar := "01111000000000000000010000000000";

	  when S16 =>
		done_var := '1';
               next_state := S0;
                Tvar := "00000000000011000100000000011000";
		
	  when S17 =>
               next_state := S16;
		Tvar := "01000000000000100000000000000000";
               	
	  when S18 =>
               next_state := S2;
		Tvar := "01111010000000111001110000000000";
	 when rst =>
		if(start_state ='1') then
		next_state := S0;
		else 
		next_state :=rst;
		end if;
		Tvar := "00000000000000000000000000010001";

            
     end case;

     T_arr<=Tvar;
     done_state <= done_var;
     if(clk'event and (clk = '1')) then
	if(reset = '1') then
             fsm_state <= rst;
        else
             fsm_state <= next_state;
        end if;
     end if;
   end process;
end Behave;
