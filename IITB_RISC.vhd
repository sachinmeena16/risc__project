library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.basic.all;

entity IITB_RISC is
	port(clk,reset: in std_logic);
end entity;

architecture behave of IITB_RISC is
signal	   m_mema :  std_logic; 
signal		m_alub0,m_alub1:  std_logic;
signal      m_alua0,m_alua1 :  std_logic;		
signal		m_t2_0 :  std_logic;
signal		m_a1,m_a2 :  std_logic;
signal		m_t2 :  std_logic;
signal		m_t3 :  std_logic;
signal		m_d30,m_d31 :  std_logic;
signal		m_tc :  std_logic;
signal		m_a30,m_a31 :  std_logic;
signal		m_t1,m_z: std_logic;
signal		wr_mem        :  std_logic;   
signal		rd_mem        :  std_logic;   
signal		wr_rf         : std_logic;  
		
		
signal		en_ir         : std_logic;  
signal		en_t1,en_t2,en_t3,en_tc,en_pc     :  std_logic;  
signal		en_c,en_z     :  std_logic;
signal		op_sel        :  std_logic;   
signal		condition_code:  std_logic_vector(1 downto 0); 
signal		equ      :  std_logic;  
signal		C,Z      :  std_logic; 
signal		pe_done  :  std_logic;  
signal		op_code  : std_logic_vector(3 downto 0); 
begin
	datapath_risc : datapath
			port map(
		m_mema	       => m_mema,
		
		
		m_alub0            => m_alub0,
		m_alub1        => m_alub1,
		
		m_alua0	       => m_alua0,
		m_alua1        => m_alua1,
		
		m_t2_0 	       => m_t2_0,
		m_a1         => m_a1,
		m_a2 	       => m_a2,
		m_t2      => m_t2,
		m_t3          => m_t3,
		
		m_d30 => m_d30,
		m_d31 => m_d31,
		m_tc          => m_tc,
		m_a30	       => m_a30,
		m_a31           => m_a31,
		m_z         => m_z,
		
		m_t1          => m_t1,
		wr_mem         => wr_mem,  
		rd_mem         => rd_mem,  
		wr_rf          => wr_rf,   
		en_ir          => en_ir,   
		 en_pc => en_pc,
		en_t1           => en_t1,
		en_t2           => en_t2,
      en_t3 => en_t3,
      en_tc => en_tc,
		en_c           => en_c,
		en_z           => en_z,
		op_sel         => op_sel,   
		equ            => equ,    
		C              => C,
		Z              => Z, 
		pe_done        => pe_done,  
		op_code        => op_code,
		condition_code => condition_code,
		clk            => clk,
		reset          => reset
	    );
	
	controlpath_risc : controlpath
			port map(
		m_mema	       => m_mema,
		
		
		m_alub0            => m_alub0,
		m_alub1        => m_alub1,
		
		m_alua0	       => m_alua0,
		m_alua1        => m_alua1,
		
		m_t2_0 	       => m_t2_0,
		m_a1         => m_a1,
		m_a2 	       => m_a2,
		m_t2      => m_t2,
		m_t3          => m_t3,
		
		m_d30 => m_d30,
		m_d31 => m_d31,
		m_tc          => m_tc,
		m_a30	       => m_a30,
		m_a31           => m_a31,
		m_z         => m_z,
		
		m_t1          => m_t1,
		wr_mem         => wr_mem,  
		rd_mem         => rd_mem,  
		wr_rf          => wr_rf,   
		en_ir          => en_ir,   
		 en_pc => en_pc,
		en_t1           => en_t1,
		en_t2           => en_t2,
      en_t3 => en_t3,
      en_tc => en_tc,
		en_c           => en_c,
		en_z           => en_z,
		op_sel         => op_sel,   
		equ            => equ,    
		C              => C,
		Z              => Z, 
		pe_done        => pe_done,  
		op_code        => op_code,
		condition_code => condition_code,
		clk            => clk,
		reset          => reset
	    );
end behave;
