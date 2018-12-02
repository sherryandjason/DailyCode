clc;clear;close all;
load D220L1
S130S=find(D220L1S130(5:end,14)>-200,1)+4;
S130E=find(D220L1S130(1:end,14)>300,1);
S120S=find(D220L1S120(5:end,14)>-200,1)+4;
S120E=find(D220L1S120(1:end,14)>300,1);
S110S=find(D220L1S110(5:end,14)>-200,1)+4;
S110E=find(D220L1S110(1:end,14)>300,1);
S100S=find(D220L1S100(5:end,14)>-200,1)+4;
S100E=find(D220L1S100(1:end,14)>300,1);
S90S=find(D220L1S90(5:end,14)>-200,1)+4;
S90E=find(D220L1S90(1:end,14)>300,1);
S80S=find(D220L1S80(5:end,14)>-200,1)+4;
S80E=find(D220L1S80(1:end,14)>300,1);
S70S=find(D220L1S70(5:end,14)>-200,1)+4;
S70E=find(D220L1S70(1:end,14)>300,1);
S60S=find(D220L1S60(5:end,14)>-200,1)+4;
S60E=find(D220L1S60(1:end,14)>300,1);
S50S=find(D220L1S50(5:end,14)>-200,1)+4;
S50E=find(D220L1S50(1:end,14)>300,1);
S40S=find(D220L1S40(5:end,14)>-200,1)+4;
S40E=find(D220L1S40(1:end,14)>300,1);
S30S=find(D220L1S30(5:end,14)>-200,1)+4;
S30E=find(D220L1S30(1:end,14)>300,1);

xPosition=14;
yPosition=16;

%% path
figure
hold on
plot(D220L1S130(S130S:S130E,xPosition),D220L1S130(S130S:S130E,yPosition),'r')
text(D220L1S130(S130E,xPosition),D220L1S130(S130E,yPosition),'130')
hold on
plot(D220L1S120(S120S:S120E,xPosition),D220L1S120(S120S:S120E,yPosition),'k')
text(D220L1S120(S120E,xPosition),D220L1S120(S120E,yPosition),'120')
hold on
plot(D220L1S110(S110S:S110E,xPosition),D220L1S110(S110S:S110E,yPosition),'b')
text(D220L1S110(S110E,xPosition),D220L1S110(S110E,yPosition),'110')
hold on
plot(D220L1S100(S100S:S100E,xPosition),D220L1S100(S100S:S100E,yPosition))
text(D220L1S100(S100E,xPosition),D220L1S100(S100E,yPosition)-5,'100')
hold on
plot(D220L1S90(S90S:S90E,xPosition),D220L1S90(S90S:S90E,yPosition))
text(D220L1S90(S90E,xPosition),D220L1S90(S90E,yPosition)+5,'90')
hold on
plot(D220L1S80(S80S:S80E,xPosition),D220L1S80(S80S:S80E,yPosition))
text(D220L1S80(S80E,xPosition),D220L1S80(S80E,yPosition),'80')
hold on
plot(D220L1S70(S70S:S70E,xPosition),D220L1S70(S70S:S70E,yPosition))
hold on
plot(D220L1S60(S60S:S60E,xPosition),D220L1S60(S60S:S60E,yPosition))
hold on
plot(D220L1S50(S50S:S50E,xPosition),D220L1S50(S50S:S50E,yPosition))
hold on
plot(D220L1S40(S40S:S40E,xPosition),D220L1S40(S40S:S40E,yPosition))
hold on
plot(D220L1S30(S30S:S30E,xPosition),D220L1S30(S30S:S30E,yPosition))
legend('130','120','110','100','90','80','70','60','50','40','30')
axis([-250,450,-150,550])
grid on

%% velocity
filter=20;
duration=30;
for i=S130S:S130E
    if i<S130E-duration
        V130(i-S130S+1)=measureDis(D220L1S130(i,xPosition),D220L1S130(i,yPosition),D220L1S130(i+duration,xPosition),D220L1S130(i+duration,yPosition));
    end
end
V130D = smooth(V130,filter);

for i=S120S:S120E
    if i<S120E-duration
        V120(i-S120S+1)=measureDis(D220L1S120(i,xPosition),D220L1S120(i,yPosition),D220L1S120(i+duration,xPosition),D220L1S120(i+duration,yPosition));
    end
end
V120D = smooth(V120,filter);

for i=S110S:S110E
    if i<S110E-duration
        V110(i-S110S+1)=measureDis(D220L1S110(i,xPosition),D220L1S110(i,yPosition),D220L1S110(i+duration,xPosition),D220L1S110(i+duration,yPosition));
    end
end
V110D = smooth(V110,filter);

for i=S100S:S100E
    if i<S100E-duration
        V100(i-S100S+1)=measureDis(D220L1S100(i,xPosition),D220L1S100(i,yPosition),D220L1S100(i+duration,xPosition),D220L1S100(i+duration,yPosition));
    end
end
V100D = smooth(V100,filter);

for i=S90S:S90E
    if i<S90E-duration
        V90(i-S90S+1)=measureDis(D220L1S90(i,xPosition),D220L1S90(i,yPosition),D220L1S90(i+duration,xPosition),D220L1S90(i+duration,yPosition));
    end
end
V90D = smooth(V90,filter);

for i=S80S:S80E
    if i<S80E-duration
        V80(i-S80S+1)=measureDis(D220L1S80(i,xPosition),D220L1S80(i,yPosition),D220L1S80(i+duration,xPosition),D220L1S80(i+duration,yPosition));
    end
end
V80D = smooth(V80,filter);

for i=S70S:S70E
    if i<S70E-duration
        V70(i-S70S+1)=measureDis(D220L1S70(i,xPosition),D220L1S70(i,yPosition),D220L1S70(i+duration,xPosition),D220L1S70(i+duration,yPosition));
    end
end
V70D = smooth(V70,filter);

for i=S60S:S60E
    if i<S60E-duration
        V60(i-S60S+1)=measureDis(D220L1S60(i,xPosition),D220L1S60(i,yPosition),D220L1S60(i+duration,xPosition),D220L1S60(i+duration,yPosition));
    end
end
V60D = smooth(V60,filter);

for i=S50S:S50E
    if i<S50E-duration
        V50(i-S50S+1)=measureDis(D220L1S50(i,xPosition),D220L1S50(i,yPosition),D220L1S50(i+duration,xPosition),D220L1S50(i+duration,yPosition));
    end
end
V50D = smooth(V50,filter);

for i=S40S:S40E
    if i<S40E-duration
        V40(i-S40S+1)=measureDis(D220L1S40(i,xPosition),D220L1S40(i,yPosition),D220L1S40(i+duration,xPosition),D220L1S40(i+duration,yPosition));
    end
end
V40D = smooth(V40,filter);

for i=S30S:S30E
    if i<S30E-duration
        V30(i-S30S+1)=measureDis(D220L1S30(i,xPosition),D220L1S30(i,yPosition),D220L1S30(i+duration,xPosition),D220L1S30(i+duration,yPosition));
    end
end
V30D = smooth(V30,filter);

figure
plot(1:size(V130D,1),V130D,'r')
text(size(V130D,1),V130D(end),'130')
hold on
plot(1:size(V120D,1),V120D,'b')
text(size(V120D,1),V120D(end),'120')
hold on
plot(1:size(V110D,1),V110D,'k')
text(size(V110D,1),V110D(end),'110')
hold on
plot(1:size(V100D,1),V100D)
text(size(V100D,1),V100D(end),'100')
hold on
plot(1:size(V90D,1),V90D)
text(size(V90D,1),V90D(end),'90')
hold on
plot(1:size(V80D,1),V80D)
text(size(V80D,1),V80D(end),'80')
hold on
plot(1:size(V70D,1),V70D)
text(size(V70D,1),V70D(end),'70')
hold on
plot(1:size(V60D,1),V60D)
text(size(V60D,1),V60D(end),'60')
hold on
plot(1:size(V50D,1),V50D)
text(size(V50D,1),V50D(end),'50')
hold on
plot(1:size(V40D,1),V40D)
text(size(V40D,1),V40D(end),'40')
hold on
plot(1:size(V30D,1),V30D)
text(size(V30D,1),V30D(end),'30')
legend('130','120','110','100','90','80','70','60','50','40','30')
grid on

%% heading
filter=5;
H130D=smooth(D220L1S130(S130S:S130E,31),filter);
H120D=smooth(D220L1S120(S120S:S120E,31),filter);
H110D=smooth(D220L1S110(S110S:S110E,31),filter);
H100D=smooth(D220L1S100(S100S:S100E,31),filter);
H90D=smooth(D220L1S90(S90S:S90E,31),filter);
H80D=smooth(D220L1S80(S80S:S80E,31),filter);
H70D=smooth(D220L1S70(S70S:S70E,31),filter);
H60D=smooth(D220L1S60(S60S:S60E,31),filter);
H50D=smooth(D220L1S50(S50S:S50E,31),filter);
H40D=smooth(D220L1S40(S40S:S40E,31),filter);
H30D=smooth(D220L1S30(S30S:S30E,31),filter);

figure
plot(1:size(S130S:S130E,2),H130D);
text(size(S130S:S130E,2),D220L1S130(S130E,31),'130');
hold on
plot(1:size(S120S:S120E,2),H120D);
text(size(S120S:S120E,2),D220L1S120(S120E,31),'120');
hold on
plot(1:size(S110S:S110E,2),H110D);
text(size(S110S:S110E,2),D220L1S110(S110E,31),'110');
hold on
plot(1:size(S100S:S100E,2),H100D);
text(size(S100S:S100E,2),D220L1S100(S100E,31),'100');
hold on
plot(1:size(S90S:S90E,2),H90D);
text(size(S90S:S90E,2),D220L1S90(S90E,31),'90');
hold on
plot(1:size(S80S:S80E,2),H80D);
text(size(S80S:S80E,2),D220L1S80(S80E,31),'80');
hold on
plot(1:size(S70S:S70E,2),H70D);
text(size(S70S:S70E,2),D220L1S70(S70E,31),'70');
hold on
plot(1:size(S60S:S60E,2),H60D);
text(size(S60S:S60E,2),D220L1S60(S60E,31),'60');
hold on
plot(1:size(S50S:S50E,2),H50D);
text(size(S50S:S50E,2),D220L1S50(S50E,31),'50');
hold on
plot(1:size(S40S:S40E,2),H40D);
text(size(S40S:S40E,2),D220L1S40(S40E,31),'40');
hold on
plot(1:size(S30S:S30E,2),H30D);
text(size(S30S:S30E,2),D220L1S30(S30E,31),'30');
legend('130','120','110','100','90','80','70','60','50','40','30')
grid on
