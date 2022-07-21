library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.basic.all;

entity controlpath is
	port(  -----mux signals-----------------
		m_mema: out std_logic; 
		m_alub0,m_alub1 : out std_logic;
      m_alua0,m_alua1 : out std_logic;		
		m_a1,m_a2 : out std_logic;
		m_t2 : out std_logic;
		m_t2_0 : out std_logic;
		m_t3 : out std_logic;
		m_d30,m_d31 : out std_logic;
		m_tc : out std_logic;
		m_a30,m_a31 : out std_logic;
		m_t1,m_z: out std_logic;
		wr_mem        : out std_logic;   --write on memory
		rd_mem        : out std_logic;   --read memory
		wr_rf         : out std_logic;   --write on register file
		
		-----enable---------------------
		en_ir         : out std_logic;  --enable instruction register
		en_t1,en_t2,en_t3,en_tc,en_pc    : out std_logic;   --enable of input registers to alu
		en_c,en_z     : out std_logic;
		op_sel        : out std_logic;   --operation select by alu
		condition_code: in std_logic_vector(1 downto 0);    --last 2 bits of IR
		equ      : in std_logic;  --comparator
		C,Z      : in std_logic;  --carry,zero
		pe_done  : in std_logic;  --multiple load,store done
		op_code  : in std_logic_vector(3 downto 0);  --first 4 bits of IR which is op_code

		clk,reset: in std_logic
	    );
end entity;

architecture behave of controlpath is
	type state is ( RST,CHECK ,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15);
	signal Q, nQ : state := RST;       ---initialised at HKT1 (InstructionFetch Cycle)
	begin

		
      
		delay: process(clk)
		begin
			if(clk='1' and clk'event) then
				Q <= nQ;           ---state is changed at rising edge
			end if;
		end process delay;

		main: process(clk, Q, reset, nQ, pe_done, equ)
		begin
			if reset='1' then
				nQ <= RST;
			else
				case Q is
					when RST =>
						en_z    <= '0';
						en_tc <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_t3		<= '0';
						en_pc <= '0';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
						
						nQ <= s1;
						
					when s1 =>
					   op_sel <= '0';
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_t3		<= '0';
						en_tc <= '0';
						en_pc <= '1';
						wr_rf   <= '0';
						en_ir   <= '1';
						wr_mem  <= '0';
						rd_mem  <= '1';
						
						m_alub0 <= '1';
						m_alub1 <= '1';
						
						m_alua0 <= '0';
						m_alua1 <= '0';
						m_mema <= '0';
						
				      nQ <= CHECK;
						
					when CHECK =>
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_pc <= '0';
						en_t2		<= '0';
						en_t3		<= '0';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
						

					---------- Decoder Logic-----------
						if(op_code(3 downto 0) = "0000") then nQ <= s2;
						elsif(op_code(3 downto 0) = "0001" and condition_code = "10" and c = '1') then nQ <= s2;
						elsif(op_code(3 downto 0) = "0001" and condition_code = "11")  then nQ <= s2;
						elsif(op_code(3 downto 0) = "0010" and condition_code = "00") then nQ <= s2;
						elsif(op_code(3 downto 0) = "0001" and condition_code = "00") then nQ <= s2;
						elsif(op_code(3 downto 0) = "0001" and condition_code = "01" and z = '1') then nQ <= s2;
						elsif(op_code(3 downto 0) = "0001" and condition_code = "10" and c = '0') then nQ <= s5;
						elsif(op_code(3 downto 0) = "0001" and condition_code = "01" and z = '0') then nQ <= s5;
						elsif(op_code(3 downto 0) = "0010" and condition_code = "10" and c = '1') then nQ <= s2;
						elsif(op_code(3 downto 0) = "0010" and condition_code = "01" and z = '1') then nQ <= s2;
						elsif(op_code(3 downto 0) = "0010" and condition_code = "10" and c = '0') then nQ <= s5;
						elsif(op_code(3 downto 0) = "0010" and condition_code = "01" and z = '0') then nQ <= s5;
						elsif(op_code(3 downto 0) = "0111") then nQ <= s2;
						elsif(op_code(3 downto 0) = "0101") then nQ <= s2;
						
						elsif(op_code(3 downto 0) = "0011") then nQ <= s4;
						elsif(op_code(3 downto 0) = "1011") then nQ <= s13;
						elsif(op_code(3 downto 0) = "1001") then nQ <= s15;
						elsif(op_code(3 downto 2) = "11") then nQ <= s2;
						elsif(op_code(3 downto 0) = "1000") then nQ <= s2;
						
						elsif(op_code(3 downto 0) = "1010") then nQ <= s4;
						
						
						
						
						
						end if;
						
					when s2 =>
						 
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '1';
						en_tc <= '0';
						en_pc <= '0';
						en_t2		<= '1';
						en_t3		<= '1';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';			
						
						m_a1   <= '1';
						m_a2   <= '1';
						
						m_t2   <= '1';
						m_t1   <= '1';
						m_t3   <= '0';
						-------------Next State Logic-----------------
						
						
						
						
						
						if(op_code(3 downto 0) = "0001" )   then nQ <= s3;
						elsif(op_code(3 downto 2) = "01" )   then nQ <= s3;
						elsif(op_code(3 downto 0) = "0010")  then nQ <= s3;
						elsif(op_code(3 downto 0) = "1100") then nQ <= s6;
						elsif(op_code(3 downto 0) = "1101")  then nQ <= s10;
						elsif(op_code(3 downto 0) = "1000" and equ = '0')  then nQ <= s5;
						elsif(op_code(3 downto 0) = "1000" and equ = '1')  then nQ <= s12;
                  end if;
						
						
						
						
						
						
						
						
						

					when s3 =>
					   if (op_code(1 downto 0) = "01") then  
					       op_sel <= '0';
					   elsif (op_code(1 downto 0) = "10") then
					       op_sel <= '1';	
					   end if;
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_tc <= '0';
						en_pc <= '0';
						en_t3		<= '1';
						wr_rf   <= '1';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
						
								
				     if (op_code(3 downto 0) = "0010") then  
					       m_alub0   <= '0';
						    m_alub1   <= '1';
							 m_t2_0    <= '1';
					   elsif (op_code(3 downto 2) = "01") then
					       m_alub0   <= '0';
						    m_alub1   <= '0';
						elsif (op_code(3 downto 0) = "0001" and condition_code = "11") then
					       m_alub0   <= '0';
						    m_alub1   <= '1';
							 m_t2_0    <= '0';
                  elsif (op_code(3 downto 0) = "0001" and (condition_code = "00" or condition_code = "01" or condition_code = "10")) then
					       m_alub0   <= '0';
						    m_alub1   <= '1';
							 m_t2_0    <= '1';							
							end if; 
						
						m_alua0   <= '0';
						m_alua1   <= '1';
						m_d30   <= '0';
						m_d31  <= '0';
						m_t3   <= '1';
						m_a30  <='0';
						m_a31  <='1';
						
						
						
						
						
						-------------Next State Logic-----------------
					 if(op_code(3 downto 0) = "0001" )   then nQ <= S4;
					 elsif(op_code(3 downto 0) = "0000" )   then nQ <= S4;
				  	 elsif(op_code(3 downto 0) = "0010")  then nQ <= S4;
					 elsif(op_code(3 downto 0) = "0111" )   then nQ <= S6;
				  	 elsif(op_code(3 downto 0) = "0101")  then nQ <= S8;
						end if;
						
						
						
						

					when s4 =>
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '1';
						en_t2		<= '0';
						en_tc <= '0';
						en_pc <= '0';
						en_t3		<= '1';
						wr_rf   <= '1';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
					if (op_code(3 downto 0) = "0001") then  
					        m_d30<='1';
						     m_d31<='0';
					   elsif (op_code(3 downto 0) = "0010") then
					       m_d30<='1';
						    m_d31<='0';
						elsif (op_code(3 downto 0) = "0011" ) then
					        m_d30<='0';
						     m_d31<='1';
                  elsif (op_code(3 downto 0) = "1010") then
					        m_d30<='0';
						     m_d31<='0';						
						end if; 
					

						
						m_a1  <= '1';
						m_t1 <= '1';
				     
						m_a30<='1';
						m_a31<='0';
					
						
						
						-------------Next State Logic-----------------
						if(op_code(3 downto 0) = "0001" )   then nQ <= s1;
					 elsif(op_code(3 downto 0) = "0000" )   then nQ <= s1;
				  	 elsif(op_code(3 downto 0) = "0010")  then nQ <= s1;
					 elsif(op_code(3 downto 0) = "0011" )   then nQ <= s5;
				  	 elsif(op_code(3 downto 0) = "1010")  then nQ <= s5;
                end if;
					when s5 =>
					   op_sel <= '0';
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_tc <= '0';
						en_pc <= '1';
						en_t3		<= '1';
						wr_rf   <= '1';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
				if (op_code(3 downto 0) = "0001") then  
					        m_d30<='0';
						     m_d31<='0';
					   elsif (op_code(3 downto 0) = "0010") then
					       m_d30<='0';
						    m_d31<='0';
						elsif (op_code(3 downto 2) = "11" ) then
					        m_d30<='0';
						     m_d31<='0';
                  elsif (op_code(3 downto 0) = "1000") then
					        m_d30<='0';
						     m_d31<='0';
			         elsif (op_code(3 downto 0) = "1001") then
					       m_d30<='1';
						    m_d31<='0';
						elsif (op_code(3 downto 2) = "1010" ) then
					        m_d30<='1';
						     m_d31<='1';
                  elsif (op_code(3 downto 0) = "1011") then
					        m_d30<='0';
						     m_d31<='0';					  
						end if; 
						
						m_alua0<= '0';
						m_alua1<= '0';
						m_alub0<= '1';
						m_alub1<='0';
						
						m_a30<='0';
						m_a31<='1';
					
						
						
						-------------Next State Logic-----------------
						
							
						nQ <= s1;
					

					when s6 =>
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '1';
						en_t2		<= '0';
						en_t3		<= '0';
						en_tc <= '0';
						en_pc <= '0';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '1';
					
						
						
	               m_mema<='1';
						
		            m_t1<='0';
						
						
						
						
						
						-------------Next State Logic-----------------
					if(op_code(3 downto 2) = "01" )   then nQ <= s7;
					 elsif(op_code(3 downto 2) = "11" )   then nQ <= s9;
				  	 
                end if;

					when s7 =>
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_tc <= '0';
						en_pc <= '0';
						en_t3		<= '0';
						wr_rf   <= '1';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
				
						
						
		            
						m_d30<='1';
						m_d31<='1';
						m_a30<='0';
						m_a31<='1';
					
						
						
						
						
						
						
						
						-------------Next State Logic-----------------
						nQ <= s1;
                 
						
					when s8 =>
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_t3		<= '0';
						en_tc <= '0';
						en_pc <= '0';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '1';
						rd_mem  <= '0';
					
											
						m_mema <= '0';
						
						
						
						-------------Next State Logic-----------------
						if(op_code(3 downto 2) = "01" )   then nQ <= s1;
					 elsif(op_code(3 downto 2) = "11" )   then nQ <= s11;
				  	 
                end if;

					when s9 =>
						op_Sel <= '0';
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_tc    <= '1';
						en_pc <= '0';
						en_t3		<= '1';
						wr_rf   <= '1';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
						
						
						m_alub0 <='1';
						m_alub1 <='1';
						
						m_alua0 <='1';
						m_alua1 <='0';
						
						m_t2 <='0';
						m_d30 <='1';
						m_d31 <='1';
						m_a30 <='0';
						m_a31 <='0';
						m_tc <='0';
						

			if(pe_done = '1')   then nQ <= s5;
						else nQ <= S6;
						end if;
								
						

					when s10=>
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_tc  <= '1';
						en_t2		<= '1';
						en_pc <= '0';
						en_t3		<= '0';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
						
					
						
						m_t2  <='0';
						m_a1  <='0';
						
						m_tc  <='0';
						
						
						
--						-------------Next State Logic-----------------
						nQ <= s8;

					when s11 =>
						op_sel <= '0';
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_tc <= '1';
						en_t3		<= '0';
						en_pc <= '0';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
					
						
						
						m_alub0  <= '1';
						m_alub1   <= '1';
					
						m_alua0 <='1';
						m_alua1   <= '0';
						m_t3   <= '1';
						
						
						
						-------------Next State Logic-----------------
						if(pe_done = '1')   then nQ <= s5;
						else nQ <= s10;
						end if;


					when s12=>
						op_sel    <= '0';
                  en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_pc <= '1';
						en_t2		<= '0';
						en_t3		<= '0';
						en_tc <= '0';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
					
						
                  m_alub0  <= '0';
						m_alub1   <= '0';
						m_alua0   <= '0';
						m_alua1   <= '0';
					
						
						
						
						-------------Next State Logic-----------------
						
						nQ <=s5;
				

					when s13 =>
					   op_Sel <= '0';
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '1';
						en_tc    <= '0';
						en_pc <= '0';
						en_t3		<= '0';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
						
					
						
						
						m_t2 <='0';
						m_a2 <= '0';						
						-------------Next State Logic-----------------
						 
								
						nQ <= S14;
					
						
						
					when s14 =>
						op_sel <= '0';
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_tc <= '0';
						en_t3		<= '0';
						en_pc <= '1';
						wr_rf   <= '0';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
					
						
						
						m_alub0  <= '1';
						m_alub1   <= '0';
						
						m_alua0 <='1';
						m_alua1   <= '1';
						m_t2   <= '0';
						
						
						
						-------------Next State Logic-----------------
						 
					nq<=s5 ;
				
					
					when s15 =>
						op_sel <= '0';
						en_z    <= '0';
						en_c    <= '0';
						en_t1    <= '0';
						en_t2		<= '0';
						en_tc <= '0';
						en_pc <= '0';
						en_t3		<= '1';
						wr_rf   <= '1';
						en_ir   <= '0';
						wr_mem  <= '0';
						rd_mem  <= '0';
					
						
						
						
						m_alub0  <= '1';
						m_alub1   <= '0';
						m_t3 <= '1';
						m_alua0   <= '0';
						m_alua1   <= '0';
						
						
						m_t3 <='0';
						
						m_d30  <='0';
						m_d31  <='0';
						
						
						m_a30  <='1';
						m_a31  <='0';
						
						
						
						
						-------------Next State Logic-----------------
						nQ <= s5;
			      
						
					end case;	
						
			end if;
			end process;
	end behave;