library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity vfd is

	generic (															
				cnt_max : integer := 4;								
				vfd_char : integer := 16;							
				stable_delay : integer := 19;						
				display_delay : integer := 399);					

	port ( clk : in std_logic;										
			reset : in std_logic;									
					
			vfd_e : out std_logic;									
			vfd_rs : out std_logic;									
			vfd_rw : out std_logic;									
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

	type vfd_state is ( delay_20ms,								--vfd_state�� data ������ ��Ÿ��.
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

reg_vfd_data1(0) <= "10000000";		-- line1 �ּҷ� 2���� ���ȭ���� 1��° �ٿ� �ش�.
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

reg_vfd_data2(0) <= "11000000";		-- line2 �ּҷ� 2���� ���ȭ���� 2��° �ٿ� �ش�.
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
				cnt_clk <= 0;							--������ '1'�϶� cnt_clk �ʱ�ȭ.
			elsif clk'event and clk = '1' then	--������ '0'�϶� Ŭ���� ��¿������� ����.
				if cnt_clk = cnt_max then			
					cnt_clk <= 0;						--cnt_clk�� cnt_max�� ������ Ŭ�� �ʱ�ȭ.
				else 
					cnt_clk <= cnt_clk + 1;			--�� ���� ��� cnt_clk�� 1�� ����.
				end if;
			end if;
	end process;
	
cnt_clk_half <= cnt_max-1;												--vfd_e ���� ��ȣó���� ���� cnt_clk_half �� ����.

	process(reset, clk)													--�ʱ� delay (100ms) ó���κ�.
		begin	
			if reset = '1' then
				cnt_delay_20ms <= 0;										--������ '1'�϶� cnt_delay_20ms �ʱ�ȭ.	
			elsif clk'event and clk = '1' then						--������ '0'�϶� Ŭ���� ��¿������� ����.
				if vfd_routine = delay_20ms then						--vfd_routine�� ���°� delay_20ms �϶� ����.
					if cnt_clk = cnt_max then							--cnt_clk�� cnt_max�� ������ ����.
						if cnt_delay_20ms = stable_delay then
							cnt_delay_20ms <= 0;							--cnt_delay_20ms�� stable_delay�� ������ cnt_delay_20ms �ʱ�ȭ.
						else
							cnt_delay_20ms <= cnt_delay_20ms + 1;	-- �� ���� ��� cnt_delay_20ms�� 1�� ����.
						end if;
					end if;
				else
					cnt_delay_20ms <= 0;									--vfd_routine�� ���°� delay_20ms�� �ƴҶ� cnt_delay_20ms �ʱ�ȭ.
				end if;		
			end if;
	end process;
	
	process(reset, clk)												-- display delay (2s) ó���κ�.
		begin
			if reset = '1' then
				cnt_delay_2s <= 0;									--������ '1'�̸� cnt_delay_2s �ʱ�ȭ.
			elsif clk'event and clk = '1' then					--������ '0'�϶� Ŭ���� ��¿������� ����.
				if vfd_routine = delay_2s then					--vfd_routine�� ���°� delay_2s �϶� ����.
					if cnt_clk = cnt_max then						--cnt_clk�� cnt_max�� ������ ����.
						if cnt_delay_2s = display_delay then
							cnt_delay_2s <= 0;						--cnt_delay_2s�� display_delay�� ������ cnt_delay_2s �ʱ�ȭ.
						else
							cnt_delay_2s <= cnt_delay_2s + 1;	--�� ���� ��� cnt_delay_2s�� 1�� ����.
						end if;
					end if;
				else
					cnt_delay_2s <= 0;								--vfd_routine�� ���°� delay_2s�� �ƴҶ� cnt_delay_2s �ʱ�ȭ.
				end if;
			end if;
	end process;
	
	process(reset, clk)																	-- VFD�� �� ���� (line 1 and line 2)�� ó���ð�(80ms) ����.
		begin
			if reset = '1' then
				cnt_line <= 0;																--������ '1'�̸� cnt_line �ʱ�ȭ.
			elsif clk'event and clk = '1' then										--������ '0'�϶� Ŭ���� ��¿������� ����.
				if vfd_routine = disp_line1 or vfd_routine = disp_line2 then--vfd_routine�� ���°� disp_line1 �̰ų� disp_line2 �϶� ����.
					if cnt_clk = cnt_max then											--cnt_clk�� cnt_max�� ������ ����.
						if cnt_line = vfd_char then
							cnt_line <= 0;													--cnt_line�� vfd_char�� ������ cnt_line �ʱ�ȭ.
						else
							cnt_line <= cnt_line + 1;									--�� ���� ��� cnt_line�� 1�� ����.
						end if;
					end if;
				else
					cnt_line <= 0;															--vfd_routine�� ���°� disp_line1 �Ǵ� disp_line2 �� �ƴҶ� cnt_line �ʱ�ȭ.
				end if;
			end if;
	end process;
	
	process(reset, clk)																		-- �� routine���� ������ �ð��� ����Ǹ� ���� routine�� �̵�.
		begin
			if reset = '1' then
				vfd_routine <= delay_20ms;													--������ '1'�̸� vfd_routine�� ���´� delay_20ms.
			elsif clk'event and clk = '1' then											--������ '0'�϶� Ŭ���� ��¿������� ����.
				if cnt_clk = cnt_max then													--cnt_clk�� cnt_max�� ������ ����.
					case vfd_routine is														
						when delay_20ms => if cnt_delay_20ms = stable_delay then	--vfd_routine�� ���°� delay_20ms�� ��� if������ �̵�.
													 vfd_routine <= function_set;			--cnt_delay_20ms�� stable_delay�� ������ vfd_routine�� ���´� function_set.
												 end if;
						when function_set => vfd_routine <= entry_mode;				--vfd_routine�� ���°� function_set�� ��� ���¸� entry_mode�� �ٲ�.
						when entry_mode => vfd_routine <= disp_on;					--vfd_routine�� ���°� entry_mode�� ��� ���¸� disp_on�� �ٲ�.
						when disp_on => vfd_routine <= disp_line1;					--vfd_routine�� ���°� disp_on�� ��� ���¸� disp_line1�� �ٲ�.
						when disp_line1 => if cnt_line = vfd_char then				--vfd_routine�� ���°� disp_line1�� ��� if������ �̵�.
													 vfd_routine <= disp_line2;			--cnt_line�� vfd_char�� ������ vfd_routine�� ���´� disp_line2.
												 end if;
						when disp_line2 => if cnt_line = vfd_char then 				--vfd_routine�� ���°� disp_line2�� ��� if������ �̵�.
													 vfd_routine <= delay_2s;				--cnt_line�� vfd_char�� ������ vfd_routine�� ���´� delay_2s.
												 end if;						 
						when delay_2s => if cnt_delay_2s = display_delay then		--vfd_routine�� ���°� delay_2s�� ��� cnt_delay_2s�� display_delay�� ������ ����.
													vfd_routine <= display_clear;			--sel �� "11"�϶� vfd_routine�� ���´� display_clear(display ��Ȱ��).
												 
												end if;
				
						when display_clear => vfd_routine <= delay_20ms;				--vfd_routine�� ���°� display_clear�� ��� ���¸� delay_2s�� �ٲ�.
					end case;
				end if;
			end if;
	end process;
	
	process(reset, clk)										-- �� routine�� vfd_e ��ȣ�� '0'�� '1'���� ����.
		begin
			if reset = '1' then
				vfd_e <= '0';									--������ '1'�϶� enable, read/write = 0.
				vfd_rw <= '0';
			elsif clk'event and clk = '1' then			--������ '0'�϶� Ŭ���� ��¿������� ����.
				case vfd_routine is
					when delay_20ms => vfd_e <= '0';		--vfd_routine�� ���°� delay_20ms�� ��� enable = 0.
					
					when function_set to disp_line2 => 	--vfd_routine�� ���°� function_set ���� disp_line2����
																	if cnt_clk >= 1 and cnt_clk <= cnt_clk_half then
																		vfd_e <= '1';
																	--cnt_clk�� 1���� ũ�ų� �۰� cnt_clk_half���� ���ų� ������ enable = 1.
																	else
																		vfd_e <= '0'; --�� ���� ��� enable = 0.
																	end if;
																	
					when delay_2s => vfd_e <= '0';		--vfd_routine�� ���°� delay_2s�� ��� enable = 0.

				
					
					
															
					when display_clear =>					--vfd_routine�� ���°� display_clear�� ���
												if cnt_clk >= 1 and cnt_clk <= cnt_clk_half then
													vfd_e <= '1';
																	--cnt_clk�� 1���� ũ�ų� �۰� cnt_clk_half���� ���ų� ������ enable = 1.
												else
													vfd_e <= '0';	--�� ���� ��� enable = 0.
												end if;
				end case;
			end if;
	end process;
	
	
	process(reset, clk)								-- vfd_rs ��ȣ�� '0'�� '1' ���� ����.
		begin
			if reset = '1' then
				vfd_rs <= '0';							--������ '1'�϶� vfd_rs = 0.
			elsif clk'event and clk = '1' then	--������ '0'�϶� Ŭ���� ��¿������� ����.
				if vfd_routine = disp_line1 or vfd_routine = disp_line2 then
															--vfd_routine�� ���°� disp_line1 �̰ų� disp_line2�϶� ����.
					if cnt_line = 0 then
						vfd_rs <= '0'; 				--cnt_line�� 0�϶� vfd_rs = 0(�������� �ʴ´�).
					else
						vfd_rs <= '1';					--�� ���� ��� vfd_rs =1(���� �Ѵ�).
					end if;
				else
					vfd_rs <= '0';						--vfd_routine�� ���°� disp_line1 �Ǵ� disp_line2�� �ƴ� ��� vfd_rs = 0.
				end if;
			end if;
	end process;


	
	process(reset, clk)																	-- vfd ���� ��ȣ �� ���� ��� �ڵ带 vfd�� ����.
		begin
			if reset = '1' then
				vfd_data <= "00000001";													--������ '1'�̸� vfd_data �ʱ�ȭ.
			elsif clk'event and clk = '1' then										--������ '0'�϶� Ŭ���� ��¿������� ����.	
				case vfd_routine is														--vfd_routine�� ���°�
					when delay_20ms => vfd_data <= "00000000";							--delay_20ms�� ��� Ŀ���� 0���� ���ư���.
					when function_set => vfd_data <= "00111000";							--function_set�� ��� ȭ���� ��� 100%.
					when entry_mode => vfd_data <= "00000110";							--entry_mode�� ��� Ŀ�� ������ �̵�.
					when disp_on => vfd_data <= "00001100";								--disp_on�� ��� Ŀ�� ����.
					when disp_line1 => vfd_data <= reg_vfd_data1(cnt_line);			--disp_line1�� ��� line1�� ����� ���.
					when disp_line2 => vfd_data <= reg_vfd_data2(cnt_line);			--disp_line2�� ��� line2�� ����� ���.
					when delay_2s => vfd_data <= "00000000";								--delay_2s�� ��� Ŀ���� 0���� ���ư���.
					when display_clear => vfd_data <= "00000001";						--display_clear�� ��� ȭ�� �ʱ�ȭ.
				end case;
			end if;
	end process;
			
end Behavioral;

