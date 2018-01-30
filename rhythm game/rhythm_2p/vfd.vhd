library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity vfd is

	generic (															--generic문을 통해 매개변수를 사전에 선언. 
				cnt_max : integer := 4;								--4번 바뀌면 1씩 증가.
				vfd_char : integer := 16;							--16번 바뀌면 1씩 증가.
				stable_delay : integer := 19;						--19번 바뀌면 100ms(power stable delay).
				display_delay : integer := 399);					--399번 바뀌면 2s(text display time).

	port ( clk : in std_logic;										--1kHz 클럭.
			reset : in std_logic;									--리셋.
					
			vfd_e : out std_logic;									--enable.
			vfd_rs : out std_logic;									--select.
			vfd_rw : out std_logic;									--read/write.
			vfd_data : out std_logic_vector(7 downto 0);
			
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
end vfd;

architecture Behavioral of vfd is

	type vfd_state is ( delay_20ms,								--vfd_state의 data 종류를 나타냄.
							  function_set,
							  entry_mode,
							  disp_on,
							  disp_line1,
							  disp_line2,
							  delay_2s,
							  display_clear
							 );

signal vfd_routine : vfd_state;

signal cnt_clk : integer range 0 to cnt_max;
signal cnt_clk_half : integer range 0 to cnt_max;

signal cnt_delay_20ms : integer range 0 to stable_delay;
signal cnt_delay_2s : integer range 0 to display_delay;
signal cnt_line : integer range 0 to vfd_char;


type ar_vfd_data is array (0 to vfd_char) of std_logic_vector(7 downto 0);
signal reg_vfd_data1 : ar_vfd_data;
signal reg_vfd_data2 : ar_vfd_data;

begin

reg_vfd_data1(0) <= "10000000";		-- line1 주소로 2줄의 출력화면중 1번째 줄에 해당.
reg_vfd_data1(1) <= "00100000"; 		-- ' '
reg_vfd_data1(2) <= "00100000";		-- ' '
reg_vfd_data1(3) <= "00100000";		-- ' '
reg_vfd_data1(4) <= check_save_0;		-- 'c'
reg_vfd_data1(5) <= check_save_1;		-- 'h'
reg_vfd_data1(6) <= check_save_2;		-- 'e'
reg_vfd_data1(7) <= check_save_3;		-- 'c'
reg_vfd_data1(8) <= check_save_4;	-- 'k'
reg_vfd_data1(9) <= check_save_5;		-- ' '
reg_vfd_data1(10) <= check_save_6;		-- '0,1,2,3,4'
reg_vfd_data1(11) <= check_save_7;		-- ' '
reg_vfd_data1(12) <= check_save_8;		-- ' '
reg_vfd_data1(13) <= check_save_9;		-- ' '
reg_vfd_data1(14) <= "00100000";		-- ' '
reg_vfd_data1(15) <= "00100000";		-- ' '
reg_vfd_data1(16) <= "00100000";		-- ' '

reg_vfd_data2(0) <= "11000000";		-- line2 주소로 2줄의 출력화면중 2번째 줄에 해당.
reg_vfd_data2(1) <= line_0;		-- ''
reg_vfd_data2(2) <= line_1;		-- ''
reg_vfd_data2(3) <= line_2;	-- '$'
reg_vfd_data2(4) <= line_3;		-- '1'
reg_vfd_data2(5) <= line_4;		-- '0'
reg_vfd_data2(6) <= line_5;		-- '0'
reg_vfd_data2(7) <= line_6;		-- '0'
reg_vfd_data2(8) <= line_7;		-- '0'
reg_vfd_data2(9) <= line_8;		-- '0'
reg_vfd_data2(10) <= line_9;		-- ''
reg_vfd_data2(11) <= line_10;		-- ''
reg_vfd_data2(12) <= line_11;		-- ''
reg_vfd_data2(13) <= line_12;		-- ''
reg_vfd_data2(14) <= line_13;		-- ''
reg_vfd_data2(15) <= line_14;		-- ''
reg_vfd_data2(16) <= "00100000";		-- ''

	process(reset, clk)								
		begin
			if reset = '1' then
				cnt_clk <= 0;							--리셋이 '1'일때 cnt_clk 초기화.
			elsif clk'event and clk = '1' then	--리셋이 '0'일때 클럭의 상승에지에서 동작.
				if cnt_clk = cnt_max then			
					cnt_clk <= 0;						--cnt_clk이 cnt_max와 같으면 클럭 초기화.
				else 
					cnt_clk <= cnt_clk + 1;			--그 외의 경우 cnt_clk이 1씩 증가.
				end if;
			end if;
	end process;
	
cnt_clk_half <= cnt_max-1;												--vfd_e 제어 신호처리를 위한 cnt_clk_half 값 정의.

	process(reset, clk)													--초기 delay (100ms) 처리부분.
		begin	
			if reset = '1' then
				cnt_delay_20ms <= 0;										--리셋이 '1'일때 cnt_delay_20ms 초기화.	
			elsif clk'event and clk = '1' then						--리셋이 '0'일때 클럭의 상승에지에서 동작.
				if vfd_routine = delay_20ms then						--vfd_routine의 상태가 delay_20ms 일때 동작.
					if cnt_clk = cnt_max then							--cnt_clk이 cnt_max와 같을때 동작.
						if cnt_delay_20ms = stable_delay then
							cnt_delay_20ms <= 0;							--cnt_delay_20ms가 stable_delay와 같을때 cnt_delay_20ms 초기화.
						else
							cnt_delay_20ms <= cnt_delay_20ms + 1;	-- 그 외의 경우 cnt_delay_20ms가 1씩 증가.
						end if;
					end if;
				else
					cnt_delay_20ms <= 0;									--vfd_routine의 상태가 delay_20ms가 아닐때 cnt_delay_20ms 초기화.
				end if;		
			end if;
	end process;
	
	process(reset, clk)												-- display delay (2s) 처리부분.
		begin
			if reset = '1' then
				cnt_delay_2s <= 0;									--리셋이 '1'이면 cnt_delay_2s 초기화.
			elsif clk'event and clk = '1' then					--리셋이 '0'일때 클럭의 상승에지에서 동작.
				if vfd_routine = delay_2s then					--vfd_routine의 상태가 delay_2s 일때 동작.
					if cnt_clk = cnt_max then						--cnt_clk이 cnt_max와 같을때 동작.
						if cnt_delay_2s = display_delay then
							cnt_delay_2s <= 0;						--cnt_delay_2s가 display_delay와 같을때 cnt_delay_2s 초기화.
						else
							cnt_delay_2s <= cnt_delay_2s + 1;	--그 외의 경우 cnt_delay_2s가 1씩 증가.
						end if;
					end if;
				else
					cnt_delay_2s <= 0;								--vfd_routine의 상태가 delay_2s가 아닐때 cnt_delay_2s 초기화.
				end if;
			end if;
	end process;
	
	process(reset, clk)																	-- VFD의 각 라인 (line 1 and line 2)의 처리시간(80ms) 정의.
		begin
			if reset = '1' then
				cnt_line <= 0;																--리셋이 '1'이면 cnt_line 초기화.
			elsif clk'event and clk = '1' then										--리셋이 '0'일때 클럭의 상승에지에서 동작.
				if vfd_routine = disp_line1 or vfd_routine = disp_line2 then--vfd_routine의 상태가 disp_line1 이거나 disp_line2 일때 동작.
					if cnt_clk = cnt_max then											--cnt_clk이 cnt_max와 같을때 동작.
						if cnt_line = vfd_char then
							cnt_line <= 0;													--cnt_line이 vfd_char와 같을때 cnt_line 초기화.
						else
							cnt_line <= cnt_line + 1;									--그 외의 경우 cnt_line이 1씩 증가.
						end if;
					end if;
				else
					cnt_line <= 0;															--vfd_routine의 상태가 disp_line1 또는 disp_line2 가 아닐때 cnt_line 초기화.
				end if;
			end if;
	end process;
	
	process(reset, clk)																		-- 각 routine별로 설정된 시간이 경과되면 다음 routine로 이동.
		begin
			if reset = '1' then
				vfd_routine <= delay_20ms;													--리셋이 '1'이면 vfd_routine의 상태는 delay_20ms.
			elsif clk'event and clk = '1' then											--리셋이 '0'일때 클럭의 상승에지에서 동작.
				if cnt_clk = cnt_max then													--cnt_clk이 cnt_max와 같을때 동작.
					case vfd_routine is														
						when delay_20ms => if cnt_delay_20ms = stable_delay then	--vfd_routine의 상태가 delay_20ms인 경우 if문으로 이동.
													 vfd_routine <= function_set;			--cnt_delay_20ms가 stable_delay와 같을때 vfd_routine의 상태는 function_set.
												 end if;
						when function_set => vfd_routine <= entry_mode;				--vfd_routine의 상태가 function_set인 경우 상태를 entry_mode로 바꿈.
						when entry_mode => vfd_routine <= disp_on;					--vfd_routine의 상태가 entry_mode인 경우 상태를 disp_on로 바꿈.
						when disp_on => vfd_routine <= disp_line1;					--vfd_routine의 상태가 disp_on인 경우 상태를 disp_line1로 바꿈.
						when disp_line1 => if cnt_line = vfd_char then				--vfd_routine의 상태가 disp_line1인 경우 if문으로 이동.
													 vfd_routine <= disp_line2;			--cnt_line이 vfd_char와 같을때 vfd_routine의 상태는 disp_line2.
												 end if;
						when disp_line2 => if cnt_line = vfd_char then 				--vfd_routine의 상태가 disp_line2인 경우 if문으로 이동.
													 vfd_routine <= delay_2s;				--cnt_line이 vfd_char와 같을때 vfd_routine의 상태는 delay_2s.
												 end if;						 
						when delay_2s => if cnt_delay_2s = display_delay then		--vfd_routine의 상태가 delay_2s인 경우 cnt_delay_2s와 display_delay가 같을때 동작.
													vfd_routine <= display_clear;			--sel 이 "11"일때 vfd_routine의 상태는 display_clear(display 비활성).
												 
												end if;
				
						when display_clear => vfd_routine <= delay_20ms;				--vfd_routine의 상태가 display_clear인 경우 상태를 delay_2s로 바꿈.
					end case;
				end if;
			end if;
	end process;
	
	process(reset, clk)										-- 각 routine별 vfd_e 신호의 '0'과 '1'값을 정의.
		begin
			if reset = '1' then
				vfd_e <= '0';									--리셋이 '1'일때 enable, read/write = 0.
				vfd_rw <= '0';
			elsif clk'event and clk = '1' then			--리셋이 '0'일때 클럭의 상승에지에서 동작.
				case vfd_routine is
					when delay_20ms => vfd_e <= '0';		--vfd_routine의 상태가 delay_20ms인 경우 enable = 0.
					
					when function_set to disp_line2 => 	--vfd_routine의 상태가 function_set 에서 disp_line2까지
																	if cnt_clk >= 1 and cnt_clk <= cnt_clk_half then
																		vfd_e <= '1';
																	--cnt_clk이 1보다 크거나 작고 cnt_clk_half보다 같거나 작을때 enable = 1.
																	else
																		vfd_e <= '0'; --그 외의 경우 enable = 0.
																	end if;
																	
					when delay_2s => vfd_e <= '0';		--vfd_routine의 상태가 delay_2s인 경우 enable = 0.

				
					
					
															
					when display_clear =>					--vfd_routine의 상태가 display_clear인 경우
												if cnt_clk >= 1 and cnt_clk <= cnt_clk_half then
													vfd_e <= '1';
																	--cnt_clk이 1보다 크거나 작고 cnt_clk_half보다 같거나 작을때 enable = 1.
												else
													vfd_e <= '0';	--그 외의 경우 enable = 0.
												end if;
				end case;
			end if;
	end process;
	
	
	process(reset, clk)								-- vfd_rs 신호의 '0'과 '1' 값을 정의.
		begin
			if reset = '1' then
				vfd_rs <= '0';							--리셋이 '1'일때 vfd_rs = 0.
			elsif clk'event and clk = '1' then	--리셋이 '0'일때 클럭의 상승에지에서 동작.
				if vfd_routine = disp_line1 or vfd_routine = disp_line2 then
															--vfd_routine의 상태가 disp_line1 이거나 disp_line2일때 동작.
					if cnt_line = 0 then
						vfd_rs <= '0'; 				--cnt_line이 0일때 vfd_rs = 0(동작하지 않는다).
					else
						vfd_rs <= '1';					--그 외의 경우 vfd_rs =1(동작 한다).
					end if;
				else
					vfd_rs <= '0';						--vfd_routine의 상태가 disp_line1 또는 disp_line2가 아닌 경우 vfd_rs = 0.
				end if;
			end if;
	end process;


	
	process(reset, clk)																	-- vfd 제어 신호 및 문자 출력 코드를 vfd로 전달.
		begin
			if reset = '1' then
				vfd_data <= "00000001";													--리셋이 '1'이면 vfd_data 초기화.
			elsif clk'event and clk = '1' then										--리셋이 '0'일때 클럭의 상승에지에서 동작.	
				case vfd_routine is														--vfd_routine의 상태가
					when delay_20ms => vfd_data <= "00000000";							--delay_20ms인 경우 커서가 0으로 돌아간다.
					when function_set => vfd_data <= "00111000";							--function_set인 경우 화면의 밝기 100%.
					when entry_mode => vfd_data <= "00000110";							--entry_mode인 경우 커서 오른쪽 이동.
					when disp_on => vfd_data <= "00001100";								--disp_on인 경우 커서 꺼짐.
					when disp_line1 => vfd_data <= reg_vfd_data1(cnt_line);			--disp_line1인 경우 line1에 결과값 출력.
					when disp_line2 => vfd_data <= reg_vfd_data2(cnt_line);			--disp_line2인 경우 line2에 결과값 출력.
					when delay_2s => vfd_data <= "00000000";								--delay_2s인 경우 커서가 0으로 돌아간다.
					when display_clear => vfd_data <= "00000001";						--display_clear인 경우 화면 초기화.
				end case;
			end if;
	end process;
			
end Behavioral;

