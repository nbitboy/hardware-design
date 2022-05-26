----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:56:20 05/22/2022 
-- Design Name: 
-- Module Name:    UART_Receiver - Behavioral 
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

entity UART_Receiver is
	Port ( RX: in STD_LOGIC;
	       RE: in STD_LOGIC;
	       CLK: in STD_LOGIC;
			 UOUT: out STD_LOGIC_VECTOR (1 downto 0);
			 LOG: out STD_LOGIC_VECTOR (7 downto 0);
			 TRIGGER: out STD_LOGIC);
end UART_Receiver;

architecture Behavioral of UART_Receiver is
component T_FLIPFLOP
	Port ( CLK: in STD_LOGIC;
	       R: in STD_LOGIC;
			 Q: out STD_LOGIC;
			 NOTQ: out STD_LOGIC);
end component;
component Counter_0_7
	Port ( CLK: in STD_LOGIC;
	       R: in STD_LOGIC;
			 S: out STD_LOGIC_VECTOR (2 downto 0);
			 TC: out STD_LOGIC);
end component;
component Counter_0_15
	Port ( CLK: in STD_LOGIC;
	       R: in STD_LOGIC;
			 S: out STD_LOGIC_VECTOR (3 downto 0);
			 TC: out STD_LOGIC);
end component;
component DIV20M_160K
	Port ( CLK_IN: in STD_LOGIC;
	       CLK_OUT: out STD_LOGIC);
end component;
signal TFFCLK: std_logic;
signal TFFNOTQ: std_logic := '1';
signal TFFQ_SCTCLK: std_logic := '0';
signal TFFR_C72TC_TRIGGER_C15RESETENR : std_logic := '0';
signal DIVOUT: std_logic := '0';
signal SCTQ: std_logic := '0';
signal C71CLK_C15CLK: std_logic := '0';
signal C71S : std_logic_vector (2 downto 0):= "000";
signal C71TC : std_logic := '0';
signal C15R: std_logic := '0';
signal C15S: std_logic_vector (3 downto 0) := "0000";
signal C15TC_SRGCLK_C72CLK : std_logic := '0';
signal C72S: std_logic_vector (2 downto 0) := "000";
signal C72R: std_logic := '0';
signal C15RESETEN: std_logic := '1';
signal SRGDATA: std_logic_vector(7 downto 0) := "00000000";

signal tmp: std_logic := '0';
begin
	--LOG(7) <= RX;
	TFFCLK <= RX and TFFNOTQ;
	TFF: T_FLIPFLOP port map ( CLK => TFFCLK, R => TFFR_C72TC_TRIGGER_C15RESETENR, Q => TFFQ_SCTCLK, NOTQ => TFFNOTQ);
	DIV: DIV20M_160K port map ( CLK_IN => CLK, CLK_OUT => DIVOUT);
	--LOG(6) <= TFFQ_SCTCLK;
	process (TFFQ_SCTCLK)
	begin
		if (rising_edge(TFFQ_SCTCLK)) then
			SCTQ <= '1';
		end if;
		SCTQ <= '0';
	end process;
	C71CLK_C15CLK <= DIVOUT and TFFQ_SCTCLK;
	C71 : Counter_0_7 port map ( CLK => C71CLK_C15CLK, R => SCTQ, S => C71S, TC => C71TC);
	process (C71TC, TFFR_C72TC_TRIGGER_C15RESETENR)
	begin
		if(TFFR_C72TC_TRIGGER_C15RESETENR = '1') then
			C15RESETEN <= '1';
		elsif(rising_edge(C71TC)) then
			C15RESETEN <= '0';
		end if;
	end process;
	C15R <= SCTQ or (C71TC and C15RESETEN);
	C15: Counter_0_15 port map ( CLK => C71CLK_C15CLK, R => C15R, S => C15S, TC => C15TC_SRGCLK_C72CLK);
	C72R <= SCTQ or TFFR_C72TC_TRIGGER_C15RESETENR;
	C72: Counter_0_7 port map ( CLK => C15TC_SRGCLK_C72CLK, R => C72R, S => C72S, TC => TFFR_C72TC_TRIGGER_C15RESETENR);
	process (C15TC_SRGCLK_C72CLK, RE)
	begin
		if(RE = '1') then
			SRGDATA <= "00000000";
		elsif (rising_edge(C15TC_SRGCLK_C72CLK)) then
			SRGDATA <= RX&SRGDATA(7 downto 1);
			tmp <= not tmp;
		end if;
	end process;

	UOUT <= SRGDATA(4) & SRGDATA(1);
	TRIGGER <= TFFR_C72TC_TRIGGER_C15RESETENR;
	--LOG(5 downto 0) <= "000000";
	--LOG <= SRGDATA;

end Behavioral;

