-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II 64-Bit"
-- VERSION		"Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Web Edition"
-- CREATED		"Tue Jul 01 01:05:02 2025"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY sistema IS 
	PORT
	(
		BTN_Atender :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		BTN_llamar :  IN  STD_LOGIC;
		SWITCH :  IN  STD_LOGIC_VECTOR(0 TO 3);
		LED_atencion :  OUT  STD_LOGIC;
		ATENCION :  OUT  STD_LOGIC;
		BCD1 :  OUT  STD_LOGIC_VECTOR(0 TO 13);
		BCD2 :  OUT  STD_LOGIC_VECTOR(0 TO 13)
	);
END sistema;

ARCHITECTURE bdf_type OF sistema IS 

COMPONENT bcdselector
	PORT(clk : IN STD_LOGIC;
		 btn_llamar : IN STD_LOGIC;
		 N : IN STD_LOGIC_VECTOR(0 TO 3);
		 btn_llamar_OUT : OUT STD_LOGIC;
		 salida : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg : OUT STD_LOGIC_VECTOR(0 TO 13)
	);
END COMPONENT;

COMPONENT fifo
	PORT(clk : IN STD_LOGIC;
		 btn_llamar : IN STD_LOGIC;
		 btn_atender : IN STD_LOGIC;
		 num_mesa_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 modo_visual : OUT STD_LOGIC;
		 refresh : OUT STD_LOGIC;
		 LED_llamado_out : OUT STD_LOGIC;
		 LED_ATENCION : OUT STD_LOGIC;
		 mesa_actual : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bcdout
	PORT(clk : IN STD_LOGIC;
		 modo_in : IN STD_LOGIC;
		 refresh : IN STD_LOGIC;
		 mesa_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 segmentos : OUT STD_LOGIC_VECTOR(0 TO 13)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(3 DOWNTO 0);


BEGIN 



b2v_inst : bcdselector
PORT MAP(clk => clk,
		 btn_llamar => BTN_llamar,
		 N => SWITCH,
		 btn_llamar_OUT => SYNTHESIZED_WIRE_0,
		 salida => SYNTHESIZED_WIRE_1,
		 seg => BCD1);


b2v_inst1 : fifo
PORT MAP(clk => clk,
		 btn_llamar => SYNTHESIZED_WIRE_0,
		 btn_atender => BTN_Atender,
		 num_mesa_in => SYNTHESIZED_WIRE_1,
		 modo_visual => SYNTHESIZED_WIRE_2,
		 refresh => SYNTHESIZED_WIRE_3,
		 LED_llamado_out => LED_atencion,
		 LED_ATENCION => ATENCION,
		 mesa_actual => SYNTHESIZED_WIRE_4);


b2v_inst3 : bcdout
PORT MAP(clk => clk,
		 modo_in => SYNTHESIZED_WIRE_2,
		 refresh => SYNTHESIZED_WIRE_3,
		 mesa_in => SYNTHESIZED_WIRE_4,
		 segmentos => BCD2);


END bdf_type;