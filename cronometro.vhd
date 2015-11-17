library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity cronometro is
port (
clock_50: in std_logic;
dificuldade: in std_logic_vector(1 downto 0);
reset: in std_logic;
restante: out std_logic_vector(7 downto 0);
atual: out std_logic_vector(7 downto 0)
);
end cronometro;

architecture circuito of cronometro is

signal clk_1hz: std_logic;
signal contagem: std_logic_vector(7 downto 0);
signal maximo: std_logic_vector(7 downto 0);

component clock_conv
port
	(
		IN_50MHz	: in  std_logic;
		OUT_0_1Hz : out std_logic;
		OUT_1Hz	: out std_logic;
		OUT_10Hz	: out std_logic
		
	);
end component;


begin
 
converter: clock_conv port map(clock_50, open, clk_1hz, open);

process(dificuldade, clock_50)
begin
	
	-- define o tempo maximo da contagem levando em conta a dificuldade escolhida
	
	case dificuldade is
		when "00" =>
			maximo <= "00011110";
			
		when "01" =>
			maximo <= "00010100";

		when "10" =>
			maximo <= "00001010";
		
		when "11" =>
			maximo <= "00000101";
		
	end case;
end process;

process(clk_1hz, reset)
begin

	if (reset = '1') then
	
		-- reset assincrono
		
		contagem <= "00000000";
		
	elsif (rising_edge(clk_1hz)) then
		
		-- se a o tempo atual for maior que o tempo maximo, reseta o tempo atual, senao, adiciona um ao tempo atual
		
		if	(contagem >= maximo) then
		
			contagem <= "00000000";
	
		else
			
			contagem <= contagem + '1';
		
		end if;
	end if;
end process;

-- para obter o tempo restante, subtraimos o tempo atual do tempo maximo
restante <= maximo - contagem;
atual <= contagem;

end circuito;