library ieee;
use ieee.std_logic_1164.all;
library work;
use work.DividerPackage.all;
entity ControlPath is
	port (
		T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: out std_logic;
		S: in std_logic;
    inputs_ready: in std_logic;
       divider_ready : out std_logic;
       output_accept : in std_logic;
       output_ready: out std_logic;
		clk, reset: in std_logic
	     );
end entity;

architecture Behave of ControlPath is
   type FsmState is (rst, compare ,quotient, update, donestate);
   signal fsm_state : FsmState;
begin

   process(fsm_state, inputs_ready, S, clk, reset)
      variable next_state: FsmState;
      variable Tvar: std_logic_vector(0 to 11);
      variable divider_ready_var,output_ready_var: std_logic;
   begin
       -- defaults
       Tvar := (others => '0');
       output_ready_var := '0';
       next_state := fsm_state;

       case fsm_state is
          when rst =>
               if(inputs_ready = '1') then
                  next_state := compare;
                  Tvar(0) := '1'; Tvar(2) := '1'; Tvar(3) := '1'; Tvar(4) := '1';
                  divider_ready_var := '0';
               end if;
          when compare =>
                divider_ready_var := '1';
               next_state := quotient;
               Tvar(1) := '1'; Tvar(6) := '1';Tvar(11) := '1';
          when quotient =>
               Tvar(7) := '1'; Tvar(8) := '1';
               next_state := update;
          when update =>
               Tvar(5) := '1';
               if(S = '1') then
                  Tvar(9) := '1';
                  Tvar(10) := '1';
                  next_state := donestate;
               else
                  next_state := compare;
               end if;
          when donestate =>
               output_ready_var := '1';
               next_state := rst;
     end case;

     T0 <= Tvar(0); T1 <= Tvar(1); T2 <= Tvar(2); T3 <= Tvar(3); T4 <= Tvar(4);
     T5 <= Tvar(5); T6 <= Tvar(6); T7 <= Tvar(7); T8 <= Tvar(8);
     T9 <= Tvar(9); T10 <= Tvar(10); T11 <= Tvar(11);
     output_ready <= output_ready_var;
     divider_ready <= divider_ready_var;

     if(clk'event and (clk = '1')) then
	if(reset = '1') then
             fsm_state <= rst;
        else
             fsm_state <= next_state;
        end if;
     end if;
   end process;
end Behave;