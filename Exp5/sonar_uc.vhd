library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sonar_uc is
    port (
        clock             : in  std_logic;
        reset             : in  std_logic;
        ligar             : in  std_logic;
        fim_medida        : in  std_logic;
        fim_2seg          : in  std_logic;
        fim_transmissao   : in  std_logic;
        fim_transmissoes  : in  std_logic;
        medir             : out std_logic;
        conta_posicao     : out std_logic;
        conta_timer       : out std_logic;
        conta_transmissao : out std_logic;
        zera              : out std_logic;
        transmitir        : out std_logic;
        sel_digito        : out std_logic_vector(2 downto 0);
        fim_posicao       : out std_logic;
        db_estado         : out std_logic_vector(3 downto 0)
    );
end entity;

architecture sonar_uc_arch of sonar_uc is

    type tipo_estado is (inicial, espera_2seg, faz_medida, aguarda_medida, 
                        transmite, espera_transmissao, final);
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
  process (ligar, fim_medida, fim_2seg, Eatual) 
  begin

    case Eatual is

        when inicial =>     if ligar='1' then Eprox <= espera_2seg;
                            else              Eprox <= inicial;
                            end if;
        
        when espera_2seg => if fim_2seg='1' then Eprox <= faz_medida;
                            else              Eprox <= espera_2seg;
                            end if;

        when faz_medida =>   Eprox <= aguarda_medida;

        when aguarda_medida => if fim_medida='1' then Eprox <= transmite;
                               else                   Eprox <= aguarda_medida;
                               end if;

        when transmite => Eprox <= espera_transmissao;

        when espera_transmissao => if fim_transmissao='1' and fim_transmissoes='0' then Eprox <= transmite;
                                      elsif fim_transmissao='1' and fim_transmissoes='1' then Eprox <= final;
                                      else                         Eprox <= espera_transmissao;
                                      end if;

        when final =>        Eprox <= inicial;

        when others =>       Eprox <= inicial;

    end case;

  end process;

  -- logica de saida (Moore)
  with Eatual select
    fim_posicao <= '1' when final, '0' when others;
		
	with Eatual select
		medir <= '1' when faz_medida, '0' when others;

	with Eatual select
		transmitir <=   '1' when transmite, 
						'0' when others;

    with Eatual select
    conta_posicao <=    '1' when final, 
                       '0' when others;
    
    with Eatual select
    conta_timer <=    '1' when espera_2seg, 
                     '0' when others;

    with Eatual select
    conta_transmissao <=    '1' when espera_transmissoes, 
                            '0' when others;

    with Eatual select
    zera <=     '1' when inicial,  
                '0' when others;

	with Eatual select
		sel_digito <=   "000" when transmite_angulo_centena,
                        "000" when espera_angulo_centena,
						"001" when transmite_angulo_dezena,
                        "001" when espera_angulo_dezena,
						"010" when transmite_angulo_unidade,
                        "010" when espera_angulo_unidade,
						"011" when transmite_angulo_fim,
                        "011" when espera_angulo_fim,
                        "100" when transmite_distancia_centena,
                        "100" when espera_distancia_centena,
						"101" when transmite_distancia_dezena,
                        "101" when espera_distancia_dezena,
						"110" when transmite_distancia_unidade,
                        "110" when espera_distancia_unidade,
						"111" when transmite_distancia_fim,
                        "111" when espera_distancia_fim,
						"000" when others;

  with Eatual select
       db_estado <= "0000" when inicial,
                    "0001" when faz_medida, 
                    "0010" when aguarda_medida, 
                    "0011" when transmite,
                    "0100" when espera_transmissao, ,
                    "1111" when final,    -- Final
                    "1110" when others;   -- Erro

end architecture;