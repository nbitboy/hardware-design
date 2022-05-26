----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:26:54 05/23/2022 
-- Design Name: 
-- Module Name:    Input_Controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Input_Controller is
	Port ( UIN: in STD_LOGIC_VECTOR(1 downto 0);
	       BTIN: in STD_LOGIC_VECTOR(1 downto 0);
			 ENU: in STD_LOGIC;
			 ENBT: in STD_LOGIC;
			 RE: in STD_LOGIC;
			 CLK: in STD_LOGIC;
			 ICOUT: out STD_LOGIC_VECTOR(1 downto 0);
			 TRIGGER: out STD_LOGIC);
end Input_Controller;

architecture Behavioral of Input_Controller is
component Encoder_4_2
	Port ( EIN: in std_logic_vector(3 downto 0);
	       EOUT: out std_logic_vector(1 downto 0));
end component;
component T_FLIPFLOP
	Port ( CLK: in STD_LOGIC;
	       R: in STD_LOGIC;
			 Q: out STD_LOGIC;
			 NOTQ: out STD_LOGIC);
end component;
component D_FLIPFLOP
    Port( D : in  STD_LOGIC;
          CLK : in  STD_LOGIC;
          R : in  STD_LOGIC;
          Q : out  STD_LOGIC);
end component;
component Counter_0_7
	Port ( CLK: in STD_LOGIC;
	       R: in STD_LOGIC;
			 S: out STD_LOGIC_VECTOR (2 downto 0);
			 TC: out STD_LOGIC);
end component;
component DIV20M_160K
	Port ( CLK_IN: in STD_LOGIC;
	       CLK_OUT: out STD_LOGIC);
end component;

signal TFFCLK_TFFNOTQAND_ENUORENBT: std_logic;
signal TFFNOTQ : std_logic := '1';
signal TFFQ_DFF123CLK: std_logic := '0';
signal DFF1D_UIN0ORBTIN0: std_logic := '0';
signal DFF2D_UIN1ORBIIN1: std_logic := '0';
signal DFF3Q_DFF3R_TRIG: std_logic;
signal SRGCOM: std_logic_vector(1 downto 0) := "00";

signal DIVOUT: std_logic;
signal C7CLK: std_logic;
signal C7TC: std_logic;
signal C7S: std_logic_vector(2 downto 0) := "000";

begin
	

	TFFCLK_TFFNOTQAND_ENUORENBT <= (ENU or ENBT) and TFFNOTQ;
	TFF: T_FLIPFLOP port map ( CLK => TFFCLK_TFFNOTQAND_ENUORENBT, R => RE, Q => TFFQ_DFF123CLK, NOTQ => TFFNOTQ);
	DFF1D_UIN0ORBTIN0 <= UIN(0) or BTIN(0);
	DFF2D_UIN1ORBIIN1 <= UIN(1) or BTIN(1);
	process (TFFQ_DFF123CLK, C7TC)
	begin
		if(C7TC = '1') then
			DFF3Q_DFF3R_TRIG <= '0';
		elsif(rising_edge(TFFQ_DFF123CLK)) then
			SRGCOM(0) <= DFF1D_UIN0ORBTIN0;
			SRGCOM(1) <= DFF2D_UIN1ORBIIN1;
			DFF3Q_DFF3R_TRIG <= '1';
		end if;
	end process;
	
	-- test
	DIV: DIV20M_160K port map ( CLK_IN => CLK, CLK_OUT => DIVOUT);
	C7CLK <= DFF3Q_DFF3R_TRIG and DIVOUT;
	C72: Counter_0_7 port map ( CLK => C7CLK, R => C7TC, S => C7S, TC => C7TC);
	
	ICOUT <= SRGCOM;
	TRIGGER <= C7TC;
	
end Behavioral;

