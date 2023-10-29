library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trincheira is
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
end entity;

architecture structural of trincheira is 
	component trincheira_fd is
		port (
			clock             : in  std_logic;
			reset             : in  std_logic;
			atira             : in  std_logic;
			troca             : in  std_logic;
			detona			  : in  std_logic;
			cursores		  : in  std_logic_vector(3 downto 0);
			atira1            : out std_logic;
			atira2            : out std_logic;
			horizontal1       : out std_logic;
			horizontal2       : out std_logic;
			vertical1         : out std_logic;
			vertical2         : out std_logic;
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
			faz_jogada        : in  std_logic;
			fim_atira         : in  std_logic;
			atira             : out std_logic;
			troca             : out std_logic;
			db_estado         : out std_logic_vector(3 downto 0)
		);
	end component;

    component hexa7seg is
      port (
          hexa : in  std_logic_vector(3 downto 0);
          sseg : out std_logic_vector(6 downto 0)
      );
    end component;

	signal s_faz_jogada, s_fim_atira, s_atira, s_troca: std_logic;
	signal s_db_estado: std_logic_vector(3 downto 0);
begin

	UC: trincheira_uc
		port map (
			clock             => clock,
			reset             => reset,
			ligar             => ligar,
			faz_jogada        => s_faz_jogada,
			fim_atira         => s_fim_atira,
			atira             => s_atira,
			troca             => s_troca,
			db_estado         => s_db_estado
		);
    
	FD: trincheira_fd 
		port map (
			clock             => clock,
			reset             => reset,
			atira             => s_atira,
			troca             => s_troca,
			detona			  => detona,
			cursores		  => cursores,
			atira1            => atira1,
			atira2            => atira2,
			horizontal1       => horizontal1,
			horizontal2       => horizontal2,
			vertical1         => vertical1,
			vertical2         => vertical2,
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
        
end architecture;