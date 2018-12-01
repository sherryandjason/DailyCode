clc;clear
str={'D40L1S70','D40L1S75','D40L1S80','D40L1S85','D40L1S90','D40L1S100','D40L1S110','D40L1S120','D40L1S130'} ;
for i=1:length(str)
    j=i*10+20;
    temp=importfile(['comSailboat_mcap_IC_motionTest_S',mat2str(j),'.txt']);
    eval([cell2mat(str(i)) '=' mat2str(temp)]);
end
clearvars i j str temp
save D40L1