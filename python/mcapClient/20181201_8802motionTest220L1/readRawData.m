clc;clear
str={'D220L1S30','D220L1S40','D220L1S50','D220L1S60','D220L1S70','D220L1S80','D220L1S90','D220L1S100','D220L1S110','D220L1S120','D220L1S130'} ;
for i=1:length(str)
    i=11;
    j=i*10+20;
    temp=importfile(['comSailboat_mcap_IC_motionTest_S',mat2str(j),'.txt']);
    eval([cell2mat(str(i)) '=' mat2str(temp)]);
end
clearvars i j str temp
save D220L1