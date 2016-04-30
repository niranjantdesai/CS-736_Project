function outImage = SpeckleLineIntegral(inpImage,w,stepSize)

outImage = zeros(size(inpImage));

X = size(inpImage,1);
Y = size(inpImage,2);

count = zeros(X,Y);

for x=1:X
    for y=1:Y
        if x==50 && y==50
            k=1;
        end
        cx = round(x + 1*w(x,y,1));
        cy = round(y + 1*w(x,y,2));
        
        if isnan(cx) || isnan(cy)
            break;
        end
        
        if (cx > X || cy > Y || cx <= 0 || cy <= 0)
					break;
        end
        outImage(cx,cy,:) = outImage(cx,cy,:) + inpImage(x,y,:);
        count(cx,cy) = count(cx,cy)+1;
    end
end

validSet = count>0;
% channel wise averaging
channel = outImage(:,:,1);
channel(validSet) = channel(validSet)./count(validSet);
outImage(:,:,1) = channel;

% channel = outImage(:,:,2);
% channel(validSet) = channel(validSet)./count(validSet);
% outImage(:,:,2) = channel;
% 
% channel = outImage(:,:,3);
% channel(validSet) = channel(validSet)./count(validSet);
% outImage(:,:,3) = channel;

imshow(outImage);

        

