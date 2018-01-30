
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity motor is
port(     clk : in std_logic;
        start : in std_logic;
	   	   s : in std_logic;
	motor_data : out std_logic_vector(3 downto 0)
     );
end motor;

architecture Behavioral of motor is

signal m_cnt : integer range 0 to 7;


begin


process(clk)
begin
if clk'event and clk='1' then
	   case m_cnt is
        when 0 => motor_data <= "0001";		
        when 1 => motor_data <= "0011";		  
        when 2 => motor_data <= "0010";
		  when 3 => motor_data <= "0110";
		  when 4 => motor_data <= "0100";
		  when 5 => motor_data <= "1100";
		  when 6 => motor_data <= "1000";
        when others => motor_data <= "1001";				  
	   end case;	  
	   if start = '1' then
		  m_cnt <= m_cnt + 1;
		end if;
	  end if;
end process;
		
end Behavioral;

