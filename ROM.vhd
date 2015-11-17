
-- Esse exemplo de descricao de memoria ROM em VHDL foi obtido no
-- site: http://www.edaboard.com/thread38052.html
--
-- Esse site foi encontrado ao se realizar uma busca no google com 
-- a expressao (sem aspas): ROM VHDL
--
-- O exemplo original do site foi adaptado (pequenas modificacoes) para
-- se adequar a especificacao do trabalho pratico da disciplina de 
-- Circuitos e Tecnicas Digitais, semestre 2015/1. Podem ser necessarias
-- modificacoes adicionais.
--
-- Esse exemplo foi compilado e simulado utilizando a ferramenta on-line:
-- http://www.edaplayground.com/
--
-- Nao foi testado com o Quartus/ModelSim, logo nao existe garantia de 
-- funcionamento, principalmente por ter sido encontrado na Internet.
-- Podem existir, inclusive, erros de sintaxe ao ser utilizado no Quartus.
--
-- Eduardo Bezerra, junho de 2015.
--

LIBRARY IEEE;
    USE IEEE.STD_LOGIC_1164.ALL;
    USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ROM IS
  PORT(
			player : in std_logic;
         address : in std_logic_vector(1 downto 0);
         data : out std_logic_vector(13 downto 0) 
       );
END ENTITY;

ARCHITECTURE BEV OF ROM IS

  type mem is array ( 0 to 2**2 - 1) of std_logic_vector(13 downto 0);
  
  constant p1 : mem := (
	--  memoria do player 1
	 0  => "00011100000000",
    1  => "01000000000010",
    2  => "01000000010000",
    3  => "00000000010000"
    );
	 
	constant p2 : mem := (
	-- memoria do player 2
    0  => "00000001000000",
    1  => "00010001000010",
    2  => "00010001000000",
    3  => "01100000000000"
    );

BEGIN

   process (player, address)
   begin
	if player = '1' then
     case address is
       when "00" => data <= p1(0);
       when "01" => data <= p1(1);
       when "10" => data <= p1(2);
       when "11" => data <= p1(3);
       when others => data <= (others => '0');
     end case;
	  else
		 case address is
       when "00" => data <= p2(0);
       when "01" => data <= p2(1);
       when "10" => data <= p2(2);
       when "11" => data <= p2(3);
       when others => data <= (others => '0');
     end case;
	  end if;
  end process;

END BEV;

