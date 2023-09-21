library ieee;
use ieee.std_logic_1164.all;

entity trena_saida_serial_uc is 
    port ( 
        clock          : in  std_logic;
        reset          : in  std_logic;
        mensurar       : in  std_logic;
        fim_medida     : in  std_logic;
        fim_transmissao: in  std_logic;
        pronto         : out std_logic;
        db_estado      : out std_logic_vector(3 downto 0)
    );
end entity;

architecture trena_saida_serial_uc_arch of trena_saida_serial_uc is

    type tipo_estado is (inicial, faz_medida, aguarda_medida, transmite_centena, 
                        espera_centena, transmite_dezena, espera_dezena, transmite_unidade, espera_unidade, 
                        transmite_fim, espera_fim, final);
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
  process (mensurar, fim, Eatual) 
  begin

    case Eatual is

      when inicial =>      if mensurar='1' then Eprox <= faz_medida;
                           else                 Eprox <= inicial;
                           end if;

      when faz_medida =>   Eprox <= aguarda_medida;

      when aguarda_medida => if fim_medida='1' then Eprox <= transmite_centena;
                             else                   Eprox <= aguarda_medida;
                             end if;

			when transmite_centena => Eprox <= espera_centena;

      when espera_centena => if fim_transmissao='1' then Eprox <= transmite_dezena;
                             else                        Eprox <= espera_centena;
                             end if;
      
			when transmite_dezena => Eprox <= espera_dezena;

			when espera_dezena => if fim_transmissao='1' then Eprox <= transmite_unidade;
														else                        Eprox <= espera_dezena;
														end if;

			when transmite_unidade => Eprox <= espera_unidade;

			when espera_unidade => if fim_transmissao='1' then Eprox <= transmite_fim;
														 else                        Eprox <= espera_unidade;
														 end if;

			when transmite_fim => Eprox <= espera_fim;

			when espera_fim => if fim_transmissao='1' then Eprox <= final;
												 else                        Eprox <= espera_fim;
												 end if;

      when final =>        Eprox <= inicial;

      when others =>       Eprox <= inicial;

    end case;

  end process;

  -- logica de saida (Moore)
  with Eatual select
      carrega <= '1' when preparacao, '0' when others;

  with Eatual select
      zera <= '1' when preparacao, '0' when others;

  with Eatual select
      desloca <= '1' when transmissao, '0' when others;

  with Eatual select
      conta <= '1' when transmissao, '0' when others;

  with Eatual select
      pronto <= '1' when final, '0' when others;

  with Eatual select
      db_estado <= "0000" when inicial,
                   "0001" when preparacao, 
                   "0010" when espera, 
                   "0100" when transmissao, 
                   "1111" when final,    -- Final
                   "1110" when others;   -- Erro

end architecture;
