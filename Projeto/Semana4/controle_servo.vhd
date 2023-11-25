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
    generic (
        conf_periodo  : integer := 1_000_000;  
        largura_000   : integer := 35_000;
        largura_001   : integer := 45_700;
        largura_010   : integer := 56_450;  
        largura_011   : integer := 67_150;
        largura_100   : integer := 77_850;
        largura_101   : integer := 88_550; 
        largura_110   : integer := 99_300;
        largura_111   : integer := 110_000 
    );
    port (
        clock : in std_logic;
        reset : in std_logic;
        posicao : in std_logic_vector(2 downto 0);
        pwm : out std_logic;
        db_reset : out std_logic;
        db_pwm : out std_logic;
        db_posicao : out std_logic_vector(2 downto 0)
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

  signal s_pwm: std_logic;
begin
CIRC_PWM: circuito_pwm
       generic map (
          conf_periodo => conf_periodo,
          largura_000  => largura_000,
          largura_001  => largura_001, 
          largura_010  => largura_010,  
          largura_011  => largura_011,
          largura_100  => largura_100,
          largura_101  => largura_101, 
          largura_110  => largura_110,
          largura_111  => largura_111
          -- CONFIGURAÇÃO PARA SIMULAÇÃO APENAS
          -- conf_periodo => conf_periodo/1_000,
          -- largura_000  => largura_000/1_000,
          -- largura_001  => largura_001/1_000, 
          -- largura_010  => largura_010/1_000,  
          -- largura_011  => largura_011/1_000,
          -- largura_100  => largura_100/1_000,
          -- largura_101  => largura_101/1_000, 
          -- largura_110  => largura_110/1_000,
          -- largura_111  => largura_111/1_000
       )
       port map( 
           clock   => clock,
           reset   => reset,
           largura => posicao,
           pwm     => s_pwm
       );

    -- output
    pwm <= s_pwm;

    -- debug
    db_reset <= reset;
    db_pwm <= s_pwm;
    db_posicao <= posicao;

end architecture;