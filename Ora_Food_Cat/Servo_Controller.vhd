----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:41:49 05/23/2022 
-- Design Name: 
-- Module Name:    Servo_Controller - Behavioral 
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

entity Servo_Controller is
	Port ( SEL: in STD_LOGIC_VECTOR(1 downto 0);
	       EN: in STD_LOGIC;
			 CLK: in STD_LOGIC;
			 MODE: out STD_LOGIC_VECTOR(3 downto 0));
end Servo_Controller;

architecture Behavioral of Servo_Controller is
component Decoder_2_4
	Port ( DIN: in std_logic_vector(1 downto 0);
	       DOUT: out std_logic_vector(3 downto 0));
end component;
component DIV20M_160K
	Port ( CLK_IN: in STD_LOGIC;
	       CLK_OUT: out STD_LOGIC);
end component;
component Counter_0_7
	Port ( CLK: in STD_LOGIC;
	       R: in STD_LOGIC;
			 S: out STD_LOGIC_VECTOR (2 downto 0);
			 TC: out STD_LOGIC);
end component;

signal DIVOUT: std_logic;
signal DOUT: std_logic_vector(3 downto 0) := "0000";
signal SRGMODE: std_logic_vector(3 downto 0) := "0000";
signal DFFQ: std_logic := '0';
signal C7CLK: std_logic;
signal C7S: std_logic_vector(2 downto 0) := "000";
signal C7TC: std_logic;

begin
	DIV: DIV20M_160K port map ( CLK_IN => CLK, CLK_OUT => DIVOUT);
	DC: Decoder_2_4 port map ( DIN => SEL, DOUT => DOUT);
	process (EN, C7TC)
	begin
		if(C7TC = '1') then
			SRGMODE <= "0000";
			DFFQ <= '0';
		elsif(rising_edge(EN)) then
			SRGMODE <= DOUT;
			DFFQ <= '1';
		end if;
	end process;
	C7CLK <= DFFQ and DIVOUT;
	C72: Counter_0_7 port map ( CLK => C7CLK, R => C7TC, S => C7S, TC => C7TC);

	MODE <= SRGMODE;
	
end Behavioral;

