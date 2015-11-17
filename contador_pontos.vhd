library IEEE;
use IEEE.Std_Logic_1164.all;

entity contador_pontos is
port (compara, user, cont_match, clock, reset: in std_logic;

ledred, ledgrn: out std_logic_vector(7 downto 0)
 );
end contador_pontos;

architecture behv of contador_pontos is

signal tempLedRed, tempLedGrn: std_logic_vector(7 downto 0);

begin


process(clock, reset)
begin

	if (reset = '0') then
		-- reset assincrono
		tempLedRed <= "00000000";
		tempLedGrn <= "00000000";
		
	elsif rising_edge(clock) and (cont_match = '1') and (compara = '1') then
	
		-- se o match e o enable do comparador estiverem em 1, desloca os pontos do jogador para a esquerda e adiciona um ponto no final
		
		if user = '0' then
		
			tempLedRed(7 downto 1) <= tempLedRed(6 downto 0);
			tempLedRed(0) <= '1';
			
		else
			
			tempLedGrn(7 downto 1) <= tempLedGrn(6 downto 0);
			tempLedGrn(0) <= '1';
			
		end if;	
			
	end if;
	
	ledred <= tempLedRed;
	ledgrn <= tempLedGrn;

end process;
end behv;