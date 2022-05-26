----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:56:17 05/24/2022 
-- Design Name: 
-- Module Name:    Command_Handler - Behavioral 
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

entity Command_Handler is
	Port ( CIN: in STD_LOGIC_VECTOR(1 downto 0);
	       RDY: in STD_LOGIC_VECTOR(3 downto 0);
			 STA: in STD_LOGIC;
			 EN: in STD_LOGIC;
			 FNH: in STD_LOGIC;
			 RES: out STD_LOGIC_VECTOR(7 downto 0);
			 CSEL: out STD_LOGIC_VECTOR(1 downto 0);
			 CT: out STD_LOGIC;
			 SEND: out STD_LOGIC);
end Command_Handler;

architecture Behavioral of Command_Handler is
	signal RDY_OPEN_SERVO: std_logic;
	signal SOPENSERVO: std_logic_vector(6 downto 0);
	signal PRES: std_logic_vector(6 downto 0);
	signal LBIT: std_logic;
	signal I1: std_logic := '0';
	signal I2: std_logic := '0';
	
	signal SELRDY: std_logic;
	
	constant OCCUPYRES: std_logic_vector(6 downto 0) := "0010110";
	constant OPENMODE: std_logic_vector(6 downto 0) := "0010100";
	
	constant FOOD1MODE: std_logic_vector(6 downto 0) := "0100101";
	constant FOOD2MODE: std_logic_vector(6 downto 0) := "0101010";
	constant MIXMODE: std_logic_vector(6 downto 0) := "0101101";
	
begin
	with CIN select
		SELRDY <= RDY(0) when "00",
		          RDY(1) when "01",
					 RDY(2) when "10",
					 RDY(3) when "11";

	I1 <= (not CIN(0)) and (not CIN(1));
	RDY_OPEN_SERVO <= I1 and SELRDY;
	
	with RDY_OPEN_SERVO select
		SOPENSERVO <= OPENMODE when '1',
		              OCCUPYRES when others;
	
	with CIN select
		PRES <= SOPENSERVO when "00",
		        FOOD1MODE when "01",
				  FOOD2MODE when "10",
				  MIXMODE when "11";
	
	I2 <= CIN(0) or CIN(1);
	
	with I2 select
		LBIT <= STA when '0',
		        SELRDY when '1';
				  
	RES(7 downto 1) <= PRES;
	RES(0) <= LBIT;
	
	CSEL <= CIN;
	CT <= EN;
	SEND <= EN or FNH;
end Behavioral;

