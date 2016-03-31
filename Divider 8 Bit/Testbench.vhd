library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;


entity Testbench is
end entity;
architecture Behave of Testbench is
component Divider is
    port(dividend,divisor: in std_logic_vector(7 downto 0);
         quotient,remainder: out std_logic_vector(7 downto 0);
       inputs_ready: in std_logic;
       divider_ready : out std_logic;
       output_accept : in std_logic;
       output_ready: out std_logic;
       clk, reset: in std_logic);
  end component  Divider;
  signal dividend,divisor,quotient,remainder: std_logic_vector(7 downto 0);
  signal inputs_ready, divider_ready,output_accept,output_ready : std_logic;
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_std_logic_vector(x: bit_vector) return std_logic_vector is
    alias lx: bit_vector(1 to x'length) is x;
    variable ret_var : std_logic_vector(1 to x'length);
  begin
     for I in 1 to x'length loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else
           ret_var(I) :=  '0';
	end if;
     end loop;
     return(ret_var);
  end to_std_logic_vector;

begin
  clk <= not clk after 50 ns; -- assume 10ns clock.

  -- reset process
  process
  begin
     wait until clk = '1';
     reset <= '0';
     wait;
  end process;

  process
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable dividend_var: bit_vector ( 7 downto 0);
    variable divisor_var: bit_vector ( 7 downto 0);
    variable quotient_var: bit_vector (7 downto 0);
    variable remainder_var: bit_vector (7 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable OUTPUT_LINE2: Line;
    variable LINE_COUNT: integer := 0;

  begin

    wait until clk = '1';

   
    while not endfile(INFILE) loop 
    	  wait until clk = '0';

          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, dividend_var);
	        read (INPUT_LINE, divisor_var);
          read (INPUT_LINE, quotient_var);
          read (INPUT_LINE, remainder_var);

          --------------------------------------
          -- from input-vector to DUT inputs
	  dividend <= to_std_logic_vector(dividend_var);
	  divisor <= to_std_logic_vector(divisor_var);
          --------------------------------------

          -- set start
          inputs_ready <= '1';

          -- spin waiting for done
          while (true) loop
             wait until clk = '1';
             inputs_ready <= '0';
             if(output_ready = '1') then
                exit;
             end if;
          end loop;

          --------------------------------------
	  -- check outputs.
    if (divisor /= "00000000") then
	  if (quotient /= to_std_logic_vector(quotient_var) or remainder /= to_std_logic_vector(remainder_var)) then
             write(OUTPUT_LINE,to_string("ERROR: in quotient or remainder, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
    end if;
    --if (remainder /= to_std_logic_vector(remainder_var)) then
    --         write(OUTPUT_LINE,to_string("ERROR: in remainder, line "));
    --         write(OUTPUT_LINE, LINE_COUNT);
    --         writeline(OUTFILE, OUTPUT_LINE);
    --         err_flag := true;
    --      end if;
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut: Divider
     port map(quotient => quotient,
              dividend => dividend,
              divisor => divisor,
              clk => clk,
              reset => reset,
              remainder => remainder,
              divider_ready => divider_ready,
              output_accept => output_accept,
              inputs_ready => inputs_ready,
               output_ready => output_ready);

end Behave;

