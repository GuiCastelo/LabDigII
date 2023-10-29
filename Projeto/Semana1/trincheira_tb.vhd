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
        cursores          : in  std_logic_vector(3 downto 0);
        atira1            : out std_logic;
        atira2            : out std_logic;
        horizontal1       : out std_logic;
        horizontal2       : out std_logic;
        vertical1         : out std_logic;
        vertical2         : out std_logic;
        db_atira1         : out std_logic;
        db_atira2         : out std_logic;
        db_horizontal1    : out std_logic;
        db_horizontal2    : out std_logic;
        db_vertical1      : out std_logic;
        db_vertical2      : out std_logic;
        db_estado         : out std_logic_vector(6 downto 0)
    );
  end component;
  
  -- Declaração de sinais para conectar o componente a ser testado (DUT)
  --   valores iniciais para fins de simulacao (GHDL ou ModelSim)
  signal clock_in              : std_logic := '0';
  signal reset_in              : std_logic := '0';
  signal ligar_in              : std_logic := '0';
  signal detona_in             : std_logic := '0';
  signal cursores_in           : std_logic_vector (3 downto 0) := "0000";
  signal atira1_out            : std_logic := '0';
  signal atira2_out            : std_logic := '0';
  signal horizontal1_out       : std_logic := '0';
  signal horizontal2_out       : std_logic := '0';
  signal vertical1_out         : std_logic := '0';
  signal vertical2_out         : std_logic := '0';


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
		cursores          => cursores_in,
		atira1            => atira1_out,
		atira2            => atira2_out,
		horizontal1       => horizontal1_out,
		horizontal2       => horizontal2_out,
		vertical1         => vertical1_out,
		vertical2         => vertical2_out,
		db_atira1         => open,
		db_atira2         => open,
		db_horizontal1    => open,
		db_horizontal2    => open,
		db_vertical1      => open,
		db_vertical2      => open,
		db_estado         => open
    );

  -- geracao dos sinais de entrada (estimulos)
  stimulus: process is
  begin
  
    assert false report "Inicio da simulacao" & LF & "... Simulacao ate 800 ms. Aguarde o final da simulacao..." severity note;
    keep_simulating <= '1';
    
    ---- reset ----------------
    reset_in <= '1'; 
    wait for 2*clockPeriod;
    reset_in <= '0';
    wait for 2*clockPeriod;

---- inicio ----------------
	ligar_in <= '1';

    ---- casos de teste
    -- posicao=00
    wait for 200 ms;

    ---- final dos casos de teste  da simulacao
    assert false report "Fim da simulacao" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulação: aguarda indefinidamente
  end process;


end architecture;
