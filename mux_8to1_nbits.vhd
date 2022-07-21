library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux8 is
	generic(input_width: integer := 16);
	port(
		inp1, inp2, inp3, inp4, inp5, inp6, inp7, inp0: in std_logic_vector(input_width-1 downto 0) := (others => '0');
		s: in std_logic_vector(2 downto 0);
		output: out std_logic_vector(input_width-1 downto 0));
end entity;

architecture behave of mux8 is
begin
	output <= inp0 when (s = "000") else
		  inp1 when (s = "001") else
		  inp2 when (s = "010") else
	     inp3 when (s = "011") else
		  inp4 when (s = "100") else
		  inp5 when (s = "101") else
		  inp6 when (s = "110") else
		  inp7;
end;
