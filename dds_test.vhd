--********************
--Title: DDS test
--Time:  2018/10/21
--Author: Butian Du
-- FPGA + AD9854
--********************

library IEEE;

use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity dds_test is
  Port (   clk : in std_logic; -- time
           mst_rst : out std_logic; -- master reset
           d : out std_logic_vector(7 downto 0); --8 bits parallel programming data output 
           a : out std_logic_vector(5 downto 0); --6 bits parallel programming address output
           wrb : out std_logic;  --write to register 
           io_ud : out std_logic; --frequency update 
end dds_test;

architecture Behavioral of dds_test is
		    signal data_tmp :std_logic_vector(7 downto 0);		        --数据寄存器
			 signal address_tmp :std_logic_vector(5 downto 0);		--地址寄存器
			 signal cl   :std_logic;					         --输出时钟
			 signal count:std_logic_vector(5 downto 0);		        --时钟计数器
			 signal dount:std_logic_vector(5 downto 0);		        --数据计数器
			 signal count_clk:std_logic_vector(31 downto 0);		        --时钟计数器
          
begin 
		cl <= count_clk(1);
		wrb <= not cl;
		
process (clk)
	begin 
		if cl 'event and clk ='1' then 
			count_ clk <= count_ clk +1;
		end if; 
end process;

process (cl)
	begin 
		if (cl 'event and cl ='1') then 
			if(count=36)then 
			count <'000000';
			else 
			count <= count + '1';
			end if;
		end if;
end process;

process (cl)
	begin 
		if (cl 'event and cl ='1') then 
			if(dount<=2)then
			mst_rst<='1';
			dount = dount + '1';
			else 
			mst_rst <= '0';
			end if;
		end if;
end process;

		d <= data_tmp;
		a < =address_tmp;
		
process(cl)
  begin
	 if(cl'event and cl='1')then 
       if count=16  then   io_ud<='1';else io_ud<='0'; end if;
       if count=4   then   address_tmp<="000100";   data_tmp<="00001100";	--频率控制字(第40~47位)，在200M时钟（40M外部晶振时钟5倍频）下，此时频率控制字对应的输出频率约10M
	    elsif count=5   then   address_tmp<="000101";   data_tmp<="11001100";  --频率控制字(第32~39位)
	    elsif count=6   then   address_tmp<="000110";   data_tmp<="11001100";  --频率控制字(第24~31位)
        elsif count=7   then   address_tmp<="000111";   data_tmp<="11001100";  --频率控制字(第16~23位)
	    elsif count=8   then   address_tmp<="001000";   data_tmp<="11001100";  --频率控制字(第8~15位)
        elsif count=9   then   address_tmp<="001001";   data_tmp<="11001100";  --频率控制字(第0~7位)

	    elsif   count=10  then    address_tmp<="011101";   data_tmp<="00010000";  --控制寄存器,1D[4]='1'表示关闭高速比较器以较少损耗,1D[2]='0'表示打开Q路DA输出，此时为双通道同时输出 	 	
	    elsif   count=11  then    address_tmp<="011110";   data_tmp<="01000101";  --控制寄存器,后五位是设置倍频系数，此处为5倍频。1E[4~0]="00101"=5表示选择5倍频  		 			
	    elsif   count=12  then    address_tmp<="011111";   data_tmp<="00000001";  --控制寄存器,1E[3~1]为工作模式选择（"000"表示单频点,"001"表示FSK,"010"表示Ramped FSK,"011"表示Chirp,"100"表示BPSK）, 1E[0]='0'表示外部更新时钟使能   	 	
	    elsif   count=13  then    address_tmp<="100000";   data_tmp<="01000000";  --控制寄存器,20[6]='1'表示关闭sinc函数滤波器以较少损耗 
	    end if;		  

	end if;
end process;		




  