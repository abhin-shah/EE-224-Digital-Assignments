library std;
library ieee;
use ieee.std_logic_1164.all;

package DividerPackage is
  component Divider is
    port(dividend,divisor: in std_logic_vector(7 downto 0);
         quotient,remainder: out std_logic_vector(7 downto 0);
       inputs_ready: in std_logic;
       divider_ready : out std_logic;
       output_accept : in std_logic;
       output_ready: out std_logic;
       clk, reset: in std_logic);
  end component  Divider;

  component ControlPath is
	port (
    T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: out std_logic;
    S: in std_logic;
    inputs_ready: in std_logic;
       divider_ready : out std_logic;
       output_accept : in std_logic;
       output_ready: out std_logic;
    clk, reset: in std_logic
       );
  end component;

  component DataPath is
	port (
    T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: in std_logic;
    S: out std_logic;
    dividend,divisor: in std_logic_vector(7 downto 0);
    quotient,remainder: out std_logic_vector(7 downto 0);
    clk, reset: in std_logic
       );
  end component;

  component DataRegister is
	generic (data_width:integer);
	port (Din: in std_logic_vector(data_width-1 downto 0);
	      Dout: out std_logic_vector(data_width-1 downto 0);
	      clk, enable: in std_logic);
  end component DataRegister;

  -- produces sum with carry (included in result).
  component Comparator is
        port (A, B: in std_logic_vector(7 downto 0); RESULT: out std_logic);
  end component Comparator;


  -- 6-bit decrementer.
  component Decrement5 is
        port (A: in std_logic_vector(4 downto 0); B: out std_logic_vector(4 downto 0));
  end component Decrement5;

  component Subtractor is
        port (A,B: in std_logic_vector(7 downto 0); Result: out std_logic_vector(7 downto 0));
  end component Subtractor;

end package;