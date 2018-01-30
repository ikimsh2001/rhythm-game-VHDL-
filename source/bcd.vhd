library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bcd is
port( bcd: in std_logic_vector(3 downto 0);
		seg_d: out std_logic_vector(7 downto 0));
		
end bcd;

architecture Behavioral of bcd is

begin
process(bcd)
begin
		case bcd is
			when "0000" => seg_d <= "11111100";
			when "0001" => seg_d <= "01100000";
			when "0010" => seg_d <= "11011010";
			when "0011" => seg_d <= "11110010";
			when "0100" => seg_d <= "01100110";
			when "0101" => seg_d <= "10110110";
			when "0110" => seg_d <= "00111110";
			when "0111" => seg_d <= "11100000";
			when "1000" => seg_d <= "11111110";
			when "1001" => seg_d <= "11100110";
			when "1111" => seg_d <= "00010000";
			when others => seg_d <= "00000000";
		end case;
	end process;
end Behavioral;


