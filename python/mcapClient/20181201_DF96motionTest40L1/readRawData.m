clc;clear
str={'D40L1S70','D40L1S75','D40L1S80','D40L1S85','D40L1S90','D40L1S100','D40L1S110','D40L1S120','D40L1S130'} ;
num=[70,75,80,85,90,100,110,120,130];
for i=1:length(str)
    temp=importfile(['comSailboat_mcap_IC _DF_motionTest_S',mat2str(num(i)),'.txt']);
    eval([cell2mat(str(i)) '=' mat2str(temp)]);
end
clearvars i j str temp num
save D40L1