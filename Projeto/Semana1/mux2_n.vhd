-- Entrada em A passa com seletor 0,
-- Entrada em B passa com seletor 1
library ieee;
use ieee.std_logic_1164.all;
 
entity mux2_n is
	generic(
		constant N: integer := 4
	);
	port(
		A, B: in std_logic_vector(N-1 downto 0);
		seletor: in std_logic;
		saida: out std_logic_vector(N-1 downto 0)
	);
end entity;
 
architecture comportamental of mux2_n is
	signal intermediario : std_logic_vector(N-1 downto 0) := (others => '0');
begin
	with seletor select 
		saida <= A when '0',
						 B when '1',
				 		intermediario when others; 
end architecture;