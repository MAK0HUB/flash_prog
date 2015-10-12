library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fppOvj is 
        port (
              -- inputs:
                 signal system_clk : in std_logic;
                 signal reset_n : in std_logic;
              
              
                 signal fpga_nstatus : IN STD_LOGIC;
                 
              -- outputs:
				signal data_out_port : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
				signal clk_out_port : out std_logic;
				signal nConfig_out_port : out std_logic
              );
end entity fppOvj;


architecture rtl of fppOvj is
	component vj_config  PORT(
		ir_out		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		tdo		: IN STD_LOGIC ;
		ir_in		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		tck		: OUT STD_LOGIC ;
		tdi		: OUT STD_LOGIC ;
		virtual_state_cdr		: OUT STD_LOGIC ;
		virtual_state_cir		: OUT STD_LOGIC ;
		virtual_state_e1dr		: OUT STD_LOGIC ;
		virtual_state_e2dr		: OUT STD_LOGIC ;
		virtual_state_pdr		: OUT STD_LOGIC ;
		virtual_state_sdr		: OUT STD_LOGIC ;
		virtual_state_udr		: OUT STD_LOGIC ;
		virtual_state_uir		: OUT STD_LOGIC 
	);
	end component;

	component vj_decode  port (
	  -- inputs:
		 signal clk : IN STD_LOGIC;
		 signal data_in : IN STD_LOGIC;
		 signal ir_in : IN std_logic_vector(2 downto 0);
		 signal cdr_in : IN STD_LOGIC;
		 signal sdr_in : IN STD_LOGIC;
		 signal e1dr : in std_logic;
		 
		 signal system_clk : in std_logic;
		 signal reset_n : in std_logic;

	  -- outputs:
		signal data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		signal clk_out : out std_logic;
		signal clk_int_out : out std_logic;
		signal nConfig_test : out std_logic;
		signal decode_reset : out std_logic;
		signal decode_sel : out std_logic
	  );
	end component;

	component srle_decode port (
	  -- inputs:
		 signal clk_in : IN STD_LOGIC;
		 signal data_in : IN STD_LOGIC_vector(7 downto 0);
		 signal ir_in : IN std_logic_vector(2 downto 0);
		 
		 signal clk : in std_logic;
		 signal reset_n : in std_logic;
		 signal clk_pls : in std_logic;
		 signal decode_reset : in std_logic;
		 

	  -- outputs:
		signal data_out : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		signal clk_out : out std_logic
	  );
	end component;

	signal rbf_data : std_logic_vector(7 downto 0);
	signal rbf_clk : std_logic;
	signal srle_data : std_logic_vector(7 downto 0);
	signal srle_clk : std_logic;
	signal decode_sel : std_logic;
	signal clk_pls : std_logic;
	signal decode_reset : std_logic;
	signal ir_in : std_logic_vector(2 downto 0);
	signal tdo : std_logic;
	signal tck : std_logic;
	signal tdi : std_logic;
	signal cdr : std_logic;
	signal e1dr : std_logic;
	signal sdr : std_logic;
	
begin

	vj_config_inst : vj_config port map(
			ir_out	 => ir_in,
			tdo	 => fpga_nstatus,
			ir_in	 => ir_in,
			tck	 => tck,
			tdi	 => tdi,
			virtual_state_cdr	 => cdr,
			virtual_state_e1dr	 => e1dr,
			virtual_state_sdr	 => sdr
	);

	vj_decode_inst : vj_decode  port map(
		-- input
		clk => tck,
		data_in => tdi,
		ir_in => ir_in,
		cdr_in => cdr,
		sdr_in => sdr,
		e1dr => e1dr,
		system_clk => system_clk,
		reset_n => reset_n,
		--output
		data_out => rbf_data,
		clk_out => rbf_clk,
		clk_int_out => clk_pls,
		nConfig_test => nConfig_out_port,
		decode_reset => decode_reset
	);

	srle_decode_inst : srle_decode port map(
		-- inputs:
		clk_in => rbf_clk,
		data_in => rbf_data,
		ir_in => ir_in,
		clk => system_clk,
		reset_n => reset_n,
		clk_pls => clk_pls,
		decode_reset => decode_reset,
		-- outputs:
		clk_out => clk_out_port,
		data_out => data_out_port
	  );

end rtl;

-- megafunction wizard: %Virtual JTAG%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: sld_virtual_jtag 

-- ============================================================
-- File Name: vj_config.vhd
-- Megafunction Name(s):
-- 			sld_virtual_jtag
--
-- Simulation Library Files(s):
-- 			altera_mf
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 9.0 Build 235 06/17/2009 SP 2 SJ Full Version
-- ************************************************************


--Copyright (C) 1991-2009 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Altera Program License 
--Subscription Agreement, Altera MegaCore Function License 
--Agreement, or other applicable license agreement, including, 
--without limitation, that your use is for the sole purpose of 
--programming logic devices manufactured by Altera and sold by 
--Altera or its authorized distributors.  Please refer to the 
--applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY vj_config IS
	PORT
	(
		ir_out		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		tdo		: IN STD_LOGIC ;
		ir_in		: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
		tck		: OUT STD_LOGIC ;
		tdi		: OUT STD_LOGIC ;
		virtual_state_cdr		: OUT STD_LOGIC ;
		virtual_state_cir		: OUT STD_LOGIC ;
		virtual_state_e1dr		: OUT STD_LOGIC ;
		virtual_state_e2dr		: OUT STD_LOGIC ;
		virtual_state_pdr		: OUT STD_LOGIC ;
		virtual_state_sdr		: OUT STD_LOGIC ;
		virtual_state_udr		: OUT STD_LOGIC ;
		virtual_state_uir		: OUT STD_LOGIC 
	);
END vj_config;


ARCHITECTURE SYN OF vj_config IS

	SIGNAL sub_wire0	: STD_LOGIC ;
	SIGNAL sub_wire1	: STD_LOGIC ;
	SIGNAL sub_wire2	: STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL sub_wire3	: STD_LOGIC ;
	SIGNAL sub_wire4	: STD_LOGIC ;
	SIGNAL sub_wire5	: STD_LOGIC ;
	SIGNAL sub_wire6	: STD_LOGIC ;
	SIGNAL sub_wire7	: STD_LOGIC ;
	SIGNAL sub_wire8	: STD_LOGIC ;
	SIGNAL sub_wire9	: STD_LOGIC ;
	SIGNAL sub_wire10	: STD_LOGIC ;



	COMPONENT sld_virtual_jtag
	GENERIC (
		sld_auto_instance_index		: STRING;
		sld_instance_index		: NATURAL;
		sld_ir_width		: NATURAL;
		sld_sim_action		: STRING;
		sld_sim_n_scan		: NATURAL;
		sld_sim_total_length		: NATURAL;
		lpm_type		: STRING
	);
	PORT (
			tdi	: OUT STD_LOGIC ;
			tck	: OUT STD_LOGIC ;
			ir_in	: OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
			virtual_state_cir	: OUT STD_LOGIC ;
			virtual_state_pdr	: OUT STD_LOGIC ;
			ir_out	: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			virtual_state_uir	: OUT STD_LOGIC ;
			tdo	: IN STD_LOGIC ;
			virtual_state_sdr	: OUT STD_LOGIC ;
			virtual_state_cdr	: OUT STD_LOGIC ;
			virtual_state_udr	: OUT STD_LOGIC ;
			virtual_state_e1dr	: OUT STD_LOGIC ;
			virtual_state_e2dr	: OUT STD_LOGIC 
	);
	END COMPONENT;

BEGIN
	tdi    <= sub_wire0;
	tck    <= sub_wire1;
	ir_in    <= sub_wire2(2 DOWNTO 0);
	virtual_state_cir    <= sub_wire3;
	virtual_state_pdr    <= sub_wire4;
	virtual_state_uir    <= sub_wire5;
	virtual_state_sdr    <= sub_wire6;
	virtual_state_cdr    <= sub_wire7;
	virtual_state_udr    <= sub_wire8;
	virtual_state_e1dr    <= sub_wire9;
	virtual_state_e2dr    <= sub_wire10;

	sld_virtual_jtag_component : sld_virtual_jtag
	GENERIC MAP (
		sld_auto_instance_index => "NO",
		sld_instance_index => 123,
		sld_ir_width => 3,
		sld_sim_action => "",
		sld_sim_n_scan => 0,
		sld_sim_total_length => 0,
		lpm_type => "sld_virtual_jtag"
	)
	PORT MAP (
		ir_out => ir_out,
		tdo => tdo,
		tdi => sub_wire0,
		tck => sub_wire1,
		ir_in => sub_wire2,
		virtual_state_cir => sub_wire3,
		virtual_state_pdr => sub_wire4,
		virtual_state_uir => sub_wire5,
		virtual_state_sdr => sub_wire6,
		virtual_state_cdr => sub_wire7,
		virtual_state_udr => sub_wire8,
		virtual_state_e1dr => sub_wire9,
		virtual_state_e2dr => sub_wire10
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "MAX II"
-- Retrieval info: PRIVATE: show_jtag_state STRING "0"
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: CONSTANT: SLD_AUTO_INSTANCE_INDEX STRING "NO"
-- Retrieval info: CONSTANT: SLD_INSTANCE_INDEX NUMERIC "123"
-- Retrieval info: CONSTANT: SLD_IR_WIDTH NUMERIC "3"
-- Retrieval info: CONSTANT: SLD_SIM_ACTION STRING ""
-- Retrieval info: CONSTANT: SLD_SIM_N_SCAN NUMERIC "0"
-- Retrieval info: CONSTANT: SLD_SIM_TOTAL_LENGTH NUMERIC "0"
-- Retrieval info: USED_PORT: ir_in 0 0 3 0 OUTPUT NODEFVAL "ir_in[2..0]"
-- Retrieval info: USED_PORT: ir_out 0 0 3 0 INPUT NODEFVAL "ir_out[2..0]"
-- Retrieval info: USED_PORT: tck 0 0 0 0 OUTPUT NODEFVAL "tck"
-- Retrieval info: USED_PORT: tdi 0 0 0 0 OUTPUT NODEFVAL "tdi"
-- Retrieval info: USED_PORT: tdo 0 0 0 0 INPUT NODEFVAL "tdo"
-- Retrieval info: USED_PORT: virtual_state_cdr 0 0 0 0 OUTPUT NODEFVAL "virtual_state_cdr"
-- Retrieval info: USED_PORT: virtual_state_cir 0 0 0 0 OUTPUT NODEFVAL "virtual_state_cir"
-- Retrieval info: USED_PORT: virtual_state_e1dr 0 0 0 0 OUTPUT NODEFVAL "virtual_state_e1dr"
-- Retrieval info: USED_PORT: virtual_state_e2dr 0 0 0 0 OUTPUT NODEFVAL "virtual_state_e2dr"
-- Retrieval info: USED_PORT: virtual_state_pdr 0 0 0 0 OUTPUT NODEFVAL "virtual_state_pdr"
-- Retrieval info: USED_PORT: virtual_state_sdr 0 0 0 0 OUTPUT NODEFVAL "virtual_state_sdr"
-- Retrieval info: USED_PORT: virtual_state_udr 0 0 0 0 OUTPUT NODEFVAL "virtual_state_udr"
-- Retrieval info: USED_PORT: virtual_state_uir 0 0 0 0 OUTPUT NODEFVAL "virtual_state_uir"
-- Retrieval info: CONNECT: virtual_state_uir 0 0 0 0 @virtual_state_uir 0 0 0 0
-- Retrieval info: CONNECT: virtual_state_sdr 0 0 0 0 @virtual_state_sdr 0 0 0 0
-- Retrieval info: CONNECT: @ir_out 0 0 3 0 ir_out 0 0 3 0
-- Retrieval info: CONNECT: virtual_state_udr 0 0 0 0 @virtual_state_udr 0 0 0 0
-- Retrieval info: CONNECT: virtual_state_cir 0 0 0 0 @virtual_state_cir 0 0 0 0
-- Retrieval info: CONNECT: ir_in 0 0 3 0 @ir_in 0 0 3 0
-- Retrieval info: CONNECT: @tdo 0 0 0 0 tdo 0 0 0 0
-- Retrieval info: CONNECT: virtual_state_pdr 0 0 0 0 @virtual_state_pdr 0 0 0 0
-- Retrieval info: CONNECT: virtual_state_cdr 0 0 0 0 @virtual_state_cdr 0 0 0 0
-- Retrieval info: CONNECT: virtual_state_e2dr 0 0 0 0 @virtual_state_e2dr 0 0 0 0
-- Retrieval info: CONNECT: virtual_state_e1dr 0 0 0 0 @virtual_state_e1dr 0 0 0 0
-- Retrieval info: CONNECT: tck 0 0 0 0 @tck 0 0 0 0
-- Retrieval info: CONNECT: tdi 0 0 0 0 @tdi 0 0 0 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL vj_config.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL vj_config.inc TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL vj_config.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL vj_config.bsf TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL vj_config_inst.vhd TRUE
-- Retrieval info: LIB_FILE: altera_mf