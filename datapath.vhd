library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

library work;
use work.basic.all;

entity datapath is
	port(  -----mux signals-----------------
		m_mema: in std_logic; 
		m_alub0,m_alub1 : in std_logic;
      m_alua0,m_alua1 : in std_logic;		
		m_a1,m_a2 : in std_logic;
		m_t2 : in std_logic;
		m_t2_0 : in std_logic;
		m_t3 : in std_logic;
		m_d30,m_d31 : in std_logic;
		m_tc : in std_logic;
		m_a30,m_a31 : in std_logic;
		m_t1,m_z
		: in std_logic;
		wr_mem        : in std_logic;   --write on memory
		rd_mem        : in std_logic;   --read memory
		wr_rf         : in std_logic;   --write on register file
		
		-----enable---------------------
		en_ir         : in std_logic;  --enable instruction register
		en_t1,en_t2,en_t3,en_tc,en_pc    : in std_logic;   --enable of input registers to alu
		en_c,en_z     : in std_logic;
		op_sel        : in std_logic;   --operation select by alu
		condition_code: out std_logic_vector(1 downto 0);    --last 2 bits of IR
		equ      : out std_logic;  --comparator
		C,Z      : out std_logic;  --carry,zero
		pe_done  : out std_logic;  --multiple load,store done
		op_code  : out std_logic_vector(3 downto 0);  --first 4 bits of IR which is op_code

		clk,reset: in std_logic
	    );
end entity;

architecture behave of datapath is
	signal mem_a,mem_d,mem_out   : std_logic_vector(15 downto 0);
	
	
	signal D1,D2,D3,R7    : std_logic_vector(15 downto 0);	
	signal A1,A3,A2          : std_logic_vector(2 downto 0);
	signal ir              : std_logic_vector(15 downto 0);
	
	signal T1,T2,T3,m_t3_out,pc,m_pc_out,m_t1_out,m_t2_out,m_t2_0_out : std_logic_vector(15 downto 0);
   	
	
	signal alua,alub,alu_out ,ls7,ls1: std_logic_vector(15 downto 0);
	signal pe_out2          : std_logic_vector(2 downto 0);
	signal pe_out1          : std_logic_vector(7 downto 0);
	
	
	signal se6_out,se9_out : std_logic_vector(15 downto 0);
	signal less,greater    : std_logic; 
	signal z_0,z_1         : std_logic;
	signal cin,Zin       : std_logic;
	signal ir_low,tc,m_tc_out          : std_logic_vector(7 downto 0);
	

begin
	condition_code <= ir(1 downto 0);
-------------------------------------------------------------------------------------------------------
	RAM: memory
		port map(mem_a => mem_a, mem_d => mem_d, mem_out => mem_out, clk => clk, wr_mem => wr_mem, rd_mem => rd_mem);
------------------------------------------
	Inst_reg: instruction_register
		port map(din => mem_out, en_ir => en_ir, 
			 reset => reset, clk => clk, dout => ir);
	op_code <= ir(15 downto 12);     --to control path for instruction decoder
--------------------------------------------
	mux_tc: mux_2to1_nbits
		generic map(8)
		port map(s0 => m_tc, input0 => pe_out1, input1 => ir(7 downto 0), output => m_tc_out);
--------------------------------------------
	mux_a1: mux_2to1_nbits
		generic map(3)
		port map(s0 => m_a1, input0 => pe_out2 , input1 => ir(8 downto 6), output => A1);
	mux_a2: mux_2to1_nbits
		generic map(3)
		port map(s0 => m_a2, input0 => ir(8 downto 6) , input1 => ir(5 downto 3) , output => A2);
--------------------------------------------
	mux_a3: mux_4to1_nbits
		generic map(3)
		port map(s0 => m_a30, s1 => m_a31,
		         input0 => pe_out2, input1 => ir(11 downto 9), input2 => "111", input3 => "000",output => A3);
--------------------------------------------
	mux_d3: mux_4to1_nbits
		generic map(16)
		port map(s0 => m_d30, s1 => m_d31,
		         input0 => pc, input1 => T3, input2 => ls7,input3 => T1, output => D3);
--------------------------------------------
	mux_t1: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_t1,
		         input0 =>mem_out, input1 => D1, output => m_t1_out);
--------------------------------------------
	mux_t2: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_t2, input0 => D1, input1 => D2, output => m_t2_out);
--------------------------------------------
	mux_alua: mux_4to1_nbits
		generic map(16)
		port map(s0 => m_alua0, s1 => m_alua1, input0 => R7, input1 => T3, input2 => T1, input3 => T2,output => alua);
--------------------------------------------
  mux_t2_0: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_t2_0, input0 => ls1, input1 => T2, output => m_t2_0_out);
	mux_alub: mux_4to1_nbits
		generic map(16)
		port map(s0 => m_alub0, s1 => m_alub1 ,input0 => se6_out, input1 => se9_out, input2 =>m_t2_0_out , input3 => "0000000000000001", output => alub);
--------------------------------------------
	mux_t3: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_t3,
		         input0 => D2, input1 => alu_out, output => m_t3_out);
--------------------------------------------
	
--------------------------------------------
	
--------------------------------------------
	mux_mem_a: mux_2to1_nbits
		generic map(16)
		port map(s0 => m_mema,  input0 => R7, input1 => T3,output => mem_a);
--------------------------------------------
	shifter7: left7_shifter
		generic map(input_width => 9, output_width => 16)
		port map (input => ir(8 downto 0), output => ls7);
--------------------------------------------
	se6: sign_extend6
		generic map(input_width => 6, output_width => 16)
		port map (input => ir(5 downto 0), output => se6_out);
--------------------------------------------
	se9: sign_extend9
		generic map(input_width => 9, output_width => 16)
		port map (input => ir(8 downto 0), output => se9_out);
--------------------------------------------
   shifter1: left1_shifter
		generic map(input_width => 16, output_width => 16)
		port map (input => T2, output => ls1);
--------------------------------------------
	regt1: dregister
		generic map(16)
		port map(reset => reset, din => m_t1_out, dout => t1, enable => en_t1, clk => clk);
	regt2: dregister
		generic map(16)
		port map(reset => reset, din => m_t2_out, dout => t2, enable => en_t2, clk => clk);
	regt3: dregister
		generic map(16)
		port map(reset => reset, din => m_t3_out, dout => t3, enable => en_t3, clk => clk);
	regtpc: dregister
		generic map(16)
		port map(reset => reset, din => m_pc_out, dout => pc, enable => en_pc, clk => clk);
	regtc: dregister8
		generic map(8)
		port map(reset => reset, din => m_tc_out, dout => tc, enable => en_tc, clk => clk);
	nanding: nor_box
		generic map(16)
		port map(input => mem_out, output => z_1);
--------------------------------------------
	compare: unsigned_comparator
		generic map(16)
		port map(a => T1, b => T2, a_lt_b => less, a_eq_b => equ, a_gt_b => greater);
--------------------------------------------
carryFF: dflipflop
		port map(reset => reset, din => cin, dout => C, enable => en_c, clk => clk);
mux_z: mux_2to1
		port map(s => m_z, input0 => z_0, input1 => z_1, output => zin);
--------------------------------------------
	zeroFF: dflipflop
		port map(reset => reset, din => zin, dout => Z, enable => en_z, clk => clk);
--------------------------------------------
	alu_unit: alu
		port map(inp1 => alua, inp2 => alub, op_sel => op_sel, output => alu_out, c => cin, z => Z_0);
--------------------------------------------
	RF: register_file
		port map(d1 => D1, d2 => D2,R7 => R7, d3 => D3, write_en => wr_rf, read_en => '1', reset => reset,
			 a1 => A1, a2 => ir(11 downto 9), a3 => A3, clk => clk);
--------------------------------------------
	pe: PriorityEncoder
		port map(input => tc, output1f => pe_out1, output2 => pe_out2, invalid => pe_done);
--------------------------------------------

--------------------------------------------
end behave;
		 
		 




