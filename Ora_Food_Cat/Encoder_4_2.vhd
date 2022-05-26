----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:31:16 05/23/2022 
-- Design Name: 
-- Module Name:    Encoder_4_2 - Behavioral 
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

entity Encoder_4_2 is
	Port ( EIN: in std_logic_vector(3 downto 0);
	       EOUT: out std_logic_vector(1 downto 0));
end Encoder_4_2;

architecture Behavioral of Encoder_4_2 is

begin

process(EIN)
begin
	if (EIN="0001") then
	EOUT <= "00";
	elsif (EIN="0010") then
	EOUT <= "01";
	elsif (EIN="0100") then
	EOUT <= "10";
	elsif (EIN="1000") then
	EOUT <= "11";
	else
	EOUT <= "00";
	end if;
end process;


end Behavioral;

