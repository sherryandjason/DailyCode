clear;clc
load sensor.mat
tempx1=1;
tempx2=749;
time=(tempx1:tempx2)/(6*60);
filterNum=20;
smooth_type='rlowess'
%% Position
load IROS2018.mat
xPosition=IROS2018(:,2);
xPosition_dd=smooth(xPosition,filterNum,smooth_type);
yPosition=IROS2018(:,4);
yPosition_dd=smooth(yPosition,filterNum,smooth_type);
figure
plot(xPosition_dd, yPosition_dd)
%% Distance
for i=54:720
    if i==1
        Distance(i)=0;
    else
        Distance(i)=sqrt((xPosition(i)-xPosition(i-1))^2+(yPosition(i)-yPosition(i-1))^2);
    end
end
%% Speed
for i=1:1256
    if i<7
        Speed(i)=0;
    else
        Speed(i)=sqrt((xPosition(i)-xPosition(i-6))^2+(yPosition(i)-yPosition(i-6))^2);
    end
end
Speed_dd=smooth(Speed,20,smooth_type);
max_Speed=max(Speed_dd(54:720));
average_Speed=mean(Speed(54:720));
figure
time_speed=(1:size(xPosition,1))/(6*30);
plot(time_speed, Speed)
%% heading
heading=sensor(tempx1:tempx2, 6)+120;
heading_dd=smooth(heading,filterNum,smooth_type);
%heading_dd=medfit1(heading,40);

SailCmd=sensor(tempx1:tempx2, 8);
SailCmd_dd=smooth(SailCmd,10,smooth_type);
RudCmd=sensor(tempx1:tempx2, 10);
RudCmd_dd=smooth(RudCmd,10,smooth_type);
Current=sensor(tempx1:tempx2, 12)/1000;
Current_dd=smooth(Current,filterNum,smooth_type);
Voltage=sensor(tempx1:tempx2, 14);
Voltage_dd=smooth(Voltage,8,smooth_type);
for i=1:749
    if i==1
        Energy(i)=0;
    else
        temp=Current(i)*Voltage(i)*0.2;
        Energy(i)=Energy(i-1)+temp;
    end
end
EnergyTotal=Energy(720)-Energy(54);
WindDirection=sensor(tempx1:tempx2, 18);
WindDirection_dd=smooth(WindDirection,filterNum,smooth_type);
WindDirection_dd_angle=WindDirection_dd/5*360;
I=sensor(tempx1:tempx2, 20);
I_dd=smooth(I,filterNum,smooth_type);
J=sensor(tempx1:tempx2, 22);
J_dd=smooth(J,filterNum,smooth_type);
K=sensor(tempx1:tempx2, 24);
K_dd=smooth(K,filterNum,smooth_type);
L=sensor(tempx1:tempx2, 26);
L_dd=smooth(L,filterNum,smooth_type);

%%
%close all
plotrow=3;
plotcolo=4;
startTime=0.15;
endTime=2;
figure
subplot(plotrow,plotcolo,1)
plot(xPosition_dd(54:720), yPosition_dd(54:720))
grid on
set(gca,'YDir','reverse')
axis square
xlim([0,900])
ylim([300,1200])
title('\fontsize{10}\fontname{Times new roman}Trajactories')
xlabel('x/pixel');ylabel("y/pixel")
subplot(plotrow,plotcolo,2)
plot(time,Speed_dd(1:size(time,2)))
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Velocity')
xlabel('t/min');ylabel("pixel/s")
subplot(plotrow,plotcolo,3)
plot(time,WindDirection_dd_angle)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Apparent Wind Direction')
xlabel('t/min');ylabel("Degree/\circ")
subplot(plotrow,plotcolo,4)
plot(time,heading_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Heading')
xlabel('t/min');ylabel("Degree/\circ")
subplot(plotrow,plotcolo,5)
plot(time,I_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Angle I')
xlabel('t/min');ylabel("Degree/\circ")
subplot(plotrow,plotcolo,6)
plot(time,J_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Angle J')
xlabel('t/min');ylabel("Degree/\circ")
subplot(plotrow,plotcolo,7)
plot(time,K_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Angle K')
xlabel('t/min');ylabel("Degree/\circ")
subplot(plotrow,plotcolo,8)
plot(time,L_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Angle L')
xlabel('t/min');ylabel("Degree/\circ")
subplot(plotrow,plotcolo,9)
plot(time,SailCmd_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Sail Command')
xlabel('t/min');ylabel("Command")
subplot(plotrow,plotcolo,10)
plot(time,RudCmd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Rudder Command')
xlabel('t/min');ylabel("Command")
subplot(plotrow,plotcolo,11)
plot(time,Voltage_dd)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Voltage')
xlabel('t/min');ylabel("Volt/V")
subplot(plotrow,plotcolo,12)
plot(time,Energy)
grid on
axis square
xlim([startTime,endTime])
title('\fontsize{10}\fontname{Times new roman}Energy')
xlabel('t/min');ylabel("/J")