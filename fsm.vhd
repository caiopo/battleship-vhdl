library IEEE;
use IEEE.Std_Logic_1164.all;

entity fsm is
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
end fsm;

architecture behv of fsm is

component cronometro is
port (
clock_50: in std_logic;
dificuldade: in std_logic_vector(1 downto 0);
reset: in std_logic;
restante: out std_logic_vector(7 downto 0);
atual: out std_logic_vector(7 downto 0)
);
end component;

type states is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9);
signal EA, PE: states;

signal resetCont, contTerminou: std_logic;

signal tempo_restante: std_logic_vector(7 downto 0);

signal tempdifout: std_logic_vector(1 downto 0);

begin

difout <= tempdifout;

chrono: cronometro port map (clock, tempdifout, resetCont, tempo_restante, open);

P1: process(clock, reset)
	begin
	
		-- reset assincrono
		if reset = '0' then
			EA <= S0;
		elsif rising_edge(clock) then
			-- a cada ciclo de clock, o proximo estado (PE) se torna o estado atual (EA)
			EA <= PE;
		end if;
end process;

P2: process(clock, EA, init, fire)
	begin
		if rising_edge(clock) then
			-- a cada ciclo de clock, levando em conta o estado atual, o proximo estado é determinado
			case EA is
				when S0 =>
					-- zera todas as variaveis e espera pela dificuldade ser escolhida
					tempdifout <= "00";
					displaycont <= "00000000";
					displayaddr <= "00";
					displaylinha <= "00000000000000";
				
					compara <= '0';
					
					-- quando init for apertado, passa para S1
					if init = '1' then
						PE <= S0;
					else
						PE <= S1;
					end if;
					
				when S1 =>
					
					-- passa a dificuldade escolhida nos switches 17 e 16 para a saida, impossibilitando mudanca na dificuldade no meio do jogo
					tempdifout <= dif;
					
					-- inicia o reset do contador
					resetCont <= '1';
					
					--espera o jogador soltar o init
					if init = '1' then
						PE <= S2;
					else
						PE <= S1;
					end if;
				
				when S2 =>
				
					-- termina de resetar o contador
					resetCont <= '0';
					
					-- determina o jogador atual como jogador1
					user <= '0';
					
					-- passa as informacoes necessarias para os displays
					displayaddr <= memaddr; -- endereco de memoria (switches 15 e 14)
					displaylinha <= linha; -- linha de tiro (switches 13 downto 0)
					displaycont <= tempo_restante; --(tempo restante)
					
					
					-- se o tempo acabar, termina o turno sem atirar, se fire for apertado, contabiliza o tiro
					if ("00000000" >= tempo_restante) then					
						PE <= S5;								
					elsif fire = '1' then					
						PE <= S2;						
					else
						PE <= S3;						
					end if;
				
				when S3 =>
				
					-- espera soltar o fire
					if fire = '1' then
						PE <= S4;
					else
						PE <= S3;
					end if;
				
				when S4 =>
				
					-- ativa o enable do comparador e do contador de pontos
					
					compara <= '1';
					
					PE <= S5;
				
				when S5 =>
				
					-- reseta os displays e o enable do comparador/contador de pontos
					displaycont <= "00000000";
					displayaddr <= "00";
					displaylinha <= "00000000000000";
				
					compara <= '0';
					
					-- inicia o reset do contador
					resetCont <= '1';
					
					PE <= S6;
					
				when S6 =>
					-- termina de resetar o contador
					resetCont <= '0';
					
					-- determina o jogador atual como jogador2
					user <= '1';
					
					-- passa as informacoes necessarias para os displays
					displayaddr <= memaddr;
					displaylinha <= linha;
					displaycont <= tempo_restante;
					
					-- se o tempo acabar, termina o turno sem atirar, se fire for apertado, contabiliza o tiro
					if ("00000000" >= tempo_restante) then
						PE <= S9;
					elsif fire = '1' then
						PE <= S6;
					else
						PE <= S7;
					end if;
				
				when S7 =>
					-- espera soltar o fire
					if fire = '1' then
						PE <= S8;
					else
						PE <= S7;
					end if;
				
				when S8 =>

					-- ativa o enable do comparador e do contador de pontos				
					compara <= '1';
					
					PE <= S9;
				
				when S9 =>
				
					-- reseta os displays e o enable do comparador/contador de pontos
				
					displaycont <= "00000000";
					displayaddr <= "00";
					displaylinha <= "00000000000000";
				
					compara <= '0';
					
					-- inicia o reset do contador
					resetCont <= '1';
					
					PE <= S2;
					
				
			end case;
		end if;
end process;

end behv;