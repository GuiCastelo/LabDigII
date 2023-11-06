library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trincheira_uc is
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
end entity;

architecture trincheira_uc_arch of trincheira_uc is

    type tipo_estado is (inicial, esperaAcao, fazJogada, trocaVez);
    signal Eatual: tipo_estado;  -- estado atual
    signal Eprox:  tipo_estado;  -- proximo estado

begin

  -- memoria de estado
  process (reset, clock, ligar)
  begin
      if reset = '1' or ligar = '0' then
          Eatual <= inicial;
      elsif clock'event and clock = '1' then
          Eatual <= Eprox; 
      end if;
  end process;

  -- logica de proximo estado
  process (ligar, fim_atira, faz_jogada, Eatual) 
  begin

    case Eatual is

        when inicial =>     if ligar='1' then Eprox <= esperaAcao;
                            else              Eprox <= inicial;
                            end if;
        
        when esperaAcao =>  if faz_jogada='1' then Eprox <= fazJogada;
                            else              Eprox <= esperaAcao;
                            end if;

        when fazJogada =>   if fim_atira='1' then Eprox <= trocaVez;
                            else             Eprox <= fazJogada;
                            end if;

        when trocaVez =>    Eprox <= esperaAcao;

        when others =>      Eprox <= inicial;

    end case;

  end process;

  -- logica de saida (Moore)
  with Eatual select
		atira <= '1' when fazJogada, '0' when others;
		
  with Eatual select
	  troca <= '1' when trocaVez, '0' when others;

  with Eatual select
       db_estado <= "0000" when inicial,
                    "0001" when esperaAcao, 
                    "0010" when fazJogada,
					"0011" when trocaVez,
                    "1110" when others;   -- Erro

end architecture;