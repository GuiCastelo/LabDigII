library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_serial_7O1 is
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
end entity;

architecture rx_serial_7O1_arch of rx_serial_7O1 is
     
    component rx_serial_uc 
    port ( 
        clock         : in  std_logic;
        reset         : in  std_logic;
        dado_serial   : in  std_logic;
        tick          : in  std_logic;
        fim           : in  std_logic;
        zera          : out std_logic;
        conta         : out std_logic;
        carrega       : out std_logic;
        desloca       : out std_logic;
        limpa         : out std_logic;
        registra      : out std_logic;
        pronto_rx     : out std_logic;
        db_estado     : out std_logic_vector(3 downto 0)
    );
    end component;

    component rx_serial_7O1_fd
    port (
        clock             : in  std_logic;
        reset             : in  std_logic;
        zera              : in  std_logic;
        conta             : in  std_logic;
        carrega           : in  std_logic;
        desloca           : in  std_logic;
        limpa             : in  std_logic;
        registra          : in  std_logic;
        dado_serial      : in  std_logic;
        dado_saida        : out std_logic_vector(6 downto 0);
        paridade_recebida : out std_logic;
        fim               : out std_logic
    );
    end component;
    
    component contador_m
    generic (
        constant M : integer; 
        constant N : integer 
    );
    port (
        clock : in  std_logic;
        zera  : in  std_logic;
        conta : in  std_logic;
        Q     : out std_logic_vector(N-1 downto 0);
        fim   : out std_logic;
        meio  : out std_logic
    );
    end component;
    
    component edge_detector 
    port (  
        clock     : in  std_logic;
        signal_in : in  std_logic;
        output    : out std_logic
    );
    end component;

    component hexa7seg
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;  

    signal s_reset: std_logic;
    signal s_zera, s_conta, s_carrega, s_desloca, s_tick, s_fim, s_limpa, s_registra: std_logic;
    signal s_saida_serial : std_logic;
    signal s_estado, s_dado_recebido1 : std_logic_vector(3 downto 0);
    signal s_dado_saida: std_logic_vector(6 downto 0);

begin

    -- sinais reset e partida mapeados na GPIO (ativos em alto)
    s_reset   <= reset;


    -- unidade de controle
    U1_UC: rx_serial_uc 
           port map (
               clock       => clock, 
               reset       => s_reset, 
               dado_serial => dado_serial, 
               tick        => s_tick, 
               fim         => s_fim,
               zera        => s_zera, 
               conta       => s_conta, 
               carrega     => s_carrega, 
               desloca     => s_desloca,
               limpa       => s_limpa,
               registra    => s_registra,
               pronto_rx   => pronto_rx,
               db_estado   => s_estado
           );

    -- fluxo de dados
    U2_FD: rx_serial_7O1_fd 
           port map (
               clock             => clock, 
               reset             => s_reset, 
               zera              => s_zera, 
               conta             => s_conta, 
               carrega           => s_carrega, 
               desloca           => s_desloca,
               limpa             => s_limpa,
               registra          => s_registra,
               dado_serial       => dado_serial, 
               dado_saida        => dado_recebido, 
               paridade_recebida => paridade_recebida,
               fim               => s_fim
           );


    -- gerador de tick
    -- fator de divisao para 9600 bauds (5208=50M/9600)
    -- fator de divisao para 115.200 bauds (434=50M/115200)
    U3_TICK: contador_m 
             generic map (
                 M => 434, -- 115200 bauds
                 N => 13
             ) 
             port map (
                 clock => clock, 
                 zera  => s_zera, 
                 conta => '1', 
                 Q     => open, 
                 fim   => open, 
                 meio  => s_tick
             );

    -- debug
    db_clock   <= clock;
    db_tick    <= s_tick;

    HEX5: hexa7seg
          port map (
              hexa => s_estado,
              sseg => db_estado
          );

end architecture;
