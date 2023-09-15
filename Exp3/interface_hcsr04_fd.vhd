library IEEE;
use IEEE.std_logic_1164.all;

entity interface_hcsr04_fd is
    port (
        clock      : in   std_logic;
        zera       : in   std_logic;
        gera       : in   std_logic;
        registra   : in   std_logic;
        pulso      : in   std_logic;
        distancia  : out  std_logic_vector(11 downto 0);
        trigger    : out  std_logic;
        fim_medida : out  std_logic
    );
end entity;

architecture structural of interface_hcsr04_fd is
    component gerador_pulso is
        generic (
             largura: integer:= 25
        );
        port(
             clock  : in  std_logic;
             reset  : in  std_logic;
             gera   : in  std_logic;
             para   : in  std_logic;
             pulso  : out std_logic;
             pronto : out std_logic
        );
    end component;

    component contador_cm is
        generic (
            constant R : integer;
            constant N : integer
        );
        port (
            clock   : in  std_logic;
            reset   : in  std_logic;
            pulso   : in  std_logic;
            digito0 : out std_logic_vector(3 downto 0);
            digito1 : out std_logic_vector(3 downto 0);
            digito2 : out std_logic_vector(3 downto 0);
            fim     : out std_logic;
            pronto  : out std_logic
        );
    end component;

begin
    PULSE_GENERATOR: gerador_pulso
    generic map (
        largura => 500 -- 10_000 / 20
    )
    port map (
        clock  => clock,
        reset  => reset,
        gera   => gera,
        para   => '0',
        pulso  => trigger,
        pronto => open
    );

    COUNTER_CM: contador_cm
    generic map (
        R => 2941, -- 58_820 / 20
        N => 12
    )
    port map (
        clock   => clock,
        reset   => reset,
        pulso   => pulso,
        digito0 => distancia(3 downto 0),
        digito1 => distancia(7 downto 4),
        digito2 => distancia(11 downto 8),
        fim     => open,
        pronto  => fim_medida
    );

end architecture;
