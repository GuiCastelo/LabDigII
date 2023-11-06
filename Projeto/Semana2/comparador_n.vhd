library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador_n is
    generic (
        constant N: integer := 12 
    );
    port (
        A      : in  std_logic_vector (N-1 downto 0);
        B      : in  std_logic_vector (N-1 downto 0);
        Bmaior : out std_logic;
        igual  : out std_logic;
        Bmenor : out std_logic
    );
end entity comparador_n;

architecture comportamental of comparador_n is
  signal intA, intB: integer;
begin
    intA <= to_integer(unsigned(A));
    intB <= to_integer(unsigned(B));
    process(A, B)
        begin
            Bmaior <= '0';
            igual <= '0';
            Bmenor <= '0';
            if (intA=intB) then 
              igual <= '0';
            elsif (intB>intA) then
              Bmaior <= '1';
            else
              Bmenor <= '1';
            end if;
        end process;
end architecture comportamental;