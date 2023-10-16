library ieee;
use ieee.std_logic_1164.all;

entity rx_serial_7O1_fd is
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
end entity;

architecture rx_serial_7O1_fd_arch of rx_serial_7O1_fd is
     
    component deslocador_n
    generic (
        constant N : integer
    );
    port (
        clock          : in  std_logic;
        reset          : in  std_logic;
        carrega        : in  std_logic; 
        desloca        : in  std_logic; 
        entrada_serial : in  std_logic; 
        dados          : in  std_logic_vector(N-1 downto 0);
        saida          : out std_logic_vector(N-1 downto 0)
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
    
    signal s_saida: std_logic_vector(9 downto 0);
    signal s_paridade_recebida: std_logic_vector(0 downto 0);

begin

    U1: deslocador_n 
        generic map (
            N => 10
        )  
        port map (
            clock          => clock, 
            reset          => reset, 
            carrega        => carrega, 
            desloca        => desloca, 
            entrada_serial => dado_serial, 
            dados          => "1111111111", 
            saida          => s_saida
        );

    U2: contador_m 
        generic map (
            M => 11, 
            N => 4
        ) 
        port map (
            clock => clock, 
            zera  => zera, 
            conta => conta, 
            Q     => open, 
            fim   => fim, 
            meio  => open
        );

    U3: registrador_n 
        generic map(
            N => 7 
        )
        port map(
            clock  => clock,
            clear  => limpa, 
            enable => registra,
            D      => s_saida(7 downto 1), 
            Q      => dado_saida
        );

    U4: registrador_n 
        generic map(
            N => 1 
        )
        port map(
            clock  => clock,
            clear  => limpa, 
            enable => registra,
            D      => s_saida(8 downto 8), 
            Q      => s_paridade_recebida
        );
    
    paridade_recebida <= s_paridade_recebida(0);
end architecture;

