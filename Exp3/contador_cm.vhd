library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_cm is
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
end entity;

architecture structural of contador_cm is 
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

    component contador_bcd_3digitos is 
    port ( 
        clock   : in  std_logic;
        zera    : in  std_logic;
        conta   : in  std_logic;
        digito0 : out std_logic_vector(3 downto 0);
        digito1 : out std_logic_vector(3 downto 0);
        digito2 : out std_logic_vector(3 downto 0);
        fim     : out std_logic
    );
    end component;

    signal s_conta: std_logic;
begin
    CONT_M: contador_m
    generic map (
        M => R,
        N => N
    )
    port map (
        clock => clock,
        zera  => "not"(pulso),
        conta => pulso,
        Q     => open,
        fim   => s_conta,
        meio  => open
    );

    CONTADOR_BCD: contador_bcd_3digitos
    port map ( 
        clock   => clock,
        zera    => reset,
        conta   => s_conta,
        digito0 => digito0,
        digito1 => digito1,
        digito2 => digito2,
        fim     => fim
    );

    -- Lógica de pronto, quando o pulso voltar para 0
    pronto <= not(pulso);
end architecture;