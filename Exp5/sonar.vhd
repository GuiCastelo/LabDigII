library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sonar is
    port (
        clock             : in  std_logic;
        reset             : in  std_logic;
        ligar             : in  std_logic;
        echo              : in  std_logic;
        trigger           : out std_logic;
        pwm               : out std_logic;
        saida_serial      : out std_logic;
        fim_posicao       : out std_logic;
        hexa0             : out std_logic_vector(6 downto 0);
        hexa1             : out std_logic_vector(6 downto 0);
        hexa2             : out std_logic_vector(6 downto 0);
        hexa3             : out std_logic_vector(6 downto 0);
        hexa4             : out std_logic_vector(6 downto 0)
    );
end entity;

architecture sonar_arch of sonar is
    component sonar_fd is 
        port ( 
            clock             : in  std_logic;
            reset             : in  std_logic;
            medir             : in  std_logic;
            echo              : in  std_logic;
            conta             : in  std_logic;
            zera              : in  std_logic;
            transmitir        : in  std_logic;
            sel_digito        : in  std_logic_vector(2 downto 0); 
            trigger           : out std_logic;
            pwm               : out std_logic;
            medida            : out std_logic_vector(11 downto 0);
            posicao           : out std_logic_vector(3 downto 0);
            saida_serial      : out std_logic;
            fim_medida        : out std_logic;
            fim_transmissao   : out std_logic;
            fim_2seg          : out std_logic
        );
    end component;

    component sonar_uc is 
        port ( 
            clock             : in  std_logic;
            reset             : in  std_logic;
            ligar             : in  std_logic;
            fim_medida        : in  std_logic;
            fim_2seg          : in  std_logic;
            fim_transmissao   : in  std_logic;
            medir             : out std_logic;
            conta             : out std_logic;
            zera              : out std_logic;
            transmitir        : out std_logic;
            sel_digito        : out std_logic_vector(2 downto 0);
            fim_posicao       : out std_logic;
            db_estado         : out std_logic_vector(3 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component hexa7seg;

    signal s_medir, s_conta, s_zera, s_transmitir, s_fim_medida, s_fim_2seg, s_fim_transmissao: std_logic;
    signal s_posicao, s_db_estado: std_logic_vector(3 downto 0);
    signal s_sel_digito: std_logic_vector(2 downto 0);
    signal s_medida: std_logic_vector(11 downto 0);

begin

        FD: sonar_fd 
            port map (
                clock           => clock,
                reset           => reset,
                medir           => s_medir,
                echo            => echo,
                conta           => s_conta,
                zera            => s_zera,
                transmitir      => s_transmitir,
                sel_digito      => s_sel_digito,
                trigger         => trigger,
                pwm             => pwm,
                medida          => s_medida,
                posicao         => s_posicao,
                saida_serial    => saida_serial,
                fim_medida      => s_fim_medida,
                fim_transmissao => s_fim_transmissao,
                fim_2seg        => s_fim_2seg
            );


        UC: sonar_uc
            port map (
                clock             => clock,
                reset             => reset,
                ligar             => ligar,
                fim_medida        => s_fim_medida,
                fim_2seg          => s_fim_2seg,
                fim_transmissao   => s_fim_transmissao,
                medir             => s_medir,
                conta             => s_conta,
                zera              => s_zera,
                transmitir        => s_transmitir,
                sel_digito        => s_sel_digito,
                fim_posicao       => fim_posicao,
                db_estado         => s_db_estado
            );


        HEX0: hexa7seg
            port map (
                hexa => s_medida(3 downto 0),
                sseg => hexa0
            );

        HEX1: hexa7seg
            port map (
                hexa => s_medida(7 downto 4),
                sseg => hexa1
            );

        HEX2: hexa7seg
            port map (
                hexa => s_medida(11 downto 8),
                sseg => hexa2
            );

        HEX3: hexa7seg
            port map (
                hexa => s_posicao,
                sseg => hexa3
            );

        HEX4: hexa7seg
            port map (
                hexa => s_db_estado,
                sseg => hexa4
            );


end architecture;