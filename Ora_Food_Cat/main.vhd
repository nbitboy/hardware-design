----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:25:11 05/23/2022 
-- Design Name: 
-- Module Name:    main - Behavioral 
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

entity main is
	Port ( RX: in STD_LOGIC;
	       CLK: in STD_LOGIC;
			 BTIN: in STD_LOGIC_VECTOR(3 downto 0);
			 RDY: in STD_LOGIC_VECTOR(3 downto 0);
			 STA: in STD_LOGIC;
			 FNH: in STD_LOGIC;
			 TX: out STD_LOGIC;
			 MODE: out STD_LOGIC_VECTOR(3 downto 0);
			 LOG: out STD_LOGIC_VECTOR(7 downto 0));
end main;

architecture Behavioral of main is
component UART_Receiver
	Port ( RX: in STD_LOGIC;
	       RE: in STD_LOGIC;
	       CLK: in STD_LOGIC;
			 UOUT: out STD_LOGIC_VECTOR(1 downto 0);
			 TRIGGER: out STD_LOGIC;
			 LOG: out STD_LOGIC_VECTOR(7 downto 0));
end component;
component Button_Input
	Port ( BTIN: in std_logic_vector(3 downto 0);
	       CLK: in std_logic;
	       BTOUT: out std_logic_vector(1 downto 0);
			 LOG: out std_logic_vector(4 downto 0);
	       TRIGGER: out std_logic);
end component;
component Input_Controller
	Port ( UIN: in STD_LOGIC_VECTOR(1 downto 0);
	       BTIN: in STD_LOGIC_VECTOR(1 downto 0);
			 ENU: in STD_LOGIC;
			 ENBT: in STD_LOGIC;
			 RE: in STD_LOGIC;
			 CLK: in STD_LOGIC;
			 ICOUT: out STD_LOGIC_VECTOR(1 downto 0);
			 TRIGGER: out STD_LOGIC);
end component;
component Command_Handler
	Port ( CIN: in STD_LOGIC_VECTOR(1 downto 0);
	       RDY: in STD_LOGIC_VECTOR(3 downto 0);
			 STA: in STD_LOGIC;
			 EN: in STD_LOGIC;
			 FNH: in STD_LOGIC;
			 RES: out STD_LOGIC_VECTOR(7 downto 0);
			 CSEL: out STD_LOGIC_VECTOR(1 downto 0);
			 CT: out STD_LOGIC;
			 SEND: out STD_LOGIC);
end component;
component UART_Transmitter
	Port ( DATA: in  STD_LOGIC_VECTOR (7 downto 0);
		    CLK: in  STD_LOGIC;
		    EN: in  STD_LOGIC;
		    TX: out  STD_LOGIC;
			 LOG: out STD_LOGIC; -- debug
		    SOUT: out std_logic_vector(3 downto 0)); -- debug
end component;
component Servo_Controller
	Port ( SEL: in STD_LOGIC_VECTOR(1 downto 0);
	       EN: in STD_LOGIC;
			 CLK: in STD_LOGIC;
			 MODE: out STD_LOGIC_VECTOR(3 downto 0));
end component;

---------------- UART Reciver ----------------
signal UROUT: std_logic_vector(1 downto 0);
signal URTRIGGER: std_logic := '0';
---------------- Button Input ----------------
signal BTOUT: std_logic_vector(1 downto 0);
signal BTTRIGGER: std_logic := '0';
signal BTLOG: std_logic_vector(4 downto 0) := "00000";
-------------- Input Controller --------------
signal ICTRIGGER: std_logic;
signal ICOUT: std_logic_vector(1 downto 0);
-------------- UART Transmitter --------------
signal CMRES: std_logic_vector(7 downto 0);
signal CMSEND: std_logic;
signal testTX: std_logic;
signal CLOG: std_logic; -- debug
signal SLED: std_logic_vector(3 downto 0); -- debug
-------------- Command Handler --------------
signal CRES: std_logic_vector(7 downto 0);
signal CSEND: std_logic;
signal CSEL: std_logic_vector(1 downto 0);
signal CT: std_logic;
-------------- Servo Controller --------------
signal SCMODE: std_logic_vector(3 downto 0); -- debug

begin
	UR: UART_Receiver port map ( RX => RX, RE => FNH, CLK => CLK, UOUT => UROUT, TRIGGER => URTRIGGER);
	BN: Button_Input port map ( BTIN => BTIN, CLK => CLK, BTOUT => BTOUT, LOG => BTLOG, TRIGGER => BTTRIGGER);
	IC: Input_Controller port map ( UIN => UROUT, BTIN => BTOUT, ENU => URTRIGGER, ENBT => BTTRIGGER, RE => FNH, CLK => CLK, ICOUT => ICOUT, TRIGGER => ICTRIGGER);
	CM: Command_Handler port map ( CIN => ICOUT, RDY => RDY, STA => STA, EN => ICTRIGGER, FNH => FNH, RES => CRES, SEND => CSEND, CSEL => CSEL, CT => CT);
	UT: UART_Transmitter port map ( DATA => CRES, CLK => CLK, EN => CSEND, TX => TX, LOG => CLOG, SOUT => SLED);
	SC: Servo_Controller port map ( SEL => CSEL, EN => CT, CLK => CLK, MODE => SCMODE);
	LOG(3 downto 2) <= "00";
	LOG(1 downto 0) <= ICOUT;
	LOG(7 downto 4) <= SCMODE;
	MODE <= SCMODE;
	--LOG(3 downto 2) <= BTOUT;

end Behavioral;

