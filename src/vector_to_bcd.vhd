library ieee;
use ieee.std_logic_1164.all;

entity vector_to_bcd is port(
input: in std_logic_vector(7 downto 0);
to_decod1, to_decod0: out std_logic_vector(3 downto 0)
);
end vector_to_bcd;

architecture behv of vector_to_bcd is

signal total: std_logic_vector(7 downto 0);

signal dec1, dec0: std_logic_vector(3 downto 0);

begin

-- converte um vetor de 8 bits em dois vetores de 4 bits em bcd

process(input)
begin

	case input is
		when "00000000" =>
		
			dec1 <= "0000";
			dec0 <= "0000";
			
		when "00000001" =>
		
			dec1 <= "0000";
			dec0 <= "0001";
		
		when "00000010" =>		
		
			dec1 <= "0000";
			dec0 <= "0010";
			
		when "00000011" =>		
		
			dec1 <= "0000";
			dec0 <= "0011";
			
		when "00000100" =>
	
			dec1 <= "0000";
			dec0 <= "0100";
			
		when "00000101" =>	
		
			dec1 <= "0000";
			dec0 <= "0101";
	
		when "00000110" =>	
	
			dec1 <= "0000";
			dec0 <= "0110";
		
		when "00000111" =>	
	
			dec1 <= "0000";
			dec0 <= "0111";
	
		when "00001000" =>	
		
			dec1 <= "0000";
			dec0 <= "1000";
	
		when "00001001" =>
		
			dec1 <= "0000";
			dec0 <= "1001";
		
		when "00001010" =>
		
			dec1 <= "0001";
			dec0 <= "0000";
			
		when "00001011" =>
		
			dec1 <= "0001";
			dec0 <= "0001";
		
		when "00001100" =>
				
			dec1 <= "0001";
			dec0 <= "0010";
		
		when "00001101" =>
		
			dec1 <= "0001";
			dec0 <= "0011";
		
		when "00001110" =>
		
			dec1 <= "0001";
			dec0 <= "0100";
		
		when "00001111" =>
		
			dec1 <= "0001";
			dec0 <= "0101";
		
		when "00010000" =>
		
			dec1 <= "0001";
			dec0 <= "0110";

		when "00010001" =>
		
			dec1 <= "0001";
			dec0 <= "0111";
		
		when "00010010" =>
		
			dec1 <= "0001";
			dec0 <= "1000";
	
		when "00010011" =>

			dec1 <= "0001";
			dec0 <= "1001";
		
		when "00010100" =>
		
			dec1 <= "0010";
			dec0 <= "0000";
		
		when "00010101" =>
		
			dec1 <= "0010";
			dec0 <= "0001";
		
		when "00010110" =>
		
			dec1 <= "0010";
			dec0 <= "0010";
			
		when "00010111" =>
		
			dec1 <= "0010";
			dec0 <= "0011";
			
		when "00011000" =>
		
			dec1 <= "0010";
			dec0 <= "0100";
			
		when "00011001" =>
	
			dec1 <= "0010";
			dec0 <= "0101";
			
		when "00011010" =>
		
			dec1 <= "0010";
			dec0 <= "0110";
		
		when "00011011" =>
		
			dec1 <= "0010";
			dec0 <= "0111";
			
		when "00011100" =>
		
			dec1 <= "0010";
			dec0 <= "1000";
		
		when "00011101" =>
		
			dec1 <= "0010";
			dec0 <= "1001";
		
		when "00011110" =>
		
			dec1 <= "0011";
			dec0 <= "0000";
		
		when "00011111" =>
		
			dec1 <= "0011";
			dec0 <= "0001";
		
		when "00100000" =>
		
			dec1 <= "0011";
			dec0 <= "0010";
			
		when others =>
		
			dec1 <= "1110";
			dec0 <= "1110";
		
	end case;
	
	to_decod0 <= dec0;
	to_decod1 <= dec1;
		
end process;



end behv;