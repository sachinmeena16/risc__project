library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dregister8 is
  generic (
    nbits : integer:=8);                    -- no. of bits
  port (
    reset: in std_logic;
    din  : in  std_logic_vector(nbits-1 downto 0);
    dout : out std_logic_vector(nbits-1 downto 0);
    enable: in std_logic;
    clk     : in  std_logic);
end dregister8;

architecture behave of dregister8 is

begin  -- behave
process(clk,reset,din)
begin 
if(reset = '0') then
  if(clk'event and clk = '1') then
    if enable = '1' then
      dout <= din;
    end if;
  end if;

else dout <= (others => '0');
end if;

end process;
end behave;
