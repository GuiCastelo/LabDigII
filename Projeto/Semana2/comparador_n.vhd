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
begin
  Bmaior <= '1' when unsigned(B) > unsigned(A) else
            '0';
  Bmenor <= '1' when unsigned(B) < unsigned(A) else
  '0';
  igual <= '1' when unsigned(B) = unsigned(A) else
  '0';
end architecture comportamental;