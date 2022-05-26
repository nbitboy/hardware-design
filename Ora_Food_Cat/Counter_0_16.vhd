----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:26:09 05/22/2022 
-- Design Name: 
-- Module Name:    Counter_0_16 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter_0_16 is
    Port ( CLK : in  STD_LOGIC;
           R : in  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (4 downto 0);
           TC : out  STD_LOGIC);
end Counter_0_16;

architecture Behavioral of Counter_0_16 is
	signal count : integer range 0 to 16 := 0;
	signal C : std_logic := '0';
begin

process(CLK, R)
begin
	if(R = '1') then
		count <= 0;
		C <= '0';
	elsif (rising_edge(CLK)) then
		count <= count + 1;
		if(count = 16) then
			C <= '1';
		else
			C <= '0';
		end if;
	end if;
end process;

S <= std_logic_vector(to_unsigned(count, 5));
TC <= C;

end Behavioral;

