library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity topo is

 port ( SW : in std_logic_vector (17 downto 0);
 HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7: out std_logic_vector(6 downto 0);
 LEDR : out std_logic_vector (17 downto 0);
 LEDG : out std_logic_vector (7 downto 0);
 KEY: in std_logic_vector(3 downto 0);
 clock_50: in std_logic
 );
 
end topo;

architecture topo_stru of topo is

component contador_pontos is
port (compara, user, cont_match, clock, reset: in std_logic;

ledred, ledgrn: out std_logic_vector(7 downto 0)
 );
end component;

component decod is
port (C: in std_logic_vector(3 downto 0);
 S: out std_logic_vector(6 downto 0)
 );
end component;

component vector_to_bcd is port(
input: in std_logic_vector(7 downto 0);
to_decod1, to_decod0: out std_logic_vector(3 downto 0)
);
end component;

component comparador is
port (compara, player, clock: in std_logic;
tiro: in std_logic_vector(13 downto 0);
address: in std_logic_vector(1 downto 0);

match: out std_logic
);
end component;

component fsm
port (dif: in std_logic_vector(1 downto 0);
clock, init, fire, reset: in std_logic;
memaddr: in std_logic_vector(1 downto 0);
linha: in std_logic_vector(13 downto 0);

displaycont: out std_logic_vector(7 downto 0);
displayaddr: out std_logic_vector(1 downto 0);
displaylinha: out std_logic_vector(13 downto 0);
user, compara: out std_logic;
difout: out std_logic_vector(1 downto 0)
 );
end component;

signal jogador, comparar, tiro_match: std_logic;

signal dificuldade, addr_to_hex, jog_to_hex: std_logic_vector(1 downto 0);

signal to_contador: std_logic_vector(7 downto 0);

signal to_dec1, to_dec0, linha_to_decod: std_logic_vector(3 downto 0);

signal linha_to_number: std_logic_vector(13 downto 0);



begin



-- cria a fsm e designa os parametros. entradas: dificuldade, clock, init, fire, endereco de memoria, tiro
-- saidas: contador, endereco de memoria para o hex e comparador, linha de tiro para hex e comparador, jogador atual, enable do comparador e dificuldade
machine: fsm port map (SW(17 downto 16), clock_50, KEY(2), KEY(3), KEY(0), SW(15 downto 14), SW(13 downto 0), to_contador, addr_to_hex, linha_to_number, jogador, comparar, dificuldade);

-- entrega um vetor de 8 bits com o tempo restante para o conversor que transforma em 2 vetores de 4 bits com o mesmo valor em bcd
vector_bcd: vector_to_bcd port map (to_contador, to_dec1, to_dec0);

-- cria o comparador e liga ele aos seus parametros. entradas: enable, jogador atual, clock, linha de tiro e endereco de memoria
-- saidas: match
comp: comparador port map (comparar, jogador, clock_50, linha_to_number, addr_to_hex, tiro_match);

-- cria o contador de pontos e liga ele aos seus parametros. entradas: enable (caso esteja 1, ele "escuta" o que entra no match), jogador atual, match, clock e reset
-- saidas: ledr e ledg
pontuacao: contador_pontos port map (comparar, jogador, tiro_match, clock_50, KEY(0), LEDR(7 downto 0), LEDG(7 downto 0));



-- digito da unidade do contador para 7 segmentos
decod_hex0: decod port map(to_dec0, HEX0);

-- digito da dezena do contador para 7 segmentos
decod_hex1: decod port map(to_dec1, HEX1);

-- digito da dificuldade para 7 segmentos
decod_hex2: decod port map (("00"&dificuldade)+"1", HEX2);

-- "L"
HEX3 <= "1000111";

process(jogador) -- decodifica o std_logic que guarda o numero do jogado para 7 segmentos
begin
	if jogador = '0' then
		jog_to_hex <= "01";
	else
		jog_to_hex <= "10";
	end if;
end process;

decod_hex4: decod port map ("00"&jog_to_hex, HEX4);

-- "U"
HEX5 <= "1000001";


process(linha_to_number) -- percorre os swiches 13 ao 0 para descobrir qual esta ativo, entao decodifica seu numero para 7 segmentos
variable i: integer;
variable position: integer;
begin
	position := 0;
	for i in 0 to 13 loop
		if linha_to_number(i) = '1' then
			position := i;
		end if;
	end loop;

linha_to_decod <= std_logic_vector(to_unsigned(position, linha_to_decod'length));
	
end process;

-- numero da coluna gerado pelo process acima
decod_hex6: decod port map (linha_to_decod, HEX6);

-- numero da linha da matriz escolhido pelos switches 15 e 14
decod_hex7: decod port map ("00"&addr_to_hex, HEX7);

end topo_stru;