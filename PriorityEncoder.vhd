library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PriorityEncoder is
port(  
	input : in std_logic_vector(7 downto 0);
	output1f : out std_logic_vector(7 downto 0);
	output2 : out std_logic_vector(2 downto 0);
	invalid : out std_logic
       );
end PriorityEncoder;

architecture behave of PriorityEncoder is
signal x_bar,x,output1: std_logic_vector(7 downto 0);
signal y : std_logic_vector(2 downto 0);

begin
	loopy: for i in 0 to 7 generate
		x(i) <= input(7-i);
	       end generate;
	x_bar<= not(x);

	invalid <= not (x(0) or x(1) or x(2) or x(3) or x(4) or x(5) or x(6) or x(7));
	y(0) <= x_bar(0) and (x(1) or(x_bar(2) and x(3))or (x_bar(2) and x_bar(4) and x(5)) or (x_bar(2) and x_bar(4) and x_bar(6) and x(7)));
	y(1) <= x_bar(0) and x_bar(1) and (x(2) or x(3) or (x_bar(4) and x_bar(5) and (x(6) or x(7)))); 
	y(2) <= x_bar(0) and x_bar(1) and x_bar(2) and x_bar(3) and (x(4) or x(5) or x(6) or x(7));
	outputs: process(y)
	begin
	
	if y = "000" then
		 output1 <= x;
		 output2 <= not y;
	elsif y = "001" then
	    output1(7 downto 1) <= x(7 downto 1);
		 output1(0) <= '0';
		 output2 <= not y;
	elsif y = "010" then
	    output1(7 downto 2) <= x(7 downto 2);
		 output1(1) <='0';
		 output1(0) <= x(0);
		 output2 <= not y;
	elsif y = "011" then
	    output1(7 downto 3) <= x(7 downto 3);
		 output1(2) <='0';
		 output1(1 downto 0) <= x(1 downto 0);
		 
	elsif y = "100" then
	    output1(7 downto 4) <= x(7 downto 4);
		 output1(3) <='0';
		 output1(2 downto 0) <= x(2 downto 0);
		
	elsif y = "101" then
	    output1(7 downto 5) <= x(7 downto 5);
		 output1(4) <='0';
		 output1(3 downto 0) <= x(3 downto 0);
		 output2 <= not y;
	elsif y = "110" then
	    output1(7 downto 6) <= x(7 downto 6);
		 output1(6) <='0';
		 output1(5 downto 0) <= x(5 downto 0);
		 
	elsif y = "111" then
	    
		 output1(7) <='0';
		 output1(6 downto 0) <= x(6 downto 0);
	    output2 <= not y;
	end if;
	output1f <= output1;
	end process outputs;
end behave;

