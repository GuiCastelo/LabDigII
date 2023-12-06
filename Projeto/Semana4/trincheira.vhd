library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trincheira is
    port (
        clock              : in  std_logic;
        reset              : in  std_logic;
        ligar              : in  std_logic;
		 	  debug              : in  std_logic;
				entrada_serial     : in  std_logic;
				echo11			  		 : in  std_logic;
				echo21			  		 : in  std_logic;
				echo31			  		 : in  std_logic;
				echo12			  		 : in  std_logic;
				echo22			 		   : in  std_logic;
				echo32			  		 : in  std_logic;
				atira		      		 : out std_logic;
				saida_serial  	   : out std_logic;
        atira1             : out std_logic;
        atira2             : out std_logic;
        horizontal1        : out std_logic;
        horizontal2        : out std_logic;
        vertical1          : out std_logic;
        vertical2          : out std_logic;
				vez				  			 : out std_logic;
				trigger11		  		 : out std_logic;
				trigger21		  		 : out std_logic;
				trigger31		  		 : out std_logic;
				trigger12		  		 : out std_logic;
				trigger22		  		 : out std_logic;
				trigger32		  		 : out std_logic;
				fim                : out std_logic;
				db_fim_atira	  	 : out std_logic;
        db_estado          : out std_logic_vector(6 downto 0);
				db_conta_medida    : out std_logic_vector(6 downto 0);
				db_dado1   				 : out std_logic_vector(6 downto 0);
				db_dado2   				 : out std_logic_vector(6 downto 0);
				db_maior11		  	 : out std_logic;
				db_maior21		  	 : out std_logic;
				db_maior31		  	 : out std_logic;
				db_maior12		  	 : out std_logic;
				db_maior22		  	 : out std_logic;
				db_maior32		  	 : out std_logic;
				db_fim_transmissao : out std_logic
    );
end entity;

architecture structural of trincheira is 
	component trincheira_fd is
    port (
			clock             : in  std_logic;
			reset             : in  std_logic;
			atira             : in  std_logic;
			troca             : in  std_logic;
			acao							: in  std_logic;
			medir							: in  std_logic;
			transmite         : in  std_logic;
			limpa_sensor			: in  std_logic;
			limpa_erro_sensor : in  std_logic;
			conta_erro_sensor : in  std_logic;
			limpa_jogada      : in  std_logic;
			limpa_transmissao : in  std_logic;
			limpa_timeout     : in  std_logic;
			conta_timeout     : in  std_logic;
			conta_fim_timeout : in  std_logic;
			limpa_fim_timeout : in  std_logic;
			sel_timeout       : in  std_logic;
			echo11						: in  std_logic;
			echo21						: in  std_logic;
			echo31						: in  std_logic;
			echo12						: in  std_logic;
			echo22						: in  std_logic;
			echo32						: in  std_logic;
			entrada_serial    : in  std_logic;
			saida_serial   		: out std_logic;
			atira1            : out std_logic;
			atira2            : out std_logic;
			horizontal1       : out std_logic;
			horizontal2       : out std_logic;
			vertical1         : out std_logic;
			vertical2         : out std_logic;
			trigger11				  : out std_logic;
			trigger21				  : out std_logic;
			trigger31				  : out std_logic;
			trigger12				  : out std_logic;
			trigger22				  : out std_logic;
			trigger32				  : out std_logic;
			fim_medidas6      : out std_logic;
			fim_transmissao   : out std_logic;
			timeout           : out std_logic;
			fim_timeout       : out std_logic;
			erro_sensor       : out std_logic;
			pronto_tx         : out std_logic;
			acertou_tudo      : out std_logic;
			posiciona         : out std_logic;
			valido 						: out std_logic;
			vez					      : out std_logic;
			fim_atira         : out std_logic;
			faz_jogada        : out std_logic;
			db_conta_medida   : out std_logic_vector(3 downto 0);
			db_dado1   : out std_logic_vector(3 downto 0);
			db_dado2   : out std_logic_vector(3 downto 0);
			db_maior11		  : out std_logic;
			db_maior21		  : out std_logic;
			db_maior31		  : out std_logic;
			db_maior12		  : out std_logic;
			db_maior22		  : out std_logic;
			db_maior32		  : out std_logic
		);
	end component;

	component trincheira_uc is
		port (
			clock             : in  std_logic;
			reset             : in  std_logic;
			ligar             : in  std_logic;
	debug             : in  std_logic;
			posiciona         : in  std_logic;
			fim_medidas6      : in  std_logic;
			valido            : in  std_logic;
			acertou_tudo      : in  std_logic;
			faz_jogada        : in  std_logic;
			fim_atira         : in  std_logic;
			fim_transmissao   : in  std_logic;
			pronto_tx         : in  std_logic;
			timeout           : in  std_logic;
			fim_timeout       : in  std_logic;
			erro_sensor       : in  std_logic;
			transmite         : out std_logic;
			limpa_timeout     : out std_logic;
			conta_timeout     : out std_logic;
			conta_fim_timeout : out std_logic;
			limpa_fim_timeout : out std_logic;
			sel_timeout       : out std_logic;
			limpa_jogada      : out std_logic;
			limpa_transmissao : out std_logic;
			acao              : out std_logic;
			medir             : out std_logic;
			atira             : out std_logic;
			troca             : out std_logic;
			limpa_sensor      : out std_logic;
			limpa_erro_sensor : out std_logic;
			conta_erro_sensor : out std_logic;
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

	signal s_valido, s_acao, s_limpa_jogada, s_limpa_transmissao, s_pronto_tx, s_posiciona, s_transmite, s_fim_transmissao: std_logic; 
	signal s_fim_medidas6, s_acertou_tudo, s_faz_jogada, s_fim_atira, s_medir, s_atira, s_troca, s_limpa_sensor: std_logic;
	signal s_erro_sensor, s_conta_erro_sensor, s_limpa_erro_sensor: std_logic;
	signal s_limpa_timeout, s_limpa_fim_timeout, s_conta_timeout, s_conta_fim_timeout, s_sel_timeout, s_timeout, s_fim_timeout: std_logic;
	signal s_db_estado, s_db_conta_medida, s_db_dado1, s_db_dado2: std_logic_vector(3 downto 0);
begin

	UC: trincheira_uc
		port map (
			clock             => clock,
			reset             => reset,
			ligar             => ligar,
			debug             => debug,
			posiciona         => s_posiciona,
			fim_medidas6      => s_fim_medidas6,
			valido            => s_valido,
			acertou_tudo      => s_acertou_tudo,
			faz_jogada        => s_faz_jogada,
			fim_atira         => s_fim_atira,
			fim_transmissao   => s_fim_transmissao,
			pronto_tx         => s_pronto_tx,
			timeout           => s_timeout,
			fim_timeout       => s_fim_timeout,
			erro_sensor       => s_erro_sensor,
			transmite         => s_transmite,
			limpa_timeout     => s_limpa_timeout,
			conta_timeout     => s_conta_timeout,
			conta_fim_timeout => s_conta_fim_timeout,
			limpa_fim_timeout => s_limpa_fim_timeout,
			sel_timeout       => s_sel_timeout,
			limpa_jogada      => s_limpa_jogada,
			limpa_transmissao => s_limpa_transmissao,
			acao              => s_acao,
			medir 			      => s_medir,
			atira             => s_atira,
			troca             => s_troca,
			limpa_sensor      => s_limpa_sensor,
			limpa_erro_sensor => s_limpa_erro_sensor,
			conta_erro_sensor => s_conta_erro_sensor,
			fim               => fim,
			db_estado         => s_db_estado
		);
    
	FD: trincheira_fd 
		port map (
			clock             => clock,
			reset             => reset,
			atira             => s_atira,
			troca             => s_troca,
			acao              => s_acao,
			medir			        => s_medir,
			transmite         => s_transmite,
			limpa_sensor	    => s_limpa_sensor,
			limpa_erro_sensor => s_limpa_erro_sensor,
			conta_erro_sensor => s_conta_erro_sensor,
			limpa_jogada      => s_limpa_jogada,
			limpa_transmissao => s_limpa_transmissao,
			limpa_timeout     => s_limpa_timeout,
			conta_timeout     => s_conta_timeout,
			conta_fim_timeout => s_conta_fim_timeout,
			limpa_fim_timeout => s_limpa_fim_timeout,
			sel_timeout       => s_sel_timeout,
			echo11			  => echo11,
			echo21			  => echo21,
			echo31			  => echo31,
			echo12			  => echo12,
			echo22			  => echo22,
			echo32			  => echo32,
			entrada_serial    => entrada_serial,
			saida_serial      => saida_serial,
			atira1            => atira1,
			atira2            => atira2,
			horizontal1       => horizontal1,
			horizontal2       => horizontal2,
			vertical1         => vertical1,
			vertical2         => vertical2,
			trigger11		  => trigger11,
			trigger21		  => trigger21,
			trigger31		  => trigger31,
			trigger12		  => trigger12,
			trigger22		  => trigger22,
			trigger32		  => trigger32,
			fim_medidas6      => s_fim_medidas6,
			fim_transmissao   => s_fim_transmissao,
			timeout           => s_timeout,
			fim_timeout       => s_fim_timeout,
			erro_sensor       => s_erro_sensor,
			pronto_tx					=> s_pronto_tx,
			acertou_tudo      => s_acertou_tudo,
			posiciona         => s_posiciona,
			valido 			      => s_valido,
			vez				        => vez,
			fim_atira         => s_fim_atira,
			faz_jogada        => s_faz_jogada,
			db_conta_medida   => s_db_conta_medida,
			db_dado1          => s_db_dado1,
			db_dado2          => s_db_dado2,
			db_maior11		   => db_maior11,
			db_maior21		   => db_maior21,
			db_maior31		   => db_maior31,
			db_maior12		   => db_maior12,
			db_maior22		   => db_maior22,
			db_maior32		   => db_maior32
		);

	HEX0: hexa7seg
		port map (
			hexa => s_db_estado,
			sseg => db_estado
		);

	HEX1: hexa7seg
		port map (
			hexa => s_db_conta_medida,
			sseg => db_conta_medida
		);
		
	HEX2: hexa7seg
		port map (
			hexa => s_db_dado1,
			sseg => db_dado1
		);

	HEX3: hexa7seg
		port map (
			hexa => s_db_dado2,
			sseg => db_dado2
		);
	
	db_fim_atira <= s_fim_atira;
	db_fim_transmissao <= s_fim_transmissao;
	atira <= s_atira;
        
end architecture;