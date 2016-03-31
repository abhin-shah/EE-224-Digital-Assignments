library ieee;
use ieee.std_logic_1164.all;
library work;
use work.DividerPackage.all;
entity Comparator is
   port (A, B: in std_logic_vector(7 downto 0); RESULT: out std_logic);
end entity;
architecture Serial of Comparator is
begin
   process(A,B)
     variable less,great,equal: std_logic;
   begin
     less := '0';
     equal := '1';
     great := '0';
     for I in 0 to 7 loop
        great :=  great or (equal and A(7-I) and (not(B(7-I))));
        less :=  less or (equal and B(7-I) and (not(A(7-I))));
        equal :=  equal and (not(A(7-I) xor B(7-I)));
     end loop;
     RESULT <= equal or great;
   end process;
end Serial;