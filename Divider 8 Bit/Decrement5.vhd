library ieee;
use ieee.std_logic_1164.all;
library work;
use work.DividerPackage.all;
entity Decrement5 is
   port (A: in std_logic_vector(4 downto 0); B: out std_logic_vector(4 downto 0));
end entity Decrement5;

architecture Serial of Decrement5 is
begin
  process(A)
    variable borrow: std_logic;
  begin
    borrow := '1';
    for I in 0 to 4 loop
       B(I) <= A(I) xor borrow;
       borrow := borrow and (not A(I));
    end loop;
  end process;
end Serial;