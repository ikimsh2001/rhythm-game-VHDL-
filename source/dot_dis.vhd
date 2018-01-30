library ieee;
use ieee.std_logic_1164.all;

entity dot_dis is
port (
	clk : in std_logic;
	dot_data_00 : in std_logic_vector (9 downto 0);
	dot_data_01 : in std_logic_vector (9 downto 0);
	dot_data_02 : in std_logic_vector (9 downto 0);
	dot_data_03 : in std_logic_vector (9 downto 0);
	dot_data_04 : in std_logic_vector (9 downto 0);
	dot_data_05 : in std_logic_vector (9 downto 0);
	dot_data_06 : in std_logic_vector (9 downto 0);
	dot_data_07 : in std_logic_vector (9 downto 0);
	dot_data_08 : in std_logic_vector (9 downto 0);
	dot_data_09 : in std_logic_vector (9 downto 0);
	dot_data_10 : in std_logic_vector (9 downto 0);
	dot_data_11 : in std_logic_vector (9 downto 0);
	dot_data_12 : in std_logic_vector (9 downto 0);
	dot_data_13 : in std_logic_vector (9 downto 0);

	dot_d : out std_logic_vector (9 downto 0);
	dot_scan : out std_logic_vector ( 13 downto 0)
);
end dot_dis;

architecture a of dot_dis is
signal cnt_clk : integer range 13 downto 0;
signal cnt		: integer range 0 to 499;
signal clk_d	: std_logic;

begin

process(clk)
begin
if clk'event and clk = '1' then
	if cnt = 499 then
		clk_d <= not clk_d;
		cnt <= 0;
	else
		cnt <= cnt + 1;
	end if;
end if;
end process;

process(clk_d)
begin
	if clk_d'event and clk_d = '1' then
		if cnt_clk = 13 then
			cnt_clk <= 0;
		else
			cnt_clk <= cnt_clk + 1;
		end if;
	end if;
end process;

process(cnt_clk)
begin
	case cnt_clk is
		when 0 =>
			dot_d <= dot_data_00;
			dot_scan <= "00000000000001";	
		when 1 =>
			dot_d <= dot_data_01;
			dot_scan <= "00000000000010";	
		when 2 =>
			dot_d <= dot_data_02;
			dot_scan <= "00000000000100";	
		when 3 =>
			dot_d <= dot_data_03;
			dot_scan <= "00000000001000";	
		when 4 =>
			dot_d <= dot_data_04;
			dot_scan <= "00000000010000";	
		when 5 =>
			dot_d <= dot_data_05;
			dot_scan <= "00000000100000";	
		when 6 =>
			dot_d <= dot_data_06;
			dot_scan <= "00000001000000";	
		when 7 =>
			dot_d <= dot_data_07;
			dot_scan <= "00000010000000";	
		when 8 =>
			dot_d <= dot_data_08;
			dot_scan <= "00000100000000";	
		when 9 =>
			dot_d <= dot_data_09;
			dot_scan <= "00001000000000";	
		when 10 =>
			dot_d <= dot_data_10;
			dot_scan <= "00010000000000";	
		when 11 =>
			dot_d <= dot_data_11;
			dot_scan <= "00100000000000";	
		when 12 =>
			dot_d <= dot_data_12;
			dot_scan <= "01000000000000";	
		when 13 =>
			dot_d <= dot_data_13;
			dot_scan <= "10000000000000";				
	end case;
end process;

end a;


