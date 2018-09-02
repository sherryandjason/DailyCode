clear;clc;
load hybrid.mat
tempx1=1;
tempx2=3200;%3306
time=(tempx1:tempx2)/(4*60);
filterNum=20;
smooth_type='rlowess'
%
%Guidance
% Angle
Heading=hybrid(tempx1:tempx2, 1);
Heading_dd=smooth(Heading,filterNum,smooth_type);
figure
plot(time, Heading)
%
%localization
xPosition=hybrid(tempx1:tempx2, 2);
xPosition_dd=smooth(xPosition,20,smooth_type);
yPosition=hybrid(tempx1:tempx2, 3);
yPosition_dd=smooth(yPosition,10,smooth_type);
figure
plot(xPosition_dd, yPosition_dd)
%% Distance
for i=1:1440
    if i==1
        Distance(i)=0;
    else
        Distance(i)=sqrt((xPosition(i)-xPosition(i-1))^2+(yPosition(i)-yPosition(i-1))^2);
    end
end
%% Speed
for i=1:3200
    if i<5
        Speed(i)=0;
    else
        Speed(i)=sqrt((xPosition(i)-xPosition(i-4))^2+(yPosition(i)-yPosition(i-4))^2);
    end
end
Speed_dd=smooth(Speed,20,smooth_type);
max_Speed=max(Speed_dd(1:1440));
average_Speed=mean(Speed(1:1440));
figure
plot(time, Speed)
% Motor Left and Right
MotorLCmd=hybrid(tempx1:tempx2, 4);
MotorLCmd_dd=smooth(MotorLCmd,10,smooth_type);
MotorRCmd=hybrid(tempx1:tempx2, 5);
MotorRCmd_dd=smooth(MotorRCmd,30,smooth_type);
figure
plot(time, MotorLCmd)
figure
plot(time, MotorRCmd)
% Sail & Rudder command
SailCmd=hybrid(tempx1:tempx2, 6);
SailCmd_dd=smooth(SailCmd,10,smooth_type);
RudCmd=hybrid(tempx1:tempx2, 7);
RudCmd_dd=smooth(RudCmd,30,smooth_type);
figure
plot(time, SailCmd_dd)
figure
plot(time, RudCmd_dd)
% Voltage
Voltage=hybrid(tempx1:tempx2, 8);
Voltage_dd=smooth(Voltage,10,smooth_type);
Current=hybrid(tempx1:tempx2, 10)/1000;
Current_dd=smooth(Current,filterNum,smooth_type);
Power=hybrid(tempx1:tempx2, 12)/1000;
Power_dd=smooth(Power,filterNum,smooth_type);
for i=1:3200
    if i==1
        Energy(i)=Power(1);
    else
        temp=Power(i);
        Energy(i)=Energy(i-1)+temp;
    end
end
EnergyTotal=Energy(1440);
figure
plot(time, Voltage_dd)
figure
plot(time, Current)
figure
plot(time, Energy)

% subplot
close all
plotrow=2;
plotcolo=4;
startTime=0;
endTime=6;
figure
subplot(plotrow,plotcolo,1)
plot(yPosition_dd(1:1440),xPosition_dd(1:1440))
grid on
set(gca,'YDir','reverse')
%axis square
%xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Trajactories')
xlabel('x/pixel');ylabel("y/pixel")
subplot(plotrow,plotcolo,2)
plot(time,Speed_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Velocity')
xlabel('t/min');ylabel("pixel/s")
subplot(plotrow,plotcolo,3)
plot(time,SailCmd_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Sail Command')
xlabel('t/min');ylabel("Command")
subplot(plotrow,plotcolo,4)
plot(time,RudCmd_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Rudder Command')
xlabel('t/min');ylabel("Command")
subplot(plotrow,plotcolo,5)
plot(time,MotorLCmd,'b')
grid on
hold on
plot(time,MotorRCmd,'r')
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}motor Command')
xlabel('t/min');ylabel("Command")
subplot(plotrow,plotcolo,6)
plot(time,Heading_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Heading')
xlabel('t/min');ylabel("Degree/\circ")
subplot(plotrow,plotcolo,7)
plot(time,Voltage_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Voltage')
xlabel('t/min');ylabel("Volt/V")
subplot(plotrow,plotcolo,8)
plot(time,Energy)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Energy')
xlabel('t/min');ylabel("Q/J")