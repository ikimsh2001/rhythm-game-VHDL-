library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity kbd is
port ( clk      : in std_logic;
       k_clk    : in std_logic;
       k_data   : in std_logic;
		 sel      : in std_logic;
		 hard     : in std_logic;
		 easy     : in std_logic;
   
	    led1      : out std_logic_vector(7 downto 0);
		 led2      : out std_logic_vector(7 downto 0);
		 s7       : out std_logic_vector(3 downto 0)
		 );
end kbd;

architecture Behavioral of kbd is

constant a : std_logic_vector(7 downto 0) := "00011100";
constant s : std_logic_vector(7 downto 0) := "00011011";
constant d : std_logic_vector(7 downto 0) := "00100011";
constant f : std_logic_vector(7 downto 0) := "00101011";
constant j : std_logic_vector(7 downto 0) := "00111011";
constant k : std_logic_vector(7 downto 0) := "01000010";
constant l : std_logic_vector(7 downto 0) := "01001011";
constant sc : std_logic_vector(7 downto 0) := "01001100";
constant sp : std_logic_vector(7 downto 0) := "00101001";

constant z : std_logic_vector(7 downto 0) := "00000000";


signal kcnt             : integer range 0 to 11;
signal del              : std_logic;
signal data             : std_logic_vector(7 downto 0):="00000000";
signal ary              : std_logic_vector(23 downto 0) :="000000000000000000000000";
signal led1_on, led2_on : std_logic;

begin

process(k_clk)
begin
  if k_clk'event and k_clk = '1' then
     if kcnt = 10 then
        kcnt <= 0;
	  else
        kcnt <= kcnt + 1;
     end if;		  
  end if; 
end process;


process(k_clk)
begin
  if k_clk'event and k_clk = '0' then
     if kcnt > 0 and kcnt < 9 then
	     data(kcnt-1) <= k_data;
     elsif kcnt = 10 then
        if data = "11110000" then
		     del <= '1';
        elsif del = '1' then
	        if data = ary(7 downto 0) then
		        ary(7 downto 0) <= z;
			     del <= '0';
			  elsif data = ary(15 downto 8) then
			     ary(15 downto 8) <= z;
				  del <= '0';
			  elsif data = ary(23 downto 16) then
			     ary(23 downto 16) <= z;
				  del <= '0';
           else
              del <= '0';			  
			  end if;
		  elsif not(data = ary(7 downto 0)) and not(data = ary(15 downto 8)) and not(data = ary(23 downto 16))
		        and (data = a or data = s or data = d or data = f or data = j or data = k or data = l or data = sc or data = sp) then
		     ary(23 downto 16) <= ary(15 downto 8);
			  ary(15 downto 8) <= ary(7 downto 0);
			  ary(7 downto 0) <= data;
		  end if;
	  end if;
  end if;
end process;

-----------------------------------------------------------------------------------------a
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
  if ary(7 downto 0) = a or ary(15 downto 8) = a or ary(23 downto 16) = a then
     led1(0) <= '1';  
  else
     led1(0) <= '0';
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
  led1(0) <= '0';
 end if;
end process;
-----------------------------------------------------------------------------------------s
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
   led2(0) <= '0';
  if ary(7 downto 0) = s or ary(15 downto 8) = s or ary(23 downto 16) = s then
     led1(1) <= '1';  
  else
     led1(1) <= '0';
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
   led1(1) <= '0';
   if ary(7 downto 0) = s or ary(15 downto 8) = s or ary(23 downto 16) = s then
     led2(0) <= '1';  
  else
     led2(0) <= '0';
  end if;
 end if;  
end process;
-----------------------------------------------------------------------------------------d
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
   led2(1) <= '0';
  if ary(7 downto 0) = d or ary(15 downto 8) = d or ary(23 downto 16) = d then
     led1(2) <= '1';  
  else
     led1(2) <= '0';
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
   led1(2) <= '0';
   if ary(7 downto 0) = d or ary(15 downto 8) = d or ary(23 downto 16) = d then
     led2(1) <= '1';  
  else
     led2(1) <= '0';
	end if;
 end if;		  
end process;
-----------------------------------------------------------------------------------------f
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
   led2(2) <= '0';
  if ary(7 downto 0) = f or ary(15 downto 8) = f or ary(23 downto 16) = f then
     led1(3) <= '1';  
  else
     led1(3) <= '0';
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
   led1(3) <= '0';
   if ary(7 downto 0) = f or ary(15 downto 8) = f or ary(23 downto 16) = f then
     led2(2) <= '1';  
  else
     led2(2) <= '0';
	end if;
 end if;	
end process;
-----------------------------------------------------------------------------------------j
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
   led2(5) <= '0';
  if ary(7 downto 0) = j or ary(15 downto 8) = j or ary(23 downto 16) = j then
     led1(4) <= '1';  
  else
     led1(4) <= '0';
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
   led1(4) <= '0';
   if ary(7 downto 0) = j or ary(15 downto 8) = j or ary(23 downto 16) = j then
     led2(5) <= '1';  
  else
     led2(5) <= '0';  
	end if;
 end if;		  
end process;
-----------------------------------------------------------------------------------------k
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
    led2(6) <= '0';
  if ary(7 downto 0) = k or ary(15 downto 8) = k or ary(23 downto 16) = k then
     led1(5) <= '1';  
  else
     led1(5) <= '0';
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
      led1(5) <= '0';
   if ary(7 downto 0) = k or ary(15 downto 8) = k or ary(23 downto 16) = k then
     led2(6) <= '1';  
  else
     led2(6) <= '0';    
	end if;
 end if;		  
end process;
-----------------------------------------------------------------------------------------l
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
   led2(7) <= '0';
  if ary(7 downto 0) = l or ary(15 downto 8) = l or ary(23 downto 16) = l then
     led1(6) <= '1';  
  else
     led1(6) <= '0';
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
    led1(6) <= '0';
   if ary(7 downto 0) = l or ary(15 downto 8) = l or ary(23 downto 16) = l then
     led2(7) <= '1';  
  else
     led2(7) <= '0';   
	 end if;
 end if;	
end process;
-----------------------------------------------------------------------------------------;
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
  if ary(7 downto 0) = sc or ary(15 downto 8) = sc or ary(23 downto 16) = sc then
     led1(7) <= '1';  
  else
     led1(7) <= '0';
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
  led1(7) <= '0';
 end if;
end process;
-----------------------------------------------------------------------------------------;
process(clk)
begin
 if (sel = '1' and easy = '0') or hard = '1' then
  if ary(7 downto 0) = sp or ary(15 downto 8) = sp or ary(23 downto 16) = sp then
     s7 <= "1111";  
  else
     s7 <= "0000";
  end if;
 elsif (sel = '0' and hard = '0') or easy = '1' then
     s7 <= "0000";
 end if;  
end process;


end Behavioral;
