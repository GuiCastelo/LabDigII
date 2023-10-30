library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity trincheira_fd is
    port (
        clock             : in  std_logic;
        reset             : in  std_logic;
        atira             : in  std_logic;
        troca             : in  std_logic;
				detona			  		: in  std_logic;
				cursores		  		: in  std_logic_vector(3 downto 0);
        atira1            : out std_logic;
        atira2            : out std_logic;
        horizontal1       : out std_logic;
        horizontal2       : out std_logic;
        vertical1         : out std_logic;
        vertical2         : out std_logic;
        fim_atira         : out std_logic;
        faz_jogada        : out std_logic;
        db_atira1         : out std_logic;
        db_atira2         : out std_logic;
        db_horizontal1    : out std_logic;
        db_horizontal2    : out std_logic;
        db_vertical1      : out std_logic;
        db_vertical2      : out std_logic
    );
end entity;

architecture structural of trincheira_fd is
	component registrador_n is
		generic (
			constant N: integer := 8 
		);
		port (
			clock  : in  std_logic;
			clear  : in  std_logic;
			enable : in  std_logic;
			D      : in  std_logic_vector (N-1 downto 0);
			Q      : out std_logic_vector (N-1 downto 0) 
		);
	end component;

	component edge_detector is
		port (  
			clock     : in  std_logic;
			signal_in : in  std_logic;
			output    : out std_logic
		);
	end component;

	component contador_m is
		generic (
			constant M : integer := 50;  
			constant N : integer := 6 
		);
		port (
			clock : in  std_logic;
			zera  : in  std_logic;
			conta : in  std_logic;
			Q     : out std_logic_vector (N-1 downto 0);
			fim   : out std_logic;
			meio  : out std_logic
		);
	end component contador_m;

	component controle_servo is
		port (
			clock : in std_logic;
			reset : in std_logic;
			posicao : in std_logic_vector(2 downto 0);
			pwm : out std_logic;
			db_reset : out std_logic;
			db_pwm : out std_logic;
			db_posicao : out std_logic_vector(2 downto 0)
		);
	end component;

	component mux2_n is
		generic(
			constant N: integer := 4
		);
		port(
			A, B: in std_logic_vector(N-1 downto 0);
			seletor: in std_logic;
			saida: out std_logic_vector(N-1 downto 0)
		);
	end component;

	component contador_updown_m is
		generic (
			constant M: integer := 50 -- modulo do contador
		);
		port (
			clock       : in  std_logic;
			zera_as     : in  std_logic;
			zera_s      : in  std_logic;
			conta_up    : in  std_logic;
			conta_down  : in  std_logic;
			Q           : out std_logic_vector (natural(ceil(log2(real(M))))-1 downto 0);
			inicio      : out std_logic;
			fim         : out std_logic;
			meio        : out std_logic 
	   );
	end component;

	signal s_vez, s_seletor_atira1, s_seletor_atira2, s_conta_direita, s_conta_esquerda, s_conta_cima, s_conta_baixo: std_logic;
	signal s_conta_up_horizontal1, s_conta_down_horizontal1, s_conta_up_horizontal2, s_conta_down_horizontal2: std_logic;  
	signal s_conta_up_vertical1, s_conta_down_vertical1, s_conta_up_vertical2, s_conta_down_vertical2: std_logic;
	signal s_esquerda, s_direita, s_baixo, s_cima: std_logic;
	signal s_vez_intermediario: std_logic_vector(0 downto 0);
	signal s_atira1, s_atira2, s_horizontal1, s_horizontal2, s_vertical1, s_vertical2: std_logic_vector(2 downto 0);
begin
	s_esquerda <= cursores(0);
	s_direita <= cursores(1);
	s_baixo <= cursores(2);
	s_cima <= cursores(3);

	REG_VEZ: registrador_n
		generic map (
			N => 1 
		)
		port map (
			clock  => clock,
			clear  => reset,
			enable => troca,
			D      => "not"(s_vez_intermediario),
			Q      => s_vez_intermediario
		);
		s_vez <= s_vez_intermediario(0);
	
	DETEC_JOGADA: edge_detector
		port map (  
			clock     => clock,
			signal_in => detona,
			output    => faz_jogada
		);
	
	CONTA_ATIRA: contador_m
		generic map (
			M => 5_000_000, -- 100ms 
			--M => 5_000, -- 100us para simulação
			N => 6
		)
		port map (
			clock => clock,
			zera  => "not"(atira),
			conta => atira,
			Q     => open,
			fim   => fim_atira,
			meio  => open
		);

	s_seletor_atira1 <= not(s_vez) and atira;
	MUX_ATIRA1: mux2_n
		generic map (
			N => 3
		)
		port map (
			A => "000",
			B => "111",
			seletor => s_seletor_atira1,
			saida => s_atira1
		);
	
	s_seletor_atira2 <= s_vez and atira;
	MUX_ATIRA2: mux2_n
		generic map (
			N => 3
		)
		port map (
			A => "000",
			B => "111",
			seletor => s_seletor_atira2,
			saida => s_atira2
		);

	ATIRA_JOGADOR1: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_atira1,
			pwm => atira1,
			db_reset => open,
			db_pwm => db_atira1,
			db_posicao => open
		);
	
	ATIRA_JOGADOR2: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_atira2,
			pwm => atira2,
			db_reset => open,
			db_pwm => db_atira2,
			db_posicao => open
		);

	CONTA_ESQUERDA: contador_m
		generic map (
			M => 10_000_000, -- 200ms 
			--M => 10_000, -- 200us para simulação
			N => 6
		)
		port map (
			clock => clock,
			zera  => "not"(s_esquerda),
			conta => s_esquerda,
			Q     => open,
			fim   => s_conta_esquerda,
			meio  => open
		);
	s_conta_down_horizontal1 <= s_conta_esquerda and not(s_vez);
	s_conta_down_horizontal2 <= s_conta_esquerda and s_vez;

	CONTA_DIREITA: contador_m
		generic map (
			M => 10_000_000, -- 200ms 
			--M => 10_000, -- 200us para simulação
			N => 6
		)
		port map (
			clock => clock,
			zera  => "not"(s_direita),
			conta => s_direita,
			Q     => open,
			fim   => s_conta_direita,
			meio  => open
		);
	s_conta_up_horizontal1 <= s_conta_direita and not(s_vez);
	s_conta_up_horizontal2 <= s_conta_direita and s_vez;
	
	CONTA_BAIXO: contador_m
		generic map (
			M => 10_000_000, -- 200ms 
			--M => 10_000, -- 200us para simulação
			N => 6
		)
		port map (
			clock => clock,
			zera  => "not"(s_baixo),
			conta => s_baixo,
			Q     => open,
			fim   => s_conta_baixo,
			meio  => open
		);
	s_conta_down_vertical1 <= s_conta_baixo and not(s_vez);
	s_conta_down_vertical2 <= s_conta_baixo and s_vez;

	CONTA_CIMA: contador_m
		generic map (
			M => 10_000_000, -- 200ms 
			--M => 10_000, -- 200us para simulação
			N => 6
		)
		port map (
			clock => clock,
			zera  => "not"(s_cima),
			conta => s_cima,
			Q     => open,
			fim   => s_conta_cima,
			meio  => open
		);
	s_conta_up_vertical1 <= s_conta_cima and not(s_vez);
	s_conta_up_vertical2 <= s_conta_cima and s_vez;
	
	POSICAO_HORIZONTAL1: contador_updown_m
		generic map (
			M => 8
		)
		port map (
			clock       => clock,
			zera_as     => reset,
			zera_s      => '0',
			conta_up    => s_conta_up_horizontal1,
			conta_down  => s_conta_down_horizontal1,
			Q           => s_horizontal1,
			inicio      => open,
			fim         => open,
			meio        => open
	   	);

	POSICAO_HORIZONTAL2: contador_updown_m
	   	generic map (
		  	M => 8
	   	)
	   	port map (
		   clock       => clock,
		   zera_as     => reset,
		   zera_s      => '0',
		   conta_up    => s_conta_up_horizontal2,
		   conta_down  => s_conta_down_horizontal2,
		   Q           => s_horizontal2,
		   inicio      => open,
		   fim         => open,
		   meio        => open
	  	);

	POSICAO_VERTICAL1: contador_updown_m
		generic map (
			M => 8
		)
		port map (
			clock       => clock,
			zera_as     => reset,
			zera_s      => '0',
			conta_up    => s_conta_up_vertical1,
			conta_down  => s_conta_down_vertical1,
			Q           => s_vertical1,
			inicio      => open,
			fim         => open,
			meio        => open
		);

	POSICAO_VERTICAL2: contador_updown_m
		generic map (
			M => 8
		)
		port map (
			clock       => clock,
			zera_as     => reset,
			zera_s      => '0',
			conta_up    => s_conta_up_vertical2,
			conta_down  => s_conta_down_vertical2,
			Q           => s_vertical2,
			inicio      => open,
			fim         => open,
			meio        => open
		);

	HORIZONTAL_JOGADOR1: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_horizontal1,
			pwm => horizontal1,
			db_reset => open,
			db_pwm => db_horizontal1,
			db_posicao => open
		);

	VERTICAL_JOGADOR1: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_vertical1,
			pwm => vertical1,
			db_reset => open,
			db_pwm => db_vertical1,
			db_posicao => open
		);

	HORIZONTAL_JOGADOR2: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_horizontal2,
			pwm => horizontal2,
			db_reset => open,
			db_pwm => db_horizontal2,
			db_posicao => open
		);

	VERTICAL_JOGADOR2: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_vertical2,
			pwm => vertical2,
			db_reset => open,
			db_pwm => db_vertical2,
			db_posicao => open
		);

end architecture;