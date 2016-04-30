function [ x1,y1,x2,y2,off_x1,off_y1,off_x2,off_y2 ] = GetPatchBounds( x,y,X,Y,windowSize )
%GetPatchBounds Adjusts the patch to be within image bounds

x1 = x-windowSize;
y1 = y-windowSize;
x2 = x+windowSize;
y2 = y+windowSize;

off_x1 = 0;
off_x2 = 0;
off_y1 = 0;
off_y2 = 0;

if x1<1
    off_x1 = 1-x1;
    x1 = 1;
end
if y1<1
    off_y1 = 1-y1;
    y1 = 1;
end
if x2>X
    off_x2 = x2-X;
    x2 = X;
end
if y2>Y
    off_y2 = y2-Y;
    y2 = Y;
end


end

