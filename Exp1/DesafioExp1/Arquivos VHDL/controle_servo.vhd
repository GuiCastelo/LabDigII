-----------------Laboratorio Digital--------------------------------------
-- Arquivo   : controle_servo.vhd
-- Projeto   : Experiencia 1 - Controle de um servomotor
--------------------------------------------------------------------------
-------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity controle_servo is
    port (
        clock : in std_logic;
        reset : in std_logic;
        controle : out std_logic
    );
end entity;

architecture structural of controle_servo is
	component contador_m is
    generic (
        constant M: integer := 100 -- modulo do contador
    );
    port (
        clock   : in  std_logic;
        zera_as : in  std_logic;
        zera_s  : in  std_logic;
        conta   : in  std_logic;
        Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
        fim     : out std_logic;
        meio    : out std_logic
    );
	end component;

  component circuito_pwm is
  generic (
      conf_periodo : integer;
      largura_000   : integer;
      largura_001   : integer;
      largura_010   : integer;
      largura_011   : integer;
			largura_100   : integer;
      largura_101   : integer;
      largura_110   : integer;
      largura_111   : integer
  );
    port (
      clock   : in  std_logic;
      reset   : in  std_logic;
      largura : in  std_logic_vector(2 downto 0);  
      pwm     : out std_logic 
    );
  end component;

	signal s_fim: std_logic;
	signal s_conta: std_logic_vector(2 downto 0);

begin
TEMP: contador_m
				generic map (
						M => 50000000
				)
				port map (
						clock   => clock,
						zera_as => '0',
						zera_s  => '0',
						conta   => '1',
						Q       => open,
						fim     => s_fim,
						meio    => open
				);

CONTADOR: contador_m
				generic map (
						M => 8
				)
				port map (
						clock   => clock,
						zera_as => '0',
						zera_s  => '0',
						conta   => s_fim,
						Q       => s_conta,
						fim     => open,
						meio    => open
				);

PWM: circuito_pwm
       generic map (
           conf_periodo => 1000000,  -- periodo do sinal pwm [1_000_000 => f=50Hz (20ms)]
           largura_000   => 0,
           largura_001   => 50000,  
           largura_010   => 58333,  
           largura_011   => 66666,  
					 largura_100   => 75000,
           largura_101   => 83332,
           largura_110   => 91665,  
           largura_111   => 100000  
       )
       port map( 
           clock   => clock,
           reset   => reset,
           largura => s_conta,
           pwm     => controle
       );

end architecture;