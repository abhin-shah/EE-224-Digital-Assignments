library ieee;
use ieee.std_logic_1164.all;
library work;
use work.DividerPackage.all;
entity Subtractor is
   port (A,B: in std_logic_vector(7 downto 0); Result: out std_logic_vector(7 downto 0));
end entity Subtractor;

architecture Serial of Subtractor is
begin
  process(A,B)
    variable borrow: std_logic;
  begin
    borrow := '0';
    for I in 0 to 7 loop
       Result(I) <= A(I) xor B(I) xor borrow;
       borrow := (B(I) and (not A(I) or borrow)) or (borrow and (not A(I)));
    end loop;
  end process;
end Serial;