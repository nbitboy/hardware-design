----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:21:48 05/23/2022 
-- Design Name: 
-- Module Name:    UART_Transmitter - Behavioral 
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

entity UART_Transmitter is
    Port ( DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           CLK : in  STD_LOGIC;
           EN : in  STD_LOGIC;
           TX : out  STD_LOGIC;
			  LOG: out STD_LOGIC; -- debug
			  SOUT : out std_logic_vector(3 downto 0)); --debug
end UART_Transmitter;

architecture Behavioral of UART_Transmitter is
component D_FLIPFLOP
	Port ( D: in STD_LOGIC;
	       CLK: in STD_LOGIC;
			 R: in STD_LOGIC;
			 Q: out STD_LOGIC);
end component;
component DIV20M_80K
	Port ( CLK_IN: in STD_LOGIC;
	       CLK_OUT: out STD_LOGIC);
end component;
component Counter_0_10
	Port ( CLK: in STD_LOGIC;
	       R: in STD_LOGIC;
			 S: out STD_LOGIC_VECTOR(3 downto 0);
			 TC: out STD_LOGIC);
end component;
component Counter_0_9
    Port ( CLK : in  STD_LOGIC;
           R : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (3 downto 0);
           TC : out  STD_LOGIC);
end component;
component Counter_0_7
    Port ( CLK : in  STD_LOGIC;
           R : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (2 downto 0);
           TC : out  STD_LOGIC);
end component;

signal DIVOUT: std_logic := '0';
signal DFFQ: std_logic := '0';
signal DIVOUTANDDFFQ_C7CLK: std_logic := '0';
signal C10TC_C7R_C10R_C9R_DFFR: std_logic := '0';
signal C7S: std_logic_vector(2 downto 0) := "000";
signal C10S: std_logic_vector(3 downto 0) := "0000";
signal C9S: std_logic_vector(3 downto 0) := "0000";
signal C9TC: std_logic := '0';
signal C7TC_C10CLK_C9CLK: std_logic := '0';

constant DFFD: std_logic := '1';
begin
	DIV: DIV20M_80K port map (CLK_IN => CLK, CLK_OUT => DIVOUT);
	DFF: D_FLIPFLOP port map (D => DFFD, CLK => EN, R => C10TC_C7R_C10R_C9R_DFFR, Q => DFFQ);
	DIVOUTANDDFFQ_C7CLK <= DIVOUT and DFFQ;
	C7: Counter_0_7 port map ( CLK => DIVOUTANDDFFQ_C7CLK, R => C10TC_C7R_C10R_C9R_DFFR, S => C7S, TC => C7TC_C10CLK_C9CLK);
	C10: Counter_0_10 port map ( CLK => C7TC_C10CLK_C9CLK, R => C10TC_C7R_C10R_C9R_DFFR, S => C10S, TC => C10TC_C7R_C10R_C9R_DFFR);
	C9: Counter_0_9 port map ( CLK => C7TC_C10CLK_C9CLK, R => C10TC_C7R_C10R_C9R_DFFR, S => C9S, TC => C9TC);
	
	with C9S select TX <= '1' when "0000",
	                      '0' when "0001",
								 DATA(0) when "0010",
								 DATA(1) when "0011",
								 DATA(2) when "0100",
								 DATA(3) when "0101",
								 DATA(4) when "0110",
								 DATA(5) when "0111",
								 DATA(6) when "1000",
								 DATA(7) when "1001",
								 '1' when others;
	LOG <= DFFQ; -- debug
	SOUT <= C9S; -- debug
end Behavioral;

