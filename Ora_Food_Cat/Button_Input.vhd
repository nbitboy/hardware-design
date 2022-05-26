----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:02:50 05/23/2022 
-- Design Name: 
-- Module Name:    Button_Input - Behavioral 
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

entity Button_Input is
	Port ( BTIN: in std_logic_vector(3 downto 0);
	       CLK: in std_logic;
	       BTOUT: out std_logic_vector(1 downto 0);
			 LOG: out std_logic_vector(4 downto 0);
	       TRIGGER: out std_logic);
end Button_Input;

architecture Behavioral of Button_Input is
component Encoder_4_2
	Port ( EIN: in std_logic_vector(3 downto 0);
	       EOUT: out std_logic_vector(1 downto 0));
end component;
component DIV20M_1K
	Port ( CLK_IN : in  STD_LOGIC;
		    CLK_OUT : out  STD_LOGIC);
end component;
component Counter_0_20
    Port ( CLK : in  STD_LOGIC;
           R : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (4 downto 0);
           TC : out  STD_LOGIC);
end component;
component T_FLIPFLOP
	Port ( CLK: in STD_LOGIC;
	       R: in STD_LOGIC;
			 Q: out STD_LOGIC;
			 NOTQ: out STD_LOGIC);
end component;

signal TFFCLK: std_logic;
signal TFFNOTQ: std_logic := '1';
signal TFFQ: std_logic := '0';
signal DIVOUT: std_logic;
signal C20CLK: std_logic;
signal C20R: std_logic := '0';
signal C20S: std_logic_vector(4 downto 0) := "00000";
signal C20TC_TRIG_TFFR: std_logic := '0';
signal BTIN0ORBTIN1_OR_BTIN2ORBTIN3: std_logic := '0';

--signal SRGBT: std_logic_vector(1 downto 0) := "00";

begin
	ENC: Encoder_4_2 port map ( EIN => BTIN, EOUT => BTOUT);
	DIV: DIV20M_1K port map (CLK_IN => CLK, CLK_OUT => DIVOUT);
	BTIN0ORBTIN1_OR_BTIN2ORBTIN3 <= ((BTIN(0) or BTIN(1)) or (BTIN(2) or BTIN(3)));
	TFFCLK <= not(BTIN0ORBTIN1_OR_BTIN2ORBTIN3 or TFFQ);
	TFF: T_FLIPFLOP port map ( CLK => TFFCLK, R => C20TC_TRIG_TFFR, Q => TFFQ, NOTQ => TFFNOTQ);
	C20CLK <= TFFQ and DIVOUT;
	C20: Counter_0_20 port map (CLK => C20CLK, R => C20TC_TRIG_TFFR, S => C20S, TC => C20TC_TRIG_TFFR);
	TRIGGER <= C20TC_TRIG_TFFR;
	
end Behavioral;

