clear;clc;
load single.mat
tempx1=200;
tempx2=1400;%1400
time=(tempx1:tempx2)/(10*60);
filterNum=20;
smooth_type='rlowess'
%%
%%Guidance
Guidance=single(tempx1:tempx2, 5);
Guidance_dd=smooth(Guidance,filterNum,smooth_type);
figure
plot(time, Guidance)
%%
%%localization
xPosition=single(tempx1:tempx2, 7);
xPosition_dd=smooth(xPosition,20,smooth_type);
yPosition=single(tempx1:tempx2, 9);
yPosition_dd=smooth(yPosition,10,smooth_type);
figure
plot(xPosition_dd, yPosition_dd)
%% Distance
for i=101:size(time,2)
    if i==1
        Distance(i)=0;
    else
        Distance(i)=sqrt((xPosition(i)-xPosition(i-1))^2+(yPosition(i)-yPosition(i-1))^2);
    end
end
%% Speed
for i=101:1201
    if i<11
        Speed(i)=0;
    else
        Speed(i)=sqrt((xPosition(i)-xPosition(i-10))^2+(yPosition(i)-yPosition(i-10))^2);
    end
end
Speed_dd=smooth(Speed,20,smooth_type);
max_Speed=max(Speed_dd(101:1201));
average_Speed=mean(Speed(101:1201));
figure
plot(time, Speed)
%% Sail & Rudder command
SailCmd=single(tempx1:tempx2, 15);
SailCmd_dd=smooth(SailCmd,10,smooth_type);
RudCmd=single(tempx1:tempx2, 17);
RudCmd_dd=smooth(RudCmd,30,smooth_type);
figure
plot(time, SailCmd_dd)
figure
plot(time, RudCmd_dd)

%% Angle
SetHeading=single(tempx1:tempx2, 21);
SetHeading_dd=smooth(SetHeading,filterNum,smooth_type);
HeadingNor=single(tempx1:tempx2, 23);
HeadingNor_dd=smooth(HeadingNor,filterNum,smooth_type);
Heading=single(tempx1:tempx2, 19);
Heading_dd=smooth(Heading,filterNum,smooth_type);

for i=1:1201
    if Heading(i)>180
        Heading(i)=180-(Heading(i)-180);
    end
end
figure
plot(time, SetHeading)
figure
plot(time, HeadingNor)
figure
plot(time, Heading)
%% Voltage
Voltage=single(tempx1:tempx2, 25);
Voltage_dd=smooth(Voltage,8,smooth_type);
Current=single(tempx1:tempx2, 27)/1000;
Current_dd=smooth(Current,filterNum,smooth_type);
Power=single(tempx1:tempx2, 29);
Power_dd=smooth(Power,filterNum,smooth_type);
for i=1:1201
    if i==1
        Energy(i)=Power(1);
    else
        temp=Power(i);
        Energy(i)=Energy(i-1)+temp;
    end
end
EnergyTotal=Energy(size(time,2))-Energy(101);
figure
plot(time, Voltage_dd)
figure
plot(time, Current)
figure
plot(time, Energy)

close all
plotrow=2;
plotcolo=4;
startTime=0.5;
endTime=2.5;
figure
subplot(plotrow,plotcolo,1)
plot(xPosition_dd(101:size(time,2)),yPosition_dd(101:size(time,2)))
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
plot(time,Guidance)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}SetHeading')
xlabel('t/min');ylabel("Degree/\circ")
subplot(plotrow,plotcolo,6)
plot(time,HeadingNor_dd)
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