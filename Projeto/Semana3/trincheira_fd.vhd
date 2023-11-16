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
				medir							: in  std_logic;
				transmite         : in  std_logic;
				limpa_sensor			: in  std_logic;
        limpa_jogada      : in  std_logic;
				echo11						: in  std_logic;
				echo21						: in  std_logic;
				echo31						: in  std_logic;
				echo12						: in  std_logic;
				echo22						: in  std_logic;
				echo32						: in  std_logic;
				entrada_serial    : in  std_logic;
				saida_serial   		: out std_logic;
        atira1            : out std_logic;
        atira2            : out std_logic;
        horizontal1       : out std_logic;
        horizontal2       : out std_logic;
        vertical1         : out std_logic;
        vertical2         : out std_logic;
				trigger11				  : out std_logic;
				trigger21				  : out std_logic;
				trigger31				  : out std_logic;
				trigger12				  : out std_logic;
				trigger22				  : out std_logic;
				trigger32				  : out std_logic;
				fim_medidas6      : out std_logic;
				fim_transmissao   : out std_logic;
				acertou_tudo      : out std_logic;
				posiciona         : out std_logic;
				valido 						: out std_logic;
		    vez					      : out std_logic;
        fim_atira         : out std_logic;
        faz_jogada        : out std_logic;
				db_conta_medida   : out std_logic_vector(3 downto 0);
				db_dado1   : out std_logic_vector(3 downto 0);
				db_dado2   : out std_logic_vector(3 downto 0);
				db_maior11		  : out std_logic;
				db_maior21		  : out std_logic;
				db_maior31		  : out std_logic;
				db_maior12		  : out std_logic;
				db_maior22		  : out std_logic;
				db_maior32		  : out std_logic
    );
end entity;

architecture structural of trincheira_fd is
	component interface_hcsr04 is
    port (
				clock : in std_logic;
				reset : in std_logic;
				medir : in std_logic;
				echo : in std_logic;
				trigger : out std_logic;
				medida : out std_logic_vector(11 downto 0); -- 3 digitos BCD
				pronto : out std_logic;
				db_estado : out std_logic_vector(3 downto 0) -- estado da UC
    );
	end component interface_hcsr04;

	component comparador_n is
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
	end component comparador_n;

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

	component mux4_n is
    generic (
        constant N: integer := 4
    );
    port ( 
        D0 :     in  std_logic_vector (N-1 downto 0);
        D1 :     in  std_logic_vector (N-1 downto 0);
        D2 :     in  std_logic_vector (N-1 downto 0);
        D3 :     in  std_logic_vector (N-1 downto 0);
        SEL:     in  std_logic_vector (1 downto 0);
        MUX_OUT: out std_logic_vector (N-1 downto 0)
    );
	end component;

	component mux8_n is
    generic (
        constant N: integer := 4
    );
    port ( 
        D0 :     in  std_logic_vector (N-1 downto 0);
        D1 :     in  std_logic_vector (N-1 downto 0);
        D2 :     in  std_logic_vector (N-1 downto 0);
        D3 :     in  std_logic_vector (N-1 downto 0);
        D4 :     in  std_logic_vector (N-1 downto 0);
        D5 :     in  std_logic_vector (N-1 downto 0);
        D6 :     in  std_logic_vector (N-1 downto 0);
        D7 :     in  std_logic_vector (N-1 downto 0);
        SEL:     in  std_logic_vector (2 downto 0);
        MUX_OUT: out std_logic_vector (N-1 downto 0)
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
	
	component rx_serial_7O1 is
		port (
			clock             : in std_logic;
			reset             : in std_logic;
			dado_serial       : in std_logic;
			dado_recebido    : out std_logic_vector(6 downto 0);
			paridade_recebida : out std_logic;
			pronto_rx         : out std_logic;
			db_estado         : out std_logic_vector(6 downto 0);
			db_tick           : out std_logic;
			db_clock          : out std_logic
		);
	end component;

	component tx_serial_7O1 is
    port (
        clock           : in  std_logic;
        reset           : in  std_logic;
        partida         : in  std_logic;
        dados_ascii     : in  std_logic_vector(6 downto 0);
        saida_serial    : out std_logic;
        pronto          : out std_logic;
        db_clock        : out std_logic;
        db_tick         : out std_logic;
        db_partida      : out std_logic;
        db_saida_serial : out std_logic;
        db_estado       : out std_logic_vector(6 downto 0)
    );
	end component;

	-- Sinais para controle dos servomotores e sinal do registrador da vez
	signal s_vez_intermediario: std_logic_vector(0 downto 0);
	signal s_vez, s_seletor_atira1, s_seletor_atira2, s_direita, s_esquerda, s_cima, s_baixo: std_logic;
	signal s_conta_up_horizontal1, s_conta_down_horizontal1, s_conta_up_horizontal2, s_conta_down_horizontal2: std_logic;  
	signal s_conta_up_vertical1, s_conta_down_vertical1, s_conta_up_vertical2, s_conta_down_vertical2: std_logic;
	signal s_atira1, s_atira2, s_horizontal1, s_horizontal2, s_vertical1, s_vertical2: std_logic_vector(2 downto 0);
	-- Sinais da medicao de distancia
	signal s_conta_medida: std_logic;
	signal s_pronto11, s_pronto21, s_pronto31, s_pronto12, s_pronto22, s_pronto32: std_logic;
	signal s_medida11, s_medida21, s_medida31, s_medida12, s_medida22, s_medida32: std_logic_vector(11 downto 0);
	signal s_compara11, s_compara21, s_compara31, s_compara12, s_compara22, s_compara32: std_logic_vector(11 downto 0);
	signal s_maior11, s_maior21, s_maior31, s_maior12, s_maior22, s_maior32: std_logic;
	signal s_menor11, s_menor21, s_menor31, s_menor12, s_menor22, s_menor32: std_logic;
	-- Sinais de comunicacao serial
	signal s_pronto_tx, s_conta_soldados: std_logic;
	signal s_seletor_transmissao: std_logic_vector(1 downto 0);
	signal s_seletor_soldados: std_logic_vector(2 downto 0);
	signal s_transmissao1, s_transmissao2, s_transmissao3, s_dado_transmissao: std_logic_vector(6 downto 0);
	signal s_transmissao: std_logic_vector(11 downto 0);
	signal s_dado_recebido: std_logic_vector(6 downto 0);
begin
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
	
	CONTA_ATIRA: contador_m
		generic map (
			--M => 50_000_000, -- 1s 
			M => 50_000, -- 1ms para simulação
			N => 30
		)
		port map (
			clock => clock,
			zera  => limpa_jogada,
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
			db_pwm => open,
			db_posicao => open
		);
	
	ATIRA_JOGADOR2: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_atira2,
			pwm => atira2,
			db_reset => open,
			db_pwm => open,
			db_posicao => open
		);
	
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
			db_pwm => open,
			db_posicao => open
		);

	VERTICAL_JOGADOR1: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_vertical1,
			pwm => vertical1,
			db_reset => open,
			db_pwm => open,
			db_posicao => open
		);

	HORIZONTAL_JOGADOR2: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_horizontal2,
			pwm => horizontal2,
			db_reset => open,
			db_pwm => open,
			db_posicao => open
		);

	VERTICAL_JOGADOR2: controle_servo
		port map (
			clock => clock,
			reset => reset,
			posicao => s_vertical2,
			pwm => vertical2,
			db_reset => open,
			db_pwm => open,
			db_posicao => open
		);
	
	SENSOR_SOLDADO1JOG1: interface_hcsr04
		port map (
				clock     => clock,
				reset     => limpa_sensor,
				medir     => medir,
				echo      => echo11,
				trigger   => trigger11,
				medida    => s_medida11,
				pronto    => s_pronto11,
				db_estado => open
		);
	REG_SOLDADO1JOG1: registrador_n
		generic map (
			N => 12 
		)
		port map (
			clock  => clock,
			clear  => limpa_sensor,
			enable => s_pronto11,
			D      => s_medida11,
			Q      => s_compara11
		);
	COMP_SOLDADO1JOG1: comparador_n
    generic map (
        N => 12
    )
    port map (
        A      => "000000100000",
        B      => s_compara11,
        Bmaior => s_maior11,
        igual  => open,
        Bmenor => s_menor11
    );
	
	SENSOR_SOLDADO2JOG1: interface_hcsr04
		port map (
				clock     => clock,
				reset     => limpa_sensor,
				medir     => medir,
				echo      => echo21,
				trigger   => trigger21,
				medida    => s_medida21,
				pronto    => s_pronto21,
				db_estado => open
		);
	REG_SOLDADO2JOG1: registrador_n
		generic map (
			N => 12 
		)
		port map (
			clock  => clock,
			clear  => limpa_sensor,
			enable => s_pronto21,
			D      => s_medida21,
			Q      => s_compara21
		);
	COMP_SOLDADO2JOG1: comparador_n
    generic map (
        N => 12
    )
    port map (
        A      => "000000100000",
        B      => s_compara21,
        Bmaior => s_maior21,
        igual  => open,
        Bmenor => s_menor21
    );
	
	SENSOR_SOLDADO3JOG1: interface_hcsr04
		port map (
				clock     => clock,
				reset     => limpa_sensor,
				medir     => medir,
				echo      => echo31,
				trigger   => trigger31,
				medida    => s_medida31,
				pronto    => s_pronto31,
				db_estado => open
		);
	REG_SOLDADO3JOG1: registrador_n
		generic map (
			N => 12 
		)
		port map (
			clock  => clock,
			clear  => limpa_sensor,
			enable => s_pronto31,
			D      => s_medida31,
			Q      => s_compara31
		);
	COMP_SOLDADO3JOG1: comparador_n
    generic map (
        N => 12
    )
    port map (
        A      => "000000100000",
        B      => s_compara31,
        Bmaior => s_maior31,
        igual  => open,
        Bmenor => s_menor31
    );

	SENSOR_SOLDADO1JOG2: interface_hcsr04
		port map (
				clock     => clock,
				reset     => limpa_sensor,
				medir     => medir,
				echo      => echo12,
				trigger   => trigger12,
				medida    => s_medida12,
				pronto    => s_pronto12,
				db_estado => open
		);
	REG_SOLDADO1JOG2: registrador_n
		generic map (
			N => 12 
		)
		port map (
			clock  => clock,
			clear  => limpa_sensor,
			enable => s_pronto12,
			D      => s_medida12,
			Q      => s_compara12
		);
	COMP_SOLDADO1JOG2: comparador_n
    generic map (
        N => 12
    )
    port map (
        A      => "000000100000",
        B      => s_compara12,
        Bmaior => s_maior12,
        igual  => open,
        Bmenor => s_menor12
    );

	SENSOR_SOLDADO2JOG2: interface_hcsr04
		port map (
				clock     => clock,
				reset     => limpa_sensor,
				medir     => medir,
				echo      => echo22,
				trigger   => trigger22,
				medida    => s_medida22,
				pronto    => s_pronto22,
				db_estado => open
		);
	REG_SOLDADO2JOG2: registrador_n
		generic map (
			N => 12 
		)
		port map (
			clock  => clock,
			clear  => limpa_sensor,
			enable => s_pronto22,
			D      => s_medida22,
			Q      => s_compara22
		);
	COMP_SOLDADO2JOG2: comparador_n
    generic map (
        N => 12
    )
    port map (
        A      => "000000100000",
        B      => s_compara22,
        Bmaior => s_maior22,
        igual  => open,
        Bmenor => s_menor22
    );
	
	SENSOR_SOLDADO3JOG2: interface_hcsr04
		port map (
				clock     => clock,
				reset     => limpa_sensor,
				medir     => medir,
				echo      => echo32,
				trigger   => trigger32,
				medida    => s_medida32,
				pronto    => s_pronto32,
				db_estado => open
		);
	REG_SOLDADO3JOG2: registrador_n
		generic map (
			N => 12 
		)
		port map (
			clock  => clock,
			clear  => limpa_sensor,
			enable => s_pronto32,
			D      => s_medida32,
			Q      => s_compara32
		);
	COMP_SOLDADO3JOG2: comparador_n
    generic map (
        N => 12
    )
    port map (
        A      => "000000100000",
        B      => s_compara32,
        Bmaior => s_maior32,
        igual  => open,
        Bmenor => s_menor32
    );

	s_conta_medida <= s_pronto11 or s_pronto21 or s_pronto31 or s_pronto12 or s_pronto22 or s_pronto32;
	CONTA_MEDIDA: contador_m
		generic map (
			M => 6,
			--M => 7, para simulacao
			N => 4
		)
		port map (
			clock => clock,
			zera  => limpa_sensor,
			conta => s_conta_medida,
			Q     => db_conta_medida,
			fim   => fim_medidas6,
			meio  => open
		);

	MUX_SOLDADOS: mux8_n
			generic map (
					N => 12
			)
			port map ( 
					D0       => s_compara11,
					D1       => s_compara21,
					D2       => s_compara31,
					D3       => s_compara12,
					D4       => s_compara22,
					D5       => s_compara32,
					D6       => "000000100011",
					D7       => "000000000000",
					SEL      => s_seletor_soldados,
					MUX_OUT  => s_transmissao
		);
		s_transmissao1 <= "011" & s_transmissao(3 downto 0);
		s_transmissao2 <= "011" & s_transmissao(7 downto 4);
		s_transmissao3 <= "011" & s_transmissao(11 downto 8);

	MUX_TRANSMISSAO: mux4_n
			generic map (
					N => 7
			)
			port map ( 
					D0       => s_transmissao1,
					D1       => s_transmissao2,
					D2       => s_transmissao3,
					D3       => "0101100",
					SEL      => s_seletor_transmissao,
					MUX_OUT  => s_dado_transmissao
			);

	TRANSMISSOR_SERIAL: tx_serial_7O1
    port map (
        clock           => clock,
        reset           => reset,
        partida         => '0',
        dados_ascii     => s_dado_transmissao,
        saida_serial    => saida_serial,
        pronto          => s_pronto_tx,
        db_clock        => open,
        db_tick         => open,
        db_partida      => open,
        db_saida_serial => open,
        db_estado       => open
    );

	CONTA_TRANSMISSAO: contador_m
		generic map (
			M => 4,
			--M => 5, para simulacao
			N => 2
		)
		port map (
			clock => clock,
			zera  => '0',
			conta => s_pronto_tx,
			Q     => s_seletor_transmissao,
			fim   => s_conta_soldados,
			meio  => open
		);

	CONTA_SOLDADOS: contador_m
		generic map (
			M => 7,
			--M => 8, para simulacao
			N => 3
		)
		port map (
			clock => clock,
			zera  => '0',
			conta => s_conta_soldados,
			Q     => s_seletor_soldados,
			fim   => fim_transmissao,
			meio  => open
		);

	RECEPTOR_SERIAL: rx_serial_7O1
		port map (
			clock             => clock,
			reset             => reset,
			dado_serial       => entrada_serial,
			dado_recebido     => s_dado_recebido,
			paridade_recebida => open,
			pronto_rx         => open,
			db_estado         => open,
			db_tick           => open,
			db_clock          => open
		);

	COMP_FAZJOGADA: comparador_n
		generic map (
				N => 7
		)
		port map (
				A      => s_dado_recebido,
				B      => "0100000", -- 20 -> barra de espaco
				Bmaior => open,
				igual  => faz_jogada,
				Bmenor => open
	);
		
	COMP_POSICIONA: comparador_n
		generic map (
				N => 7
		)
		port map (
				A      => s_dado_recebido,
				B      => "1110000", -- 70 -> p
				Bmaior => open,
				igual  => posiciona,
				Bmenor => open
		);

	COMP_DIREITA: comparador_n
    generic map (
        N => 7
    )
    port map (
        A      => s_dado_recebido,
        B      => "1100100", -- 64 -> d
        Bmaior => open,
        igual  => s_direita,
        Bmenor => open
    );

	s_conta_up_horizontal1 <= s_direita and not(s_vez);
	s_conta_up_horizontal2 <= s_direita and s_vez;

	COMP_ESQUERDA: comparador_n
    generic map (
        N => 7
    )
    port map (
        A      => s_dado_recebido,
        B      => "1100001", -- 61 -> a
        Bmaior => open,
        igual  => s_esquerda,
        Bmenor => open
    );

	s_conta_down_horizontal1 <= s_esquerda and not(s_vez);
	s_conta_down_horizontal2 <= s_esquerda and s_vez;

	COMP_CIMA: comparador_n
    generic map (
        N => 7
    )
    port map (
        A      => s_dado_recebido,
        B      => "1110111", -- 77 -> w
        Bmaior => open,
        igual  => s_cima,
        Bmenor => open
    );

	s_conta_up_vertical1 <= s_cima and not(s_vez);
	s_conta_up_vertical2 <= s_cima and s_vez;

	COMP_BAIXO: comparador_n
    generic map (
        N => 7
    )
    port map (
        A      => s_dado_recebido,
        B      => "1110011", -- 73 -> s
        Bmaior => open,
        igual  => s_baixo,
        Bmenor => open
    );

	s_conta_down_vertical1 <= s_baixo and not(s_vez);
	s_conta_down_vertical2 <= s_baixo and s_vez;

	-- Debug
	db_maior11 <= s_maior11;
	db_maior21 <= s_maior21;
	db_maior31 <= s_maior31;
	db_maior12 <= s_maior12;
	db_maior22 <= s_maior22;
	db_maior32 <= s_maior32;
	db_dado1 <= s_dado_recebido(3 downto 0);
	db_dado2 <= '0' & s_dado_recebido(6 downto 4);
	-- Output
	valido <= s_menor11 and s_menor21 and s_menor31 and s_menor12 and s_menor22 and s_menor32;
	acertou_tudo <= (s_maior11 and s_maior21 and s_maior31) or (s_maior12 and s_maior22 and s_maior32);
	vez <= s_vez;

end architecture;