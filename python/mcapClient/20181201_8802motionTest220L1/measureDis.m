function [output]=measureDis(x1,y1,x2,y2)
    output=sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
end