library IEEE;
use IEEE.Std_Logic_1164.all;
use ieee.std_logic_unsigned.all;

entity comparador is
port (compara, player, clock: in std_logic;
tiro: in std_logic_vector(13 downto 0);
address: in std_logic_vector(1 downto 0);
match: out std_logic
);
end comparador;

architecture comparador of comparador is

signal linha: std_logic_vector(13 downto 0);


component ROM is
port(player : in std_logic;
     address : in std_logic_vector(1 downto 0);
     data : out std_logic_vector(13 downto 0)
	  );
end component;

begin

-- cria a memoria designando os parametros de entrada: jogador atual e endereco de memoria; saida: linha correspondente ao endereco
memoria: ROM port map(player, address, linha);


process(compara, clock)
begin
	if rising_edge(clock) then
	
		if compara = '1' then
		
		-- se o enable do comparador estiver ativo, testa se algum um bit do vetor da memoria e do tiro do jogador sao iguais a 1 na mesma posicao
		
			if ((linha(13 downto 0) and tiro(13 downto 0)) /= "00000000000000") then
		
				match <= '1';
				
			end if;
		
		else
	
			match <= '0';
			
		end if;
	end if;
	
end process;

end comparador;