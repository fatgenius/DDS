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
		    signal data_tmp :std_logic_vector(7 downto 0);		        --���ݼĴ���
			 signal address_tmp :std_logic_vector(5 downto 0);		--��ַ�Ĵ���
			 signal cl   :std_logic;					         --���ʱ��
			 signal count:std_logic_vector(5 downto 0);		        --ʱ�Ӽ�����
			 signal dount:std_logic_vector(5 downto 0);		        --���ݼ�����
			 signal count_clk:std_logic_vector(31 downto 0);		        --ʱ�Ӽ�����
          
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
       if count=4   then   address_tmp<="000100";   data_tmp<="00001100";	--Ƶ�ʿ�����(��40~47λ)����200Mʱ�ӣ�40M�ⲿ����ʱ��5��Ƶ���£���ʱƵ�ʿ����ֶ�Ӧ�����Ƶ��Լ10M
	    elsif count=5   then   address_tmp<="000101";   data_tmp<="11001100";  --Ƶ�ʿ�����(��32~39λ)
	    elsif count=6   then   address_tmp<="000110";   data_tmp<="11001100";  --Ƶ�ʿ�����(��24~31λ)
        elsif count=7   then   address_tmp<="000111";   data_tmp<="11001100";  --Ƶ�ʿ�����(��16~23λ)
	    elsif count=8   then   address_tmp<="001000";   data_tmp<="11001100";  --Ƶ�ʿ�����(��8~15λ)
        elsif count=9   then   address_tmp<="001001";   data_tmp<="11001100";  --Ƶ�ʿ�����(��0~7λ)

	    elsif   count=10  then    address_tmp<="011101";   data_tmp<="00010000";  --���ƼĴ���,1D[4]='1'��ʾ�رո��ٱȽ����Խ������,1D[2]='0'��ʾ��Q·DA�������ʱΪ˫ͨ��ͬʱ��� 	 	
	    elsif   count=11  then    address_tmp<="011110";   data_tmp<="01000101";  --���ƼĴ���,����λ�����ñ�Ƶϵ�����˴�Ϊ5��Ƶ��1E[4~0]="00101"=5��ʾѡ��5��Ƶ  		 			
	    elsif   count=12  then    address_tmp<="011111";   data_tmp<="00000001";  --���ƼĴ���,1E[3~1]Ϊ����ģʽѡ��"000"��ʾ��Ƶ��,"001"��ʾFSK,"010"��ʾRamped FSK,"011"��ʾChirp,"100"��ʾBPSK��, 1E[0]='0'��ʾ�ⲿ����ʱ��ʹ��   	 	
	    elsif   count=13  then    address_tmp<="100000";   data_tmp<="01000000";  --���ƼĴ���,20[6]='1'��ʾ�ر�sinc�����˲����Խ������ 
	    end if;		  

	end if;
end process;		




  