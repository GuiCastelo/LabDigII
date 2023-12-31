library ieee;
use ieee.std_logic_1164.all;

entity trincheira_tb is
end entity;

architecture tb of trincheira_tb is
  -- Componente a ser testado (Device Under Test -- DUT)
  component trincheira is
    port (
      clock             : in  std_logic;
      reset             : in  std_logic;
      ligar             : in  std_logic;
      detona            : in  std_logic;
      posiciona         : in  std_logic;
      echo11						: in  std_logic;
      echo21						: in  std_logic;
      echo31						: in  std_logic;
      echo12						: in  std_logic;
      echo22						: in  std_logic;
      echo32						: in  std_logic;
      cursores          : in  std_logic_vector(3 downto 0);
      atira		          : out std_logic;
      atira1            : out std_logic;
      atira2            : out std_logic;
      horizontal1       : out std_logic;
      horizontal2       : out std_logic;
      vertical1         : out std_logic;
      vertical2         : out std_logic;
      vez				        : out std_logic;
      trigger11				  : out std_logic;
      trigger21				  : out std_logic;
      trigger31				  : out std_logic;
      trigger12				  : out std_logic;
      trigger22				  : out std_logic;
      trigger32				  : out std_logic;
      fim               : out std_logic;
      db_atira1         : out std_logic;
      db_atira2         : out std_logic;
      db_horizontal1    : out std_logic;
      db_horizontal2    : out std_logic;
      db_vertical1      : out std_logic;
      db_vertical2      : out std_logic;
      db_fim_atira	    : out std_logic;
      db_estado         : out std_logic_vector(6 downto 0)
    );
  end component;
  
  -- Declaração de sinais para conectar o componente a ser testado (DUT)
  --   valores iniciais para fins de simulacao (GHDL ou ModelSim)
  signal clock_in              : std_logic := '0';
  signal reset_in              : std_logic := '0';
  signal ligar_in              : std_logic := '0';
  signal detona_in             : std_logic := '0';
  signal posiciona_in          : std_logic := '0';
  signal echo11_in             : std_logic := '0';
  signal echo21_in             : std_logic := '0';
  signal echo31_in             : std_logic := '0';
  signal echo12_in             : std_logic := '0';
  signal echo22_in             : std_logic := '0';
  signal echo32_in             : std_logic := '0';
  signal cursores_in           : std_logic_vector (3 downto 0) := "1111";
  signal atira_out             : std_logic := '0';
  signal atira1_out            : std_logic := '0';
  signal atira2_out            : std_logic := '0';
  signal horizontal1_out       : std_logic := '0';
  signal horizontal2_out       : std_logic := '0';
  signal vertical1_out         : std_logic := '0';
  signal vertical2_out         : std_logic := '0';
  signal vez_out               : std_logic := '0';
  signal trigger11_out         : std_logic := '0';
  signal trigger21_out         : std_logic := '0';
  signal trigger31_out         : std_logic := '0';
  signal trigger12_out         : std_logic := '0';
  signal trigger22_out         : std_logic := '0';
  signal trigger32_out         : std_logic := '0';
  signal fim_out               : std_logic := '0';
  signal db_fim_atira_out      : std_logic := '0';


  -- Configurações do clock
  signal keep_simulating: std_logic := '0'; -- delimita o tempo de geração do clock
  constant clockPeriod: time := 20 ns;
  
begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período
  -- especificado. Quando keep_simulating=0, clock é interrompido, bem como a 
  -- simulação de eventos
  clock_in <= (not clock_in) and keep_simulating after clockPeriod/2;
 
  -- Conecta DUT (Device Under Test)
  dut: trincheira 

	port map( 
		clock             => clock_in,
		reset             => reset_in,
		ligar             => ligar_in,
		detona            => detona_in,
    posiciona         => posiciona_in,
    echo11						=> echo11_in,
    echo21						=> echo21_in,
    echo31						=> echo31_in,
    echo12						=> echo12_in,
    echo22						=> echo22_in,
    echo32						=> echo32_in,
		cursores          => cursores_in,
    atira             => atira_out,
		atira1            => atira1_out,
		atira2            => atira2_out,
		horizontal1       => horizontal1_out,
		horizontal2       => horizontal2_out,
		vertical1         => vertical1_out,
		vertical2         => vertical2_out,
    vez				        => vez_out,
    trigger11				  => trigger11_out,
    trigger21				  => trigger21_out,
    trigger31				  => trigger31_out,
    trigger12				  => trigger12_out,
    trigger22				  => trigger22_out,
    trigger32				  => trigger32_out,
    fim               => fim_out,
		db_atira1         => open,
		db_atira2         => open,
		db_horizontal1    => open,
		db_horizontal2    => open,
		db_vertical1      => open,
		db_vertical2      => open,
    db_fim_atira      => db_fim_atira_out,
		db_estado         => open
    );

  -- geracao dos sinais de entrada (estimulos)
  stimulus: process is
  begin
  
    assert false report "Inicio da simulacao" severity note;
    keep_simulating <= '1';
    
    ---- reset ----------------
    reset_in <= '1'; 
    wait for 2*clockPeriod;
    reset_in <= '0';
    wait for 2*clockPeriod;

    ---- inicio ----------------
	  ligar_in <= '1';
    wait for 2*clockPeriod;
    ligar_in <= '0';
    wait for 2*clockPeriod;

    ---- casos de teste
    -- posicionamento invalido: alguma das medidas maior que 20cm (1176.4us) de echo
    -- 5 sensores com aproximadamente 10cm (588us) e 1 sensor com 21 cm (1235us)
    posiciona_in <= '1';
    wait for 2*clockPeriod;
    posiciona_in <= '0';
    wait for 2*clockPeriod;
    wait for 50 us;

    echo11_in <= '1';
    echo21_in <= '1';
    echo31_in <= '1';
    echo12_in <= '1';
    echo22_in <= '1';
    echo32_in <= '1';
    wait for 580 us;
    echo11_in <= '0';
    wait for 1 us;
    echo21_in <= '0';
    wait for 1 us;
    echo31_in <= '0';
    wait for 1 us;
    echo12_in <= '0';
    wait for 1 us;
    echo22_in <= '0';
    wait for 651 us;
    echo32_in <= '0';
    wait for 10*clockPeriod;

    -- posicionamento valido: todas as medidas menores que 20cm (1176.4us) de echo
    -- 6 sensores com aproximadamente 10cm (588us)
    posiciona_in <= '1';
    wait for 2*clockPeriod;
    posiciona_in <= '0';
    wait for 2*clockPeriod;
    wait for 50 us;

    echo11_in <= '1';
    echo21_in <= '1';
    echo31_in <= '1';
    echo12_in <= '1';
    echo22_in <= '1';
    echo32_in <= '1';
    wait for 580 us;
    echo11_in <= '0';
    wait for 1 us;
    echo21_in <= '0';
    wait for 1 us;
    echo31_in <= '0';
    wait for 1 us;
    echo12_in <= '0';
    wait for 1 us;
    echo22_in <= '0';
    wait for 1 us;
    echo32_in <= '0';
    wait for 10*clockPeriod;
    
    -- jogador 1 faz jogada e nao derruba todos - derruba terceiro soldado do oponente
    detona_in <= '1';
    wait for 2*clockPeriod;
    detona_in <= '0';
    wait for 1 ms; -- tempo de fazer a ação

    echo11_in <= '1';
    echo21_in <= '1';
    echo31_in <= '1';
    echo12_in <= '1';
    echo22_in <= '1';
    echo32_in <= '1';
    wait for 580 us;
    echo11_in <= '0';
    wait for 1 us;
    echo21_in <= '0';
    wait for 1 us;
    echo31_in <= '0';
    wait for 1 us;
    echo12_in <= '0';
    wait for 1 us;
    echo22_in <= '0';
    wait for 1000 us;
    echo32_in <= '0';
    wait for 10*clockPeriod;

    -- jogador 2 faz jogada e derruba todos
    detona_in <= '1';
    wait for 2*clockPeriod;
    detona_in <= '0';
    wait for 1 ms;

    echo11_in <= '1';
    echo21_in <= '1';
    echo31_in <= '1';
    echo12_in <= '1';
    echo22_in <= '1';
    echo32_in <= '1';
    wait for 580 us;
    echo12_in <= '0';
    wait for 1 us;
    echo22_in <= '0';
    wait for 1000 us;
    echo11_in <= '0';
    wait for 1 us;
    echo21_in <= '0';
    wait for 1 us;
    echo31_in <= '0';
    wait for 1 us;
    echo32_in <= '0';
    wait for 10*clockPeriod;

    ---- final dos casos de teste  da simulacao
    assert false report "Fim da simulacao" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulação: aguarda indefinidamente
  end process;


end architecture;
