----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:38:58 05/24/2022 
-- Design Name: 
-- Module Name:    Decoder_2_4 - Behavioral 
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

entity Decoder_2_4 is
	Port ( DIN: in std_logic_vector(1 downto 0);
	       DOUT: out std_logic_vector(3 downto 0));
end Decoder_2_4;

architecture Behavioral of Decoder_2_4 is

begin

	process(DIN)
	begin
		if (DIN = "00") then
		DOUT <= "0001";
		elsif (DIN = "01") then
		DOUT <= "0010";
		elsif (DIN = "10") then
		DOUT <= "0100";
		elsif (DIN = "11") then
		DOUT <= "1000";
		else
		DOUT <= "0000";
		end if;
	end process;

end Behavioral;

