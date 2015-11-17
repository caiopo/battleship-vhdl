LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity clock_conv is
	port
	(
		IN_50MHz	: in  std_logic;
		
		-- Output ports
		OUT_0_1Hz : out std_logic;
		OUT_1Hz	: out std_logic;
		OUT_10Hz	: out std_logic
	);
end clock_conv;

architecture clock_convimpl of clock_conv is

signal count_a: integer range 0 to 5000000;
signal count_b,count_c: integer range 0 to 10;
signal aux,aux2: STD_LOGIC;

begin

process (IN_50MHz)
begin
	if rising_edge(IN_50MHz) then
		count_a <= count_a + 1;
		if (count_a < 2500000) then
			OUT_10Hz <= '0';
			aux <= '0';
		else
			OUT_10Hz <= '1';
			aux <= '1';
			if (count_a = 4999999) then
				count_a <= 0;
			end if;
		end if;	
	end if;
end process;

process (aux)
begin
	if rising_edge(aux) then
		count_b <= count_b + 1;
		if (count_b < 5) then
			OUT_1Hz <= '0';
			aux2 <= '0';
		else
			OUT_1Hz <= '1';
			aux2 <= '1';
			if (count_b = 9) then
				count_b <= 0;
			end if;
		end if;	
	end if;
end process;

process (aux2)
begin
	if rising_edge(aux2) then
		count_c <= count_c + 1;
		if (count_c < 5) then
			OUT_0_1Hz <= '0';
		else
			OUT_0_1Hz <= '1';
			if (count_c = 9) then
				count_c <= 0;
			end if;
		end if;	
	end if;
end process;
	
end clock_convimpl;