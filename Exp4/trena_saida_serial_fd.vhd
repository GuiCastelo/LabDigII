library ieee;
use ieee.std_logic_1164.all;

entity trena_saida_serial_fd is 
    port ( 
        clock          : in  std_logic;
        reset          : in  std_logic;
        echo           : in  std_logic
        medir		   : in  std_logic;
        transmitir     : in  std_logic;
        sel_digito     : in  std_logic_vector(1 downto 0);
        fim_medida     : out std_logic;
        fim_transmissao: out std_logic;
        trigger        : out std_logic;
        saida_serial   : out std_logic;
        medida         : out std_logic_vector(11 downto 0)
    );
end entity;

architecture structura of trena_saida_serial_fd is
    component mux_4x1_n is
        generic (
            constant BITS: integer := 4
        );
        port( 
            D3      : in  std_logic_vector (BITS-1 downto 0);
            D2      : in  std_logic_vector (BITS-1 downto 0);
            D1      : in  std_logic_vector (BITS-1 downto 0);
            D0      : in  std_logic_vector (BITS-1 downto 0);
            SEL     : in  std_logic_vector (1 downto 0);
            MUX_OUT : out std_logic_vector (BITS-1 downto 0)
        );
    end component mux_4x1_n;

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
    signal s_dado_ascii: std_logic_vector(6 downto 0);
begin
    SENSOR: interface_hcsr04
        port map (
            clock => clock,
            reset => reset,
            medir => medir,
            echo => echo,
            trigger => trigger,
            medida => s_medida, -- 3 digitos BCD
            pronto => fim_medida,
            db_estado => open -- estado da UC
        );
    
    MUX: mux_4x1_n
        generic map (
            BITS => 7
        )
        port map ( 
            D3      => "0100011",
            D2      => "011" & s_medida(3 downto 0),
            D1      => "011" & s_medida(7 downto 4),
            D0      => "011" & s_medida(11 downto 8),
            SEL     => sel_digito,
            MUX_OUT => s_dado_ascii
        );
    
    TRANSMISSOR: tx_serial_7O1
        port map (
            clock           => clock,
            reset           => reset,
            partida         => transmitir,
            dados_ascii     => s_dado_ascii,
            saida_serial    => saida_serial,
            pronto          => fim_transmissao,
            db_clock        => open,
            db_tick         => open,
            db_partida      => open,
            db_saida_serial => open,
            db_estado       => open
        );
    
    --output
    medida <= s_medida;

end architecture;