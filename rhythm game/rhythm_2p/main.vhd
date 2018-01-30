
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main is
port ( -----------------------------------------------------ext
       clk       : in std_logic;
		 p1,p2     : in std_logic;
		 rss       : in std_logic;
		 selec     : in std_logic;
		 game_on   : in std_logic;
		 piezo_i   : in std_logic;
		------------------------------------------------------- 
		 player2   : in std_logic;
		 input     : in std_logic;
       m_s       : in std_logic;       
		 k_data    : in std_logic;
		 k_clk     : in std_logic;
		 dot_d     : out std_logic_vector( 9 downto 0);
	    dot_scan  : out std_logic_vector( 13 downto 0);
		 m_data    : out std_logic_vector(3 downto 0);
       s_data    : out std_logic_vector(7 downto 0);
		 s_com     : out std_logic_vector(7 downto 0);
       led       : out std_logic_vector(7 downto 0);		
	    vfd_e     : out std_logic;									--enable.
		 vfd_rs    : out std_logic;									--select.
		 vfd_rw    : out std_logic;									--read/write.
		 vfd_data  : out std_logic_vector(7 downto 0);
		 piezo_o   : out std_logic
		 );
end main;

architecture Behavioral of main is
-----------------------------------------------------------------------------------component (song)
component mario_hard
port (
	clk		: in std_logic;     -- 25MHz
	p1       : in std_logic;
	rss      : in std_logic;
	note_clk : out std_logic;
	d_d      : out std_logic_vector(9 downto 0);
	d_dp     : out std_logic_vector(9 downto 0);
	d_dm     : out std_logic_vector(9 downto 0);		
	reset    : out std_logic;	
	rr       : in std_logic;
   -------------------------------------------------------dot port
	dot_d : out std_logic_vector ( 9 downto 0);
	dot_scan : out std_logic_vector ( 13 downto 0);
	--------------------------------------------------------piezo port
	led : out std_logic
);
end component;
component mario_easy
port (
	clk		: in std_logic;     -- 25MHz
	p1       : in std_logic;
	rss      : in std_logic;
	note_clk : out std_logic;
	d_d      : out std_logic_vector(9 downto 0);
	d_dp     : out std_logic_vector(9 downto 0);
	d_dm     : out std_logic_vector(9 downto 0);		
	reset    : out std_logic;	
	rr       : in std_logic;
   -------------------------------------------------------dot port
	dot_d : out std_logic_vector ( 9 downto 0);
	dot_scan : out std_logic_vector ( 13 downto 0);
	--------------------------------------------------------piezo port
	led : out std_logic
);
end component;

component bubble_hard
port (
	clk		: in std_logic;     -- 25MHz
	p1       : in std_logic;
	rss      : in std_logic;
	note_clk : out std_logic;
	d_d      : out std_logic_vector(9 downto 0);
	d_dp     : out std_logic_vector(9 downto 0);
	d_dm     : out std_logic_vector(9 downto 0);		
	reset    : out std_logic;	
	rr       : in std_logic;
   -------------------------------------------------------dot port
	dot_d : out std_logic_vector ( 9 downto 0);
	dot_scan : out std_logic_vector ( 13 downto 0);
	--------------------------------------------------------piezo port
	led : out std_logic
);
end component;

component bubble_easy
port (
	clk		: in std_logic;     -- 25MHz
	p1       : in std_logic;
	rss      : in std_logic;
	note_clk : out std_logic;
	d_d      : out std_logic_vector(9 downto 0);
	d_dp     : out std_logic_vector(9 downto 0);
	d_dm     : out std_logic_vector(9 downto 0);		
	reset    : out std_logic;	
	rr       : in std_logic;
   -------------------------------------------------------dot port
	dot_d : out std_logic_vector ( 9 downto 0);
	dot_scan : out std_logic_vector ( 13 downto 0);
	--------------------------------------------------------piezo port
	led : out std_logic
);
end component;
----------------------------------------------------------------------------------component (motor)
component motor
port(   clk : in std_logic;
      start : in std_logic;
		    s : in std_logic;
 motor_data : out std_logic_vector(3 downto 0)
	 );
end component;
---------------------------------------------------------------------------------component (seven segment)
component s7
port(
    clk : in std_logic;
     D1 : in std_logic_vector(3 downto 0);
	  D2 : in std_logic_vector(3 downto 0);
	  o_cnt: in std_logic_vector(3 downto 0);
	  t_cnt: in std_logic_vector(3 downto 0);
	  h_cnt: in std_logic_vector(3 downto 0);
	  seg_d : out std_logic_vector (7 downto 0);
	  com : out std_logic_vector(7 downto 0)
	  );
end component;
---------------------------------------------------------------------------------component (keyboard)
component kbd
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
end component;
-----------------------------------------------------------------------------------vfd 
component vfd
	port ( clk : in std_logic;										--1kHz 클럭.
			reset : in std_logic;									--리셋.
	--------------------------------------------------------------------				
			vfd_e : out std_logic;									--enable.
			vfd_rs : out std_logic;									--select.
			vfd_rw : out std_logic;									--read/write.
			vfd_data : out std_logic_vector(7 downto 0);
		------------------------------------------------------------	
			check_save_0 : in std_logic_vector(7 downto 0);
			check_save_1 : in std_logic_vector(7 downto 0);
			check_save_2 : in std_logic_vector(7 downto 0);
			check_save_3 : in std_logic_vector(7 downto 0);
			check_save_4 : in std_logic_vector(7 downto 0);
			check_save_5 : in std_logic_vector(7 downto 0);
			check_save_6 : in std_logic_vector(7 downto 0);
			check_save_7 : in std_logic_vector(7 downto 0);
			check_save_8 : in std_logic_vector(7 downto 0);
		   check_save_9 : in std_logic_vector(7 downto 0);	
			line_0 : in std_logic_vector(7 downto 0);
			line_1 : in std_logic_vector(7 downto 0);
			line_2 : in std_logic_vector(7 downto 0);
			line_3 : in std_logic_vector(7 downto 0);
			line_4 : in std_logic_vector(7 downto 0);
			line_5 : in std_logic_vector(7 downto 0);
			line_6 : in std_logic_vector(7 downto 0);
			line_7 : in std_logic_vector(7 downto 0);
			line_8 : in std_logic_vector(7 downto 0);
			line_9 : in std_logic_vector(7 downto 0);
			line_10 : in std_logic_vector(7 downto 0);
			line_11 : in std_logic_vector(7 downto 0);
			line_12 : in std_logic_vector(7 downto 0);
			line_13 : in std_logic_vector(7 downto 0);
			line_14 : in std_logic_vector(7 downto 0)
			);			 
end component;			
--------------------------------------------------------------------------------		 

signal start1, start2        : std_logic;
signal start3, start4        : std_logic;
signal dot_d1, dot_d2        : std_logic_vector ( 9 downto 0);
signal dot_d3, dot_d4        : std_logic_vector ( 9 downto 0);
signal dot_scan1, dot_scan2  : std_logic_vector ( 13 downto 0);
signal dot_scan3, dot_scan4  : std_logic_vector ( 13 downto 0);
signal cnt                   : integer range 0 to 1;
signal m_cnt1, m_cnt2        : integer range 0 to 1000;
signal m                     : std_logic;
signal f_cnt                 : integer range 0 to 80000;
signal m_freq                : std_logic;
signal d1, d2, d3, d4        : std_logic_vector(3 downto 0);
signal l1, l2, l3, l4        : std_logic;
signal o_cnt,t_cnt,h_cnt     : std_logic_vector(3 downto 0);
signal led1, led2            : std_logic_vector(7 downto 0);
signal hard, easy            : std_logic;
signal n_clk1,n_clk2,n_clk3,n_clk4  : std_logic;
signal n_clk                        : std_logic;
signal data1, data2                 : std_logic_vector(9 downto 0);
signal d_d, d_dm, d_dp              : std_logic_vector(9 downto 0);
signal d_d1,d_d2,d_d3,d_d4          : std_logic_vector(9 downto 0);
signal d_dp1,d_dp2,d_dp3,d_dp4      : std_logic_vector(9 downto 0); 
signal d_dm1,d_dm2,d_dm3,d_dm4      : std_logic_vector(9 downto 0);
signal rs1,rs2,rs3,rs4,rst   : std_logic;
signal l1_0,l1_1,l1_2,l1_3,l1_4,l1_5,l1_6,l1_7,l1_8,l1_9 : std_logic_vector(7 downto 0);
signal l2_0,l2_1,l2_2,l2_3,l2_4,l2_5,l2_6,l2_7,l2_8,l2_9,l2_10,l2_11,l2_12,l2_13,l2_14 : std_logic_vector(7 downto 0);
signal cb1,cb2,cb3,cb4,cb5,cb6,cb7,cb8,cb9 : std_logic;
signal rr : std_logic;

begin

rst      <= rs1 or rs2 or rs3 or rs4;
n_clk    <= n_clk1 or n_clk2 or n_clk3 or n_clk4;
d_d      <= d_d1 or d_d2 or d_d3 or d_d4;
d_dm     <= d_dm1 or d_dm2 or d_dm3 or d_dm4;
dot_d    <= dot_d1 or dot_d2 or dot_d3 or dot_d4;
dot_scan <= dot_scan1 or dot_scan2 or dot_scan3 or dot_scan4;
--------------------------------------------------m_freq
process(clk)
begin 
if clk'event and clk='1' then
   if f_cnt = 60000 then
	   m_freq <= not m_freq;
		f_cnt <= 0;
   else
	f_cnt <= f_cnt + 1;
	end if;
end if;
end process;

m <= l1 or l2 or l3 or l4;

-------------------------------------------------------------------choice
process(p1,rss)
begin
  if rss = '1' then
    cnt <= 0;
  elsif p1'event and p1 ='1' and (game_on) = '0' then
    cnt <= cnt + 1;
  end if;		 
end process;

process(clk)
begin
  if cnt = 0 then
     d1 <= "0001";
  else
     d1 <= "0010";
  end if;
end process;

-----------------------------------------------------------------start
process(p2,rss,rst)
begin
  if rss = '1' or rst = '1' then
     start1 <= '0';
	  start2 <= '0';
	  start3 <= '0';
	  start4 <= '0';
	  rr <= '1';
  elsif cnt = 0 and (game_on) = '0' and player2 = '1' then
     if selec = '1' then
     start1 <= p2;
	  rr <= '0';
	  elsif selec = '0' then
	  start3 <= p2;
	  rr <= '0';
	  end if;
  elsif cnt = 1 and (game_on) = '0' and player2 = '1' then      
     if selec = '1' then
	  start2 <= p2;
	  rr <= '0';
	  elsif selec = '0' then
	  start4 <= p2;
	  rr <= '0';
     end if;
  end if;
end process;
-----------------------------------------------vfd
process(p2,rss,clk)
begin
  if (l1 or l2 or l3 or l4) = '0' then
   if cnt = 0 then
     l2_0 <="00100000";
	  l2_1 <="00100000";
     l2_2 <="00110001";
	  l2_3 <="00101110";
	  l2_4 <="01001101";
	  l2_5 <="01100001";
	  l2_6 <="01110010";
	  l2_7 <="01101001";
	  l2_8 <="01101111";
	  l2_9 <="00100000";
	  l2_10 <="01000010";
	  l2_11 <="01110010";
	  l2_12 <="01101111";
	  l2_13 <="01110011";
     l2_14 <="00100000";
   elsif cnt = 1 then  
	  l2_0 <="00100000";
	  l2_1 <="00110010";
	  l2_2 <="00101110";
	  l2_3 <="01000010";
	  l2_4 <="01110101";
	  l2_5 <="01100010";
	  l2_6 <="01100010";
	  l2_7 <="01101100";
	  l2_8 <="01100101";
	  l2_9 <="01000010";
	  l2_10 <="01110101";
	  l2_11 <="01100010";
	  l2_12 <="01100010";
	  l2_13 <="01101100";
	  l2_14 <="01100101";
   end if;
   if selec = '1' then
     l1_0 <="01001000";
	  l1_1 <="01100001";
	  l1_2 <="01110010";
	  l1_3 <="01100100";
	  l1_4 <="00100000";
	  l1_5 <="01001101";
	  l1_6 <="01101111";
	  l1_7 <="01100100";
	  l1_8 <="01100101";
	  l1_9 <="10010110";
   elsif selec = '0' then	  
	  l1_0 <="01000101";
	  l1_1 <="01100001";
	  l1_2 <="01110011";
	  l1_3 <="01111001";
	  l1_4 <="00100000";
	  l1_5 <="01001101";
	  l1_6 <="01101111";
	  l1_7 <="01100100";
	  l1_8 <="01100101";
	  l1_9 <="10010001";
   end if;
  end if;
end process;

-----------------------combo
data1 <= led1(0) & led1(1) & led1(2) & led1(3) & d2(1 downto 0) & led1(4) & led1(5)& led1(6)& led1(7);
data2 <= led2(0) & led2(1) & led2(2) & "0000" & led2(5) & led2(6) & led2(7); 


process(n_clk,rst,rss,clk)
begin
  if rss = '1' or rst = '1' then
    	o_cnt <= "0000";
	   t_cnt <= "0000";
  	   h_cnt <= "0000";	
  elsif n_clk'event and n_clk = '1' then
    if d_d = "0000000000" and d_dm = "0000000000" and d_dp = "0000000000" then
       null;
    elsif  ((d_d = data1 or d_dm = data1 or d_dp = data1) and hard = '1' and not(data1 = "0000000000")) 
	         or ((d_d = data2 or d_dm = data2 or d_dp = data2) and easy = '1' and not(data2 = "0000000000")) then
        if o_cnt = "1001" then
		     o_cnt <= "0000";
			  if t_cnt = "1001" then
			     t_cnt <= "0000";
				  h_cnt <= h_cnt + "0001";
			  else
			     t_cnt <= t_cnt + "0001";
			  end if;
		  else
		     o_cnt <= o_cnt + "0001";
		  end if;			
	 end if;
  end if;
end process;
  
  
led <= led1 or led2;

hard <= l1 or l2;
easy <= l3 or l4;
piezo_o <= input and piezo_i;


dot1 : mario_hard
port map(clk, start1, rss, n_clk1, d_d1, d_dp1, d_dm1, rs1, rr, dot_d1, dot_scan1, l1);
dot2 : bubble_hard
port map(clk, start2, rss, n_clk2, d_d2, d_dp2, d_dm2, rs2, rr, dot_d2, dot_scan2, l2);
dot3 : mario_easy
port map(clk, start3, rss, n_clk3, d_d3, d_dp3, d_dm3, rs3, rr, dot_d3, dot_scan3, l3);
dot4 : bubble_easy
port map(clk, start4, rss, n_clk4, d_d4, d_dp4, d_dm4, rs4, rr, dot_d4, dot_scan4, l4);


mot  : motor
port map(m_freq, m, m_s, m_data);

seg  : s7
port map(clk, d1, d2, o_cnt, t_cnt, h_cnt, s_data, s_com);

kbd1 : kbd
port map(clk, k_clk, k_data, selec, hard, easy, led1, led2, d2);

vfd1 : vfd
port map(clk, rss, vfd_e, vfd_rs, vfd_rw, vfd_data, l1_0, l1_1, l1_2, l1_3, l1_4, l1_5, l1_6, l1_7, l1_8, l1_9,
           l2_0, l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_7, l2_8, l2_9, l2_10, l2_11, l2_12, l2_13, l2_14);
 
end Behavioral;

