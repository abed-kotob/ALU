------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------------------------------------------------------------------------
entity ALU is --{

    port(A, B : in std_logic_vector (3 downto 0);   --// 4 bit inputs             ==> 3 2 1 0
          CMD : in std_logic_vector (2 downto 0);   --// 3 bit input op_specifier ==> 2 1 0
         Z,V,C: out std_logic;                      --// 1 bit flags
            
            R : out std_logic_vector (3 downto 0)); --// result

end ALU;
--}
------------------------------------------------------------------------------------------------------------
architecture beh of ALU is --{ 

-- /* TOTAL OPERATIONS: 8 
--  * CMD VALUES: 000(0), 001(1), 010(2), 011(3), 100(4), 101(5), 110(6), 111(7)
--  */

    signal temp_sA : signed (3 downto 0);       
    signal temp_sB : signed (3 downto 0);

    signal temp_uA : unsigned (3 downto 0);
    signal temp_uB : unsigned (3 downto 0);

    signal RR : std_logic_vector (3 downto 0);
    
    signal sum : signed(4 downto 0); 
    signal sub : signed(4 downto 0); 

    --signal cout : std_logic;
    signal c4 : std_logic;
    signal c3 : std_logic;
    signal c2 : std_logic;
    signal c1 : std_logic;

begin

    temp_sA <= signed(A);
    temp_sB <= signed(B);

    temp_uA <= unsigned(A);
    temp_uB <= unsigned(B);

    with CMD select

        R <=std_logic_vector(temp_sA + temp_sB) when "000",
            std_logic_vector(temp_sA - temp_sB) when "001", 
            
            std_logic_vector(temp_uA or temp_uB) when "010",
            std_logic_vector(temp_uA and temp_uB) when "011",
            
            std_logic_vector( shift_left(temp_uA, to_integer(temp_uB(1 downto 0)) ) ) when "100",
            std_logic_vector( shift_right(temp_uA, to_integer(temp_uB(1 downto 0)) ) ) when "101",
            
            std_logic_vector( rotate_left(temp_uA, to_integer(temp_uB(1 downto 0)) ) ) when "110",
            std_logic_vector( rotate_right(temp_uA, to_integer(temp_uB(1 downto 0)) ) ) when "111",

            "0000" when others;

    with CMD select --// repeat for signal RR (replicaResult) to check if R is 0 by chekng RR and maybe use for other flags

        RR <=std_logic_vector(temp_sA + temp_sB) when "000",
             std_logic_vector(temp_sA - temp_sB) when "001",
             
             std_logic_vector(temp_uA or temp_uB) when "010",
             std_logic_vector(temp_uA and temp_uB) when "011",
             
             std_logic_vector( shift_left(temp_uA, to_integer(temp_uB(1 downto 0)) ) ) when "100",
             std_logic_vector( shift_right(temp_uA, to_integer(temp_uB(1 downto 0)) ) ) when "101",
             
             std_logic_vector( rotate_left(temp_uA, to_integer(temp_uB(1 downto 0)) ) ) when "110",
             std_logic_vector( rotate_right(temp_uA, to_integer(temp_uB(1 downto 0)) ) ) when "111",

             "0000" when others;
    
    
    Z <= '1' when RR = "0000" else '0'; --// indicate by 1 that result is zero
    --temp_sB <= (-temp_SB) when CMD = "001"; 



    --// CHECK FOR CARRY OUT and OVERFLOW

    sum <= ('0'&temp_sA)+('0'&temp_sB);
    sub <= ('0'&temp_sA)-('0'&temp_sB);

    C <= '1' when (  ((CMD = "000") and (sum(4) = '1')) or ( (CMD = "001") and (sub(4) = '1') )  ) else '0';
    --C <= '0' when sub(4) = '0' else '1';


    --c4 <= sub(4) when (CMD = "001"); --c3 <= sub(3) when (CMD = "001"); --c4 <= sum(4) when (CMD = "000"); --c3 <= sum(3) when (CMD = "000");

    c1 <= temp_sA(0) and temp_sB(0);
    c2 <= (temp_sA(1) and temp_sB(1)) or (temp_sA(1) and c1) or (temp_sB(1) and c1);
    c3 <= (temp_sA(2) and temp_sB(2)) or (temp_sA(2) and c2) or (temp_sB(2) and c2);
    c4 <= (temp_sA(3) and temp_sB(3)) or (temp_sA(3) and c3) or (temp_sB(3) and c3);

    with CMD select
        
        V <= (c3 xor c4) when "000", --// satisfying overflow xor for 4-bit results
             (c3 xor c4) when "001",
             '0' when others;

    --V <= sum(4) xor sum(3) xor A(3) xor B(3); --V <= sub(4) xor sub(3) xor A(3) xor B(3);
    --cout <= '0' when sum(4) = '0' else '1'; --cout <= '0' when sub(4) = '0' else '1'; 
    --V <= '1' when cout = '1' else '0';

end beh;
--}
------------------------------------------------------------------------------------------------------------