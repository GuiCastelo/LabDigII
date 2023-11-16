library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trincheira_uc is
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
        pronto_tx         : in  std_logic;
        limpa_jogada      : out std_logic;
        medir             : out std_logic;
        atira             : out std_logic;
        troca             : out std_logic;
        limpa_sensor      : out std_logic;
        fim               : out std_logic;
        db_estado         : out std_logic_vector(3 downto 0)
    );
end entity;

architecture trincheira_uc_arch of trincheira_uc is

    type tipo_estado is (inicial, medeDebug, esperaDebug, esperaPosiciona, medePosiciona, 
    aguardaFimPosiciona, validaPosiciona, esperaAcao, fazJogada, medeJogada, 
    aguardaJogada, checaFim, trocaVez, final);
    signal Eatual: tipo_estado;  -- estado atual
    signal Eprox:  tipo_estado;  -- proximo estado

begin

  -- memoria de estado
  process (reset, clock)
  begin
      if reset = '1' then
          Eatual <= inicial;
      elsif clock'event and clock = '1' then
          Eatual <= Eprox; 
      end if;
  end process;

  -- logica de proximo estado
  process (ligar, debug, fim_atira, faz_jogada, posiciona, valido, fim_medidas6, Eatual) 
  begin

    case Eatual is

        when inicial =>     if ligar='1' then Eprox <= esperaPosiciona;
						    elsif debug='1' then Eprox <= medeDebug;
                            else              Eprox <= inicial;
                            end if;
									 
		when medeDebug => Eprox <= esperaDebug;

        when esperaDebug => if fim_medidas6='1' then Eprox <= inicial;
                            else Eprox <= esperaDebug;
                            end if;

        when esperaPosiciona =>     if posiciona='1' then Eprox <= medePosiciona;
        else              Eprox <= esperaPosiciona;
        end if;

        when medePosiciona =>     Eprox <= aguardaFimPosiciona;


        when aguardaFimPosiciona =>     if fim_medidas6='1' then Eprox <= validaPosiciona;
        else              Eprox <= aguardaFimPosiciona;
        end if;

        when validaPosiciona =>     if valido='0' then Eprox <= esperaPosiciona;
        else              Eprox <= esperaAcao;
        end if;

        when esperaAcao =>  if faz_jogada='1' then Eprox <= fazJogada;
                            else              Eprox <= esperaAcao;
                            end if;

        when fazJogada =>   if fim_atira='1' then Eprox <= medeJogada;
                            else             Eprox <= fazJogada;
                            end if;

        when medeJogada =>   Eprox <= aguardaJogada;

        when aguardaJogada =>   if fim_medidas6='1' then Eprox <= checaFim;
        else             Eprox <= aguardaJogada;
        end if;

        when checaFim =>   if acertou_tudo='1' then Eprox <= final;
        else             Eprox <= trocaVez;
        end if;

        when trocaVez =>    Eprox <= esperaAcao;

        when final =>     if ligar='1' then Eprox <= inicial;
        else              Eprox <= final;
        end if;

        when others =>      Eprox <= inicial;

    end case;

  end process;

  -- logica de saida (Moore)
  with Eatual select
		atira <= '1' when fazJogada, '0' when others;
		
  with Eatual select
	  troca <= '1' when trocaVez, '0' when others;

  with Eatual select
	  medir <=  '1' when medeJogada, 
                '1' when medePosiciona,
                '1' when medeDebug,
                '0' when others;

  with Eatual select
      limpa_sensor <=  '1' when esperaAcao, 
                       '1' when esperaPosiciona,
                       '1' when inicial,
                       '0' when others;

  with Eatual select
      limpa_jogada <=  '1' when esperaAcao,
                       '0' when others;

  with Eatual select
	  fim <= '1' when final, '0' when others;

  with Eatual select
       db_estado <= "0000" when inicial,
                    "0001" when esperaAcao, 
                    "0010" when fazJogada,
                    "0011" when trocaVez,
                    "0100" when esperaPosiciona,
                    "0101" when medePosiciona,
                    "0110" when aguardaFimPosiciona,
                    "0111" when aguardaJogada,
                    "1111" when final,
                     "1110" when others;   -- Erro

end architecture;