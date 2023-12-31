library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity sonar_fd is
    port (
        clock             : in  std_logic;
        reset             : in  std_logic;
		entrada_serial    : in  std_logic;
        medir             : in  std_logic;
        echo              : in  std_logic;
        conta_posicao     : in  std_logic;
        conta_timer       : in  std_logic;
        zera              : in  std_logic;
        transmitir        : in  std_logic;
        trigger           : out std_logic;
        pwm               : out std_logic;
        medida            : out std_logic_vector(11 downto 0);
        posicao           : out std_logic_vector(3 downto 0);
        saida_serial      : out std_logic;
        fim_medida        : out std_logic;
        fim_transmissao   : out std_logic;
        fim_2seg          : out std_logic;
		modo              : out std_logic_vector(1 downto 0);
		pronto_rx		  : out std_logic
    );
end entity;

architecture structure of sonar_fd is
    component mux_8x1_n is
        generic (
            constant BITS: integer := 4
        );
        port ( 
            D0 :     in  std_logic_vector (BITS-1 downto 0);
            D1 :     in  std_logic_vector (BITS-1 downto 0);
            D2 :     in  std_logic_vector (BITS-1 downto 0);
            D3 :     in  std_logic_vector (BITS-1 downto 0);
            D4 :     in  std_logic_vector (BITS-1 downto 0);
            D5 :     in  std_logic_vector (BITS-1 downto 0);
            D6 :     in  std_logic_vector (BITS-1 downto 0);
            D7 :     in  std_logic_vector (BITS-1 downto 0);
            SEL:     in  std_logic_vector (2 downto 0);
            MUX_OUT: out std_logic_vector (BITS-1 downto 0)
        );
    end component mux_8x1_n;
	 
	 component rx_serial_7O1 is
		 port (
        clock             : in std_logic;
        reset             : in std_logic;
        dado_serial       : in std_logic;
        dado_recebido     : out std_logic_vector(6 downto 0);
        paridade_recebida : out std_logic;
        pronto_rx         : out std_logic;
        db_estado         : out std_logic_vector(6 downto 0);
        db_tick           : out std_logic;
        db_clock          : out std_logic
		 );
	end component;

    component controle_servo_3 is
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

    component rom_angulos_8x24 is
        port (
            endereco : in  std_logic_vector(2 downto 0);
            saida    : out std_logic_vector(23 downto 0)
        ); 
    end component;

    component contadorg_updown_m is
        generic (
            constant M: integer := 50 -- modulo do contador
        );
        port (
            clock  : in  std_logic;
            zera_as: in  std_logic;
            zera_s : in  std_logic;
            conta  : in  std_logic;
            Q      : out std_logic_vector (natural(ceil(log2(real(M))))-1 downto 0);
            inicio : out std_logic;
            fim    : out std_logic;
            meio   : out std_logic 
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
            db_estado       : out std_logic_vector(3 downto 0)
        );
    end component;

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

    signal s_medida: std_logic_vector(11 downto 0);
    signal s_dado_ascii, s_distancia0_ascii, s_distancia1_ascii, s_distancia2_ascii: std_logic_vector(6 downto 0);
    signal s_dado_recebido, s_angulo0_ascii, s_angulo1_ascii, s_angulo2_ascii: std_logic_vector(6 downto 0);
    signal s_posicao, s_sel: std_logic_vector(2 downto 0);
    signal s_saida_angulos: std_logic_vector(23 downto 0);
    signal s_pronto_tx: std_logic;
begin
    s_distancia0_ascii <= "011" & s_medida(3 downto 0);
    s_distancia1_ascii <= "011" & s_medida(7 downto 4);
    s_distancia2_ascii <= "011" & s_medida(11 downto 8);
    s_angulo0_ascii <=  s_saida_angulos(6 downto 0);
    s_angulo1_ascii <=  s_saida_angulos(14 downto 8);
    s_angulo2_ascii <=  s_saida_angulos(22 downto 16);

    SENSOR: interface_hcsr04
        port map (
            clock => clock,
            reset => zera,
            medir => medir,
            echo => echo,
            trigger => trigger,
            medida => s_medida, -- 3 distancias BCD
            pronto => fim_medida,
            db_estado => open -- estado da UC
        );
    
    MUX: mux_8x1_n
        generic map (
            BITS => 7
        )
        port map (
            D0      => s_angulo2_ascii,
            D1      => s_angulo1_ascii,
            D2      => s_angulo0_ascii,
            D3      => "0101100",
            D4      => s_distancia2_ascii,
            D5      => s_distancia1_ascii,
            D6      => s_distancia0_ascii,
            D7      => "0100011",
            SEL     => s_sel,
            MUX_OUT => s_dado_ascii
        );

    ROMANGULO: rom_angulos_8x24
        port map (
            endereco => s_posicao,
            saida    => s_saida_angulos
        ); 

    UPDOWN:  contadorg_updown_m
        generic map (
            M => 8
        )
        port map (
            clock   => clock,
            zera_as => reset,
            zera_s  => '0',
            conta   => conta_posicao,
            Q       => s_posicao,
            inicio  => open,
            fim     => open,
            meio    => open
       );

    TIMER:  contador_m
        generic map (
            --M => 100_000_000, -- 2 seg
            M => 10_000, -- 200us para simulacao
            N => 6
        )
        port map (
            clock => clock,
            zera  => zera,
            conta => conta_timer,
            Q     => open,
            fim   => fim_2seg,
            meio  => open
        );

    SERVO: controle_servo_3
        port map (
            clock => clock,
            reset => '0',
            posicao => s_posicao,
            pwm => pwm,
            db_reset => open,
            db_pwm  => open,
            db_posicao => open
        );
    
    TRANSMISSOR: tx_serial_7O1
        port map (
            clock           => clock,
            reset           => zera,
            partida         => transmitir,
            dados_ascii     => s_dado_ascii,
            saida_serial    => saida_serial,
            pronto          => s_pronto_tx,
            db_clock        => open,
            db_tick         => open,
            db_partida      => open,
            db_saida_serial => open,
            db_estado       => open
        );
	RECEPTOR: rx_serial_7O1
		 port map (
			  clock             => clock,
			  reset             => reset,
			  dado_serial       => entrada_serial,
			  dado_recebido     => s_dado_recebido,
			  paridade_recebida => open,
			  pronto_rx         => pronto_rx,
			  db_estado         => open,
			  db_tick           => open,
			  db_clock          => open
		 );

    CONTA_TRANSMISSAO:  contador_m
        generic map (
            M => 8,
            N => 3
        )
        port map (
            clock => clock,
            zera  => zera,
            conta => s_pronto_tx,
            Q     => s_sel,
            fim   => fim_transmissao,
            meio  => open
        );
	 
	 with s_dado_recebido select
		modo <= "11" when "1000001",
				  "10" when "1001110",
				  "00" when others;
		
    
    --output
    medida <= s_medida;
    posicao <= '0' & s_posicao;

end architecture;