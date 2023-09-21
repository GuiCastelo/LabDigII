library ieee;
use ieee.std_logic_1164.all;

entity trena_saida_serial is
    port (
        clock          : in  std_logic;
        reset          : in  std_logic;
        mensurar       : in  std_logic;
        echo           : in  std_logic;
        trigger        : out std_logic;
        saida_serial   : out std_logic;
        medida0        : out std_logic_vector (6 downto 0);
        medida1        : out std_logic_vector (6 downto 0);
        medida2        : out std_logic_vector (6 downto 0);
        pronto         : out std_logic;
        db_echo        : out std_logic;
        db_trigger     : out std_logic;
        db_saida_serial: out std_logic;
        db_estado      : out std_logic_vector (6 downto 0)
    );
end entity;

architecture structural of trena_saida_serial is
    component trena_saida_serial_fd is 
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
    end component;

    component trena_saida_serial_uc is 
        port ( 
            clock          : in  std_logic;
            reset          : in  std_logic;
            mensurar       : in  std_logic;
            fim_medida     : in  std_logic;
            fim_transmissao: in  std_logic;
            medir		   : out std_logic;
            transmitir     : out std_logic;
            sel_digito     : out std_logic_vector(1 downto 0);
            pronto         : out std_logic;
            db_estado      : out std_logic_vector(3 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component hexa7seg;

    signal s_medir, s_transmitir, s_fim_medida, s_fim_transmissao: std_logic;
    signal s_echo, s_trigger, s_saida_serial: std_logic;
    signal s_sel_digito: std_logic_vector(1 downto 0);
    signal s_estado: std_logic_vector(3 downto 0);
    signal s_medida: std_logic_vector(11 downto 0);
begin
    FD: trena_saida_serial_fd
        port map ( 
            clock           => clock,
            reset           => reset,
            echo            => s_echo,
            medir		    => s_medir,
            transmitir      => s_transmitir,
            sel_digito      => s_sel_digito,
            fim_medida      => s_fim_medida,
            fim_transmissao => s_fim_transmissao,
            trigger         => s_trigger,
            saida_serial    => s_saida_serial
    );

    UC: trena_saida_serial_uc
        port map ( 
            clock           => clock,
            reset           => reset,
            mensurar        => mensurar,
            fim_medida      => s_fim_medida,
            fim_transmissao => s_fim_transmissao,
            medir			=> s_medir,
            transmitir      => s_transmitir,
            sel_digito      => s_sel_digito,
            pronto          => pronto,
            db_estado       => s_estado
    );

    HEX0: hexa7seg
        port map (
            hexa => s_medida(3 downto 0),
            sseg => medida0
        );

    HEX1: hexa7seg
        port map (
            hexa => s_medida(7 downto 4),
            sseg => medida1
    );

    HEX2: hexa7seg
        port map (
            hexa => s_medida(11 downto 8),
            sseg => medida2
    );

    HEX5: hexa7seg
        port map (
            hexa => s_estado,
            sseg => db_estado
        );

    --output
    echo <= s_echo;
    trigger <= s_trigger;
    saida_serial <= s_saida_serial;

    --debug
    db_echo <= s_echo;
    db_trigger <= s_trigger;
    db_saida_serial <= s_saida_serial;

end architecture;