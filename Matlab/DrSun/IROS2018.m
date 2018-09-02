clear;clc
filterNum=20;
smooth_type='rlowess'
load IROS2018.mat
xPosition=IROS2018(:,2);
xPosition_dd=smooth(xPosition,filterNum,smooth_type);
yPosition=IROS2018(:,4);
yPosition_dd=smooth(yPosition,filterNum,smooth_type);
figure
plot(xPosition_dd, yPosition_dd)