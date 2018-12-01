clc;clear;close all;
load D40L1
S130S=find(D40L1S130(5:end,14)>-200,1)+4;
S130E=find(D40L1S130(1:end,14)>300,1);
S120S=find(D40L1S120(5:end,14)>-200,1)+4;
S120E=find(D40L1S120(1:end,14)>300,1);
S110S=find(D40L1S110(5:end,14)>-200,1)+4;
S110E=find(D40L1S110(1:end,14)>300,1);
S100S=find(D40L1S100(5:end,14)>-200,1)+4;
S100E=find(D40L1S100(1:end,14)>300,1);
S90S=find(D40L1S90(5:end,14)>-200,1)+4;
S90E=find(D40L1S90(1:end,14)>300,1);
S80S=find(D40L1S80(5:end,14)>-200,1)+4;
S80E=find(D40L1S80(1:end,14)>300,1);
S70S=find(D40L1S70(10:end,14)>-200,1)+4;
S70E=find(D40L1S70(1:end,14)>300,1);
S85S=find(D40L1S85(5:end,14)>-200,1)+4;
S85E=161;
S75S=find(D40L1S75(5:end,14)>-200,1)+4;
S75E=find(D40L1S75(1:end,14)>300,1);

xPosition=14;
yPosition=16;

%% path
figure
hold on
plot(D40L1S130(S130S:S130E,xPosition),D40L1S130(S130S:S130E,yPosition),'r')
text(D40L1S130(S130E,xPosition),D40L1S130(S130E,yPosition),'130')
hold on
plot(D40L1S120(S120S:S120E,xPosition),D40L1S120(S120S:S120E,yPosition),'k')
text(D40L1S120(S120E,xPosition),D40L1S120(S120E,yPosition),'120')
hold on
plot(D40L1S110(S110S:S110E,xPosition),D40L1S110(S110S:S110E,yPosition),'b')
text(D40L1S110(S110E,xPosition),D40L1S110(S110E,yPosition),'110')
hold on
plot(D40L1S100(S100S:S100E,xPosition),D40L1S100(S100S:S100E,yPosition))
text(D40L1S100(S100E,xPosition),D40L1S100(S100E,yPosition)-5,'100')
hold on
plot(D40L1S90(S90S:S90E,xPosition),D40L1S90(S90S:S90E,yPosition))
text(D40L1S90(S90E,xPosition),D40L1S90(S90E,yPosition)+5,'90')
hold on
plot(D40L1S80(S80S:S80E,xPosition),D40L1S80(S80S:S80E,yPosition))
text(D40L1S80(S80E,xPosition),D40L1S80(S80E,yPosition),'80')
hold on
plot(D40L1S70(S70S:S70E,xPosition),D40L1S70(S70S:S70E,yPosition))
text(D40L1S70(S70E,xPosition),D40L1S70(S70E,yPosition),'70')
hold on
plot(D40L1S85(S85S:S85E,xPosition),D40L1S85(S85S:S85E,yPosition))
text(D40L1S85(S85E,xPosition),D40L1S85(S85E,yPosition),'85')
hold on
plot(D40L1S75(S75S:S75E,xPosition),D40L1S75(S75S:S75E,yPosition))
text(D40L1S75(S75E,xPosition),D40L1S75(S75E,yPosition),'75')
hold on
legend('130','120','110','100','90','80','70','85','75')
axis([-275,475,-175,575])
grid on

%% velocity
filter=30;
duration=30;
for i=S130S:S130E
    if i<S130E-duration
        V130(i-S130S+1)=measureDis(D40L1S130(i,xPosition),D40L1S130(i,yPosition),D40L1S130(i+duration,xPosition),D40L1S130(i+duration,yPosition));
    end
end
V130D = smooth(V130,filter);

for i=S120S:S120E
    if i<S120E-duration
        V120(i-S120S+1)=measureDis(D40L1S120(i,xPosition),D40L1S120(i,yPosition),D40L1S120(i+duration,xPosition),D40L1S120(i+duration,yPosition));
    end
end
V120D = smooth(V120,filter);

for i=S110S:S110E
    if i<S110E-duration
        V110(i-S110S+1)=measureDis(D40L1S110(i,xPosition),D40L1S110(i,yPosition),D40L1S110(i+duration,xPosition),D40L1S110(i+duration,yPosition));
    end
end
V110D = smooth(V110,filter);

for i=S100S:S100E
    if i<S100E-duration
        V100(i-S100S+1)=measureDis(D40L1S100(i,xPosition),D40L1S100(i,yPosition),D40L1S100(i+duration,xPosition),D40L1S100(i+duration,yPosition));
    end
end
V100D = smooth(V100,filter);

for i=S90S:S90E
    if i<S90E-duration
        V90(i-S90S+1)=measureDis(D40L1S90(i,xPosition),D40L1S90(i,yPosition),D40L1S90(i+duration,xPosition),D40L1S90(i+duration,yPosition));
    end
end
V90D = smooth(V90,filter);

for i=S80S:S80E
    if i<S80E-duration
        V80(i-S80S+1)=measureDis(D40L1S80(i,xPosition),D40L1S80(i,yPosition),D40L1S80(i+duration,xPosition),D40L1S80(i+duration,yPosition));
    end
end
V80D = smooth(V80,filter);

for i=S70S:S70E
    if i<S70E-duration
        V70(i-S70S+1)=measureDis(D40L1S70(i,xPosition),D40L1S70(i,yPosition),D40L1S70(i+duration,xPosition),D40L1S70(i+duration,yPosition));
    end
end
V70D = smooth(V70,filter);

for i=S85S:S85E
    if i<S85E-duration
        V85(i-S85S+1)=measureDis(D40L1S85(i,xPosition),D40L1S85(i,yPosition),D40L1S85(i+duration,xPosition),D40L1S85(i+duration,yPosition));
    end
end
V85D = smooth(V85,filter);

for i=S75S:S75E
    if i<S75E-duration
        V75(i-S75S+1)=measureDis(D40L1S75(i,xPosition),D40L1S75(i,yPosition),D40L1S75(i+duration,xPosition),D40L1S75(i+duration,yPosition));
    end
end
V75D = smooth(V75,filter);


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
plot(1:size(V85D,1),V85D)
text(size(V85D,1),V85D(end),'85')
hold on
plot(1:size(V75D,1),V75D)
text(size(V75D,1),V75D(end),'75')
legend('130','120','110','100','90','80','70','85','75')
grid on