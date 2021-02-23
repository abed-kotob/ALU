------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
------------------------------------------------------------------------------------------------------------
entity tb is 
end tb;
------------------------------------------------------------------------------------------------------------
architecture driver of tb is --{

    --[]
    component ALU

        port(A, B : in std_logic_vector (3 downto 0); --// 4 bit inputs
              CMD : in std_logic_vector (2 downto 0); --// 3 bit input op_specifier
             Z,V,C: out std_logic;                    --// 1 bit flags
        
                R : out std_logic_vector (3 downto 0) );                   --// result
    end component;
    --[]

    --> tb signals
    signal tb_A : std_logic_vector (3 downto 0) := "1001"; 
    signal tb_B : std_logic_vector (3 downto 0) := "0010"; --// PREVIOUS VALUE: "1110"
    signal tb_CMD : std_logic_vector (2 downto 0) := "000";

    signal tb_Z : std_logic;
    signal tb_V : std_logic;
    signal tb_C : std_logic;

    signal tb_R : std_logic_vector(3 downto 0);

--=> instantiation + input stimulus signals

begin 
    
     UUT: ALU port map(
         
        A => tb_A , 
        B => tb_B , 
        CMD => tb_CMD,

        Z => tb_Z,
        V => tb_V,
        C => tb_C,
        R => tb_R

     );

    tb_CMD <= "000" after 10 ns, "001" after 20 ns, "010" after 30 ns,
              "011" after 40 ns,
              "100" after 50 ns,"101" after 60 ns,"110" after 70 ns,
              "111" after 80 ns;

end driver;
--} 
------------------------------------------------------------------------------------------------------------