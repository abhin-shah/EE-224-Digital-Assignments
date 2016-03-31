library ieee;
use ieee.std_logic_1164.all;
library work;
use work.DividerPackage.all;


entity DataPath is
	port (
		T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: in std_logic;
		S: out std_logic;
		dividend,divisor: in std_logic_vector(7 downto 0);
		quotient,remainder: out std_logic_vector(7 downto 0);
		clk, reset: in std_logic
	     );
end entity;

architecture Mixed of DataPath is
    signal AREG: std_logic_vector(15 downto 0);
    signal BREG: std_logic_vector(7 downto 0);
    signal COUNT: std_logic_vector(4 downto 0);
    signal QREG: std_logic_vector(7 downto 0);
    signal R: std_logic_vector(7 downto 0);
    signal COMPARE: std_logic_vector(0 downto 0);

    signal AREG_in: std_logic_vector(15 downto 0);
    signal BREG_in: std_logic_vector(7 downto 0);
    signal COUNT_in: std_logic_vector(4 downto 0);
    signal QUO_in: std_logic_vector(7 downto 0);
    signal QRESULT_in: std_logic_vector(7 downto 0);
    signal R_in: std_logic_vector(7 downto 0);
    signal COMPARE_in: std_logic_vector(0 downto 0);

    signal addA,addB: std_logic_vector(15 downto 0);
    signal addRESULT: std_logic_vector(16 downto 0);

    signal comRESULT: std_logic_vector(0  downto 0);

    signal subB,subA,subRESULT: std_logic_vector(7 downto 0);

    signal decrOut: std_logic_vector(4 downto 0);
    constant C7 : std_logic_vector(4 downto 0) := "01001";
    constant C0 : std_logic_vector(0 downto 0) := "0";
    constant C5 : std_logic_vector(4 downto 0) := "00000";
    constant C8 : std_logic_vector(7 downto 0) := (others => '0');

    signal count_enable,areg_enable, breg_enable, QUO_enable, R_enable ,QRESULT_enable , com_enable: std_logic;

begin
    -- predicate
    S <= '1' when (COUNT = C5) else '0';

    --------------------------------------------------------
    --  count-related logic
    --------------------------------------------------------
    -- decrementer
    decr: Decrement5  port map (A => COUNT, B => decrOut);

    -- count register.
    count_enable <=  (T0 or T1);
    COUNT_in <= decrOut when T1 = '1' else C7;
    count_reg: DataRegister
                   generic map (data_width => 5)
                   port map (Din => COUNT_in,
                             Dout => COUNT,
                             Enable => count_enable,
                             clk => clk);

    -------------------------------------------------
    -- AREG related logic.
    -------------------------------------------------
    subA <= AREG(15 downto 8);
    subB <= BREG when COMPARE(0)= '1' else C8;
    areg_sub : Subtractor port map(A => subA , B => subB , Result => subRESULT);

    areg_enable <= (T5 or T3 or T8);
    AREG_in <= (C8 & dividend) when T3 = '1'
                else (AREG(14 downto 0) & C0) when T5 ='1'
                else (subRESULT & AREG(7 downto 0));
    ar: DataRegister
             generic map (data_width => 16)
             port map (
			 Din => AREG_in, Dout => AREG,
				Enable => areg_enable, clk => clk);



    -------------------------------------------------
    -- BREG related logic..
    -------------------------------------------------
    BREG_in <= divisor;  -- not really needed, just being consistent.
    breg_enable <= T2;
    br: DataRegister generic map(data_width => 8)
			port map (Din => BREG_in, Dout => BREG, Enable => breg_enable, clk => clk);


    -------------------------------------------------
    -- COMPARATOR related logic
    -------------------------------------------------
    cmp : Comparator port map(A => AREG(15 downto 8) , B => BREG , RESULT => comRESULT(0));

    COMPARE_in <= comRESULT;
    com_enable <= T11;
    tr: DataRegister generic map(data_width => 1)
            port map(Din => COMPARE_in, Dout => COMPARE, Enable => com_enable, clk => clk);

    -------------------------------------------------
    -- QUO related logic
    QUO_enable <= (T4 or T7 or T6);
    QUO_in <= (QREG(7 downto 1) & COMPARE(0)) when T7 = '1'
                else (QREG(6 downto 0) & C0) when T6 ='1'
                else C8;
    pr: DataRegister generic map(data_width => 8)
			port map(Din => QUO_in, Dout => QREG, Enable => QUO_enable, clk => clk);

    -------------------------------------------------
    -- RRESULT related logic
    -------------------------------------------------
    R_in <= AREG(15 downto 8);
    R_enable <= T10;
    rr: DataRegister generic map(data_width => 8)
			port map(Din => R_in, Dout => remainder, Enable => R_enable, clk => clk);

    -------------------------------------------------
    -- QRESULT related logic
    -------------------------------------------------
    QRESULT_in <= QREG(7 downto 0);
    QRESULT_enable <= T9;
    qr: DataRegister generic map(data_width => 8)
            port map(Din => QRESULT_in, Dout => quotient, Enable => QRESULT_enable, clk => clk);


end Mixed;