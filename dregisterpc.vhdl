library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port
    ( pcout      : out std_logic_vector(15 downto 0);		----- Read outputs bus
      pcin         : in  std_logic_vector(15 downto 0);		----- Write Input bus
      wr_en 	: in  std_logic;
      rd_en  	: in  std_logic;									----- is set to '1' always
      reset    	: in  std_logic;
      clk         : in  std_logic );
end register_file;

architecture behave of register_file is
	
	

	begin
		process(clk, reset)
		begin
			if(reset = '1') then
				pcin <= (others => (others => '0'));
			else
				if(clk'event and clk = '1') then
					if (write_en = '1') then
						registers(to_integer(unsigned(a3))) <= d3;
					end if;
				end if;
			end if;
		end process;

	end behave;
