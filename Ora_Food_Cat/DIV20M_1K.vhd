----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:45:07 05/24/2022 
-- Design Name: 
-- Module Name:    DIV20M_1K - Behavioral 
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

entity DIV20M_1K is
    Port ( CLK_IN : in  STD_LOGIC;
           CLK_OUT : out  STD_LOGIC);
end DIV20M_1K;

architecture Behavioral of DIV20M_1K is
	signal count : integer := 1;
	constant initialCLK : integer := 20000000;
	constant targetCLk : integer := 1000;
	signal tmp : std_logic := '0';
begin

process(CLK_IN)
begin
	if (rising_edge(CLK_IN)) then
		count <= count + 1;
		if(count = (initialCLK / (targetCLK*2))) then
			tmp <= NOT tmp;
			count <= 1;
		end if;
	end if;
end process;

CLK_OUT <= tmp;

end Behavioral;

