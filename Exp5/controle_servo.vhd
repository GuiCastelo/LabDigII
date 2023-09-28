-----------------Laboratorio Digital--------------------------------------
-- Arquivo   : controle_servo.vhd
-- Projeto   : Experiencia 1 - Controle de um servomotor
--------------------------------------------------------------------------
-------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_servo is
    port (
        clock : in std_logic;
        reset : in std_logic;
        posicao : in std_logic_vector(2 downto 0);
        controle : out std_logic
    );
end entity;

architecture structural of controle_servo is
  component circuito_pwm is
    generic (
      conf_periodo : integer := 1250;  
      largura_000   : integer :=   0;
      largura_001   : integer :=   200;  
      largura_010   : integer :=  400;   
      largura_011   : integer := 600;   
      largura_100   : integer :=  800;
      largura_101   : integer :=  1000; 
      largura_110   : integer :=  1100;  
      largura_111   : integer := 1200   
  );
    port (
      clock   : in  std_logic;
      reset   : in  std_logic;
      largura : in  std_logic_vector(2 downto 0);  
      pwm     : out std_logic 
    );
  end component;

begin
PWM: circuito_pwm
       generic map (
          conf_periodo => 1000000,
          largura_000  => 35000,
          largura_001  => 45700, 
          largura_010  => 56450,  
          largura_011  => 67150,
          largura_100  => 77850,
          largura_101  => 88550, 
          largura_110  => 99300,
          largura_111  => 110000
       )
       port map( 
           clock   => clock,
           reset   => reset,
           largura => posicao,
           pwm     => controle
       );

end architecture;