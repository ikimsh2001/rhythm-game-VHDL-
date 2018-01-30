library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity s7 is
port(clk : in std_logic;
     D1 : in std_logic_vector(3 downto 0);
	  D2 : in std_logic_vector(3 downto 0);
	  o_cnt: in std_logic_vector(3 downto 0);
	  t_cnt: in std_logic_vector(3 downto 0);
	  h_cnt: in std_logic_vector(3 downto 0);
	  seg_d : out std_logic_vector (7 downto 0);
	  com : out std_logic_vector(7 downto 0)
	  );
end s7;

architecture Behavioral of s7 is


component bcd 
port( bcd: in std_logic_vector(3 downto 0);
		     seg_d: out std_logic_vector(7 downto 0)
			  );
	
end component;



signal cnt : integer range 0 to 5;
signal tmp : std_logic_vector(3 downto 0);
signal com_tmp : std_logic_vector (3 downto 0);
signal c   : std_logic;
signal space : std_logic_vector(1 downto 0);
signal freq : std_logic;
signal f_cnt : integer range 0 to 50;
signal hun, ten, one : std_logic;


begin
com <= c & "11" & space & hun & ten & one ;

process(clk)
begin
   if clk'event and clk = '1' then
      if f_cnt = 50 then
		   f_cnt <= 0;
			freq <= not freq;
      else
		   f_cnt <= f_cnt + 1;
      end if;
	end if;
end process;

process(freq)
begin
	   if freq'event and freq = '1' then
		cnt <= cnt + 1;		
      case cnt is
		   when 0 => space <= "11";
			          c <= '0';
						 tmp <= "0010";
						 one <= '1';
						 ten <= '1';
						 hun <= '1';						 
			when 1 => c <= '1'; 
						 one <= '1';
						 ten <= '1';
						 hun <= '1';				
			   if d2 = "0000" then
				   space <= "11";
				else 
               space <= "00";				
				end if;
				   tmp <= D2;
			when 2 => c <= '1';
               space <= "11";
						 one <= '1';
						 ten <= '1';					
			   if h_cnt = "0000" then
				   hun <= '1';
				else 
				   hun <= '0';
				end if;
				   tmp <= h_cnt;
			when 3 => c <= '1';
						 one <= '1';
						 hun <= '1';							 
               space <= "11";
			   if t_cnt = "0000" then
				   if h_cnt > "0000" then
					  ten <= '0';
					else
					  ten <= '1';
				   end if;
			   else
				    ten <= '0';
					
				end if;
				   tmp <= t_cnt;
			when 4 => c <= '1';
						 ten <= '1';
						 hun <= '1';			
               space <= "11";
				   one <= '0';
				   tmp <= o_cnt;	
         when 5 => cnt <= 0;					
	   end case;
	end if;	
end process;

bcd_dec : bcd port map (tmp, seg_d);	
		

end Behavioral;
