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
        medir             : out std_logic;
        conta             : out std_logic;
        zera              : out std_logic;
        transmitir        : out std_logic;
        sel_digito        : out std_logic_vector(2 downto 0);
        fim_posicao       : out std_logic;
        db_estado         : out std_logic_vector(3 downto 0)
    );
end entity;

architecture sonar_uc_arch of sonar_uc is

    type tipo_estado is (inicial, faz_medida, aguarda_medida, transmite_angulo_centena, 
                        espera_angulo_centena, transmite_angulo_dezena, espera_angulo_dezena, transmite_angulo_unidade, espera_angulo_unidade, 
                        transmite_angulo_fim, espera_angulo_fim, transmite_distancia_centena, 
                        espera_distancia_centena, transmite_distancia_dezena, espera_distancia_dezena, transmite_distancia_unidade, espera_distancia_unidade, 
                        transmite_distancia_fim, espera_distancia_fim, final);
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

        when inicial =>     if ligar='1' then Eprox <= faz_medida;
                            else              Eprox <= inicial;
                            end if;

        when faz_medida =>   Eprox <= aguarda_medida;

        when aguarda_medida => if fim_medida='1' then Eprox <= transmite_angulo_centena;
                               else                   Eprox <= aguarda_medida;
                               end if;

        when transmite_angulo_centena => Eprox <= espera_angulo_centena;

        when espera_angulo_centena => if fim_transmissao='1' then Eprox <= transmite_angulo_dezena;
                                      else                        Eprox <= espera_angulo_centena;
                                      end if;
      
        when transmite_angulo_dezena => Eprox <= espera_angulo_dezena;

        when espera_angulo_dezena => if fim_transmissao='1' then Eprox <= transmite_angulo_unidade;
                                     else                        Eprox <= espera_angulo_dezena;
                                     end if;

        when transmite_angulo_unidade => Eprox <= espera_angulo_unidade;

        when espera_angulo_unidade => if fim_transmissao='1' then Eprox <= transmite_angulo_fim;
                                      else                        Eprox <= espera_angulo_unidade;
                                      end if;

        when transmite_angulo_fim => Eprox <= espera_angulo_fim;

        when espera_angulo_fim => if fim_transmissao='1' then Eprox <= transmite_distancia_centena;
                           else                               Eprox <= espera_angulo_fim;
                           end if;

        when transmite_distancia_centena => Eprox <= espera_distancia_centena;

        when espera_distancia_centena => if fim_transmissao='1' then Eprox <= transmite_distancia_dezena;
                                        else                        Eprox <= espera_distancia_centena;
                                        end if;
        
        when transmite_distancia_dezena => Eprox <= espera_distancia_dezena;

        when espera_distancia_dezena => if fim_transmissao='1' then Eprox <= transmite_distancia_unidade;
                                    else                        Eprox <= espera_distancia_dezena;
                                    end if;

        when transmite_distancia_unidade => Eprox <= espera_distancia_unidade;

        when espera_distancia_unidade => if fim_transmissao='1' then Eprox <= transmite_distancia_fim;
                                        else                        Eprox <= espera_distancia_unidade;
                                        end if;

        when transmite_distancia_fim => Eprox <= espera_distancia_fim;

        when espera_distancia_fim => if fim_transmissao='1' then Eprox <= final;
                           else                        Eprox <= espera_distancia_distancia_fim;
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
		transmitir <=   '1' when transmite_angulo_centena, 
                        '1' when transmite_angulo_dezena,
                        '1' when transmite_angulo_unidade,
                        '1' when transmite_angulo_fim, 
                        '1' when transmite_distancia_centena, 
                        '1' when transmite_distancia_dezena,
                        '1' when transmite_distancia_unidade,
                        '1' when transmite_distancia_fim, 
						'0' when others;

    with Eatual select
    conta <=    '1' when final, 
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
                    "0011" when transmite_angulo_centena,
                    "0100" when espera_angulo_centena, 
                    "0101" when transmite_angulo_dezena, 
                    "0110" when espera_angulo_dezena, 
                    "0111" when transmite_angulo_fim, 
                    "1000" when espera_angulo_fim, 
                    "1001" when transmite_distancia_centena,
                    "1010" when espera_distancia_centena, 
                    "1011" when transmite_distancia_dezena, 
                    "1100" when espera_distancia_dezena, 
                    "1101" when transmite_distancia_fim, 
                    "1110" when espera_distancia_fim, 
                    "1111" when final,    -- Final
                    "1110" when others;   -- Erro

end architecture;