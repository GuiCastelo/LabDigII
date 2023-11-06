library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trincheira is
    port (
        clock             : in  std_logic;
        reset             : in  std_logic;
        ligar             : in  std_logic;
        detona            : in  std_logic;
		posiciona         : in  std_logic;
		echo11						: in  std_logic;
		echo12						: in  std_logic;
		echo13						: in  std_logic;
		echo21						: in  std_logic;
		echo22						: in  std_logic;
		echo32						: in  std_logic;
        cursores          : in  std_logic_vector(3 downto 0);
		atira		      : out std_logic;
        atira1            : out std_logic;
        atira2            : out std_logic;
        horizontal1       : out std_logic;
        horizontal2       : out std_logic;
        vertical1         : out std_logic;
        vertical2         : out std_logic;
		vez				  : out std_logic;
		trigger11				  : out std_logic;
		trigger12				  : out std_logic;
		trigger13				  : out std_logic;
		trigger21				  : out std_logic;
		trigger22				  : out std_logic;
		trigger32				  : out std_logic;
		fim               : out std_logic;
        db_atira1         : out std_logic;
        db_atira2         : out std_logic;
        db_horizontal1    : out std_logic;
        db_horizontal2    : out std_logic;
        db_vertical1      : out std_logic;
        db_vertical2      : out std_logic;
		db_fim_atira	  : out std_logic;
        db_estado         : out std_logic_vector(6 downto 0)
    );
end entity;

architecture structural of trincheira is 
	component trincheira_fd is
		port (
			clock             : in  std_logic;
			reset             : in  std_logic;
			atira             : in  std_logic;
			troca             : in  std_logic;
			detona			  	  : in  std_logic;
			cursores		  	  : in  std_logic_vector(3 downto 0);
			medir							: in  std_logic;
			limpa_sensor			: in  std_logic;
			echo11						: in  std_logic;
			echo12						: in  std_logic;
			echo13						: in  std_logic;
			echo21						: in  std_logic;
			echo22						: in  std_logic;
			echo32						: in  std_logic;
			atira1            : out std_logic;
			atira2            : out std_logic;
			horizontal1       : out std_logic;
			horizontal2       : out std_logic;
			vertical1         : out std_logic;
			vertical2         : out std_logic;
			trigger11				  : out std_logic;
			trigger12				  : out std_logic;
			trigger13				  : out std_logic;
			trigger21				  : out std_logic;
			trigger22				  : out std_logic;
			trigger32				  : out std_logic;
			fim_medidas6      : out std_logic;
			acertou_tudo      : out std_logic;
			valido 						: out std_logic;
			vez					      : out std_logic;
			fim_atira         : out std_logic;
			faz_jogada        : out std_logic;
			db_atira1         : out std_logic;
			db_atira2         : out std_logic;
			db_horizontal1    : out std_logic;
			db_horizontal2    : out std_logic;
			db_vertical1      : out std_logic;
			db_vertical2      : out std_logic
		);
	end component;

	component trincheira_uc is
		port (
			clock             : in  std_logic;
			reset             : in  std_logic;
			ligar             : in  std_logic;
			posiciona         : in  std_logic;
			fim_medidas6      : in  std_logic;
			valido            : in  std_logic;
			acertou_tudo      : in  std_logic;
			faz_jogada        : in  std_logic;
			fim_atira         : in  std_logic;
			medir             : out std_logic;
			atira             : out std_logic;
			troca             : out std_logic;
			limpa_sensor      : out std_logic;
			fim               : out std_logic;
			db_estado         : out std_logic_vector(3 downto 0)
		);
	end component;

    component hexa7seg is
      port (
          hexa : in  std_logic_vector(3 downto 0);
          sseg : out std_logic_vector(6 downto 0)
      );
    end component;

	signal s_posiciona, s_valido, s_fim_medidas6, s_acertou_tudo, s_faz_jogada, s_fim_atira, s_medir, s_atira, s_troca s_limpa_sensor: std_logic;
	signal s_db_estado: std_logic_vector(3 downto 0);
begin

	UC: trincheira_uc
		port map (
			clock             => clock,
			reset             => reset,
			ligar             => ligar,
			posiciona         => s_posiciona,
			fim_medidas6      => s_fim_medidas6,
			valido            => s_valido,
			acertou_tudo      => s_acertou_tudo,
			faz_jogada        => s_faz_jogada,
			fim_atira         => s_fim_atira,
			medir 					  => s_medir,
			atira             => s_atira,
			troca             => s_troca,
			limpa_sensor      => s_limpa_sensor,
			fim               => fim,
			db_estado         => s_db_estado
		);
    
	FD: trincheira_fd 
		port map (
			clock             => clock,
			reset             => reset,
			atira             => s_atira,
			troca             => s_troca,
			detona			      => detona,
			cursores		      => cursores,
			medir							=> s_medir,
			limpa_sensor			=> s_limpa_sensor,
			echo11						=> echo11,
			echo12						=> echo21,
			echo13						=> echo31,
			echo21						=> echo12,
			echo22						=> echo22,
			echo32						=> echo32,
			atira1            => atira1,
			atira2            => atira2,
			horizontal1       => horizontal1,
			horizontal2       => horizontal2,
			vertical1         => vertical1,
			vertical2         => vertical2,
			trigger11		      => trigger11
			trigger12				  => trigger12,
			trigger13				  => trigger13,
			trigger21				  => trigger21,
			trigger22				  => trigger22,
			trigger32				  => trigger32,
			fim_medidas6      => s_fim_medidas6,
			acertou_tudo      => s_acertou_tudo,
			valido 						=> s_valido,
			vez					      => vez,
			fim_atira         => s_fim_atira,
			faz_jogada        => s_faz_jogada,
			db_atira1         => db_atira1,
			db_atira2         => db_atira2,
			db_horizontal1    => db_horizontal1,
			db_horizontal2    => db_horizontal2,
			db_vertical1      => db_vertical1,
			db_vertical2      => db_vertical2
		);

	HEX0: hexa7seg
		port map (
			hexa => s_db_estado,
			sseg => db_estado
		);
	
	db_fim_atira <= s_fim_atira;
	atira <= s_atira;
        
end architecture;