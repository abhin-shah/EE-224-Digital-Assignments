library ieee;
use ieee.std_logic_1164.all;
library work;
use work.DividerPackage.all;

entity Divider is
  port(dividend,divisor: in std_logic_vector(7 downto 0);
         quotient,remainder: out std_logic_vector(7 downto 0);
       inputs_ready: in std_logic;
       divider_ready : out std_logic;
       output_accept : in std_logic;
       output_ready: out std_logic;
       clk, reset: in std_logic);
end entity Divider;


architecture Struct of Divider is
   signal T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11, S: std_logic;
begin

    CP: ControlPath
	     port map(T0 => T0, T1 => T1, T2 => T2, T3 => T3, T4 => T4, T5 => T5, T6 => T6,
			T7 => T7, T8 => T8, T9 => T9, T10 => T10, T11 => T11,
			S => S, inputs_ready => inputs_ready, output_ready => output_ready,
			divider_ready => divider_ready, output_accept => output_accept,
			reset => reset, clk => clk);

    DP: DataPath
	     port map (dividend => dividend, divisor => divisor,
			quotient => quotient, remainder => remainder,
	     		T0 => T0, T1 => T1, T2 => T2, T3 => T3, T4 => T4, T5 => T5, T6 => T6,
			T7 => T7, T8 => T8, T9 => T9, T10 => T10, T11 => T11, S => S,
			reset => reset, clk => clk);
end Struct;