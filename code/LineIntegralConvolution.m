function outImg = LineIntegralConvolution( inpImg, w, lengthLimit , stepSize)
%LineIntegralConvolution Performs line integral convolution of the image along
%the vector field

outImg = zeros(size(inpImg));

numRows = size(inpImg,1);
numCols = size(inpImg,2);

for x=1:numRows
    for y=1:numCols
        val = 0;
        count = 0;
        
        
        
        % Forward movement
        lengthCovered = 0;
        xCurrent = x;
        yCurrent = y;
        xNext = x;
        yNext = y;
        while(lengthCovered<lengthLimit(x,y)/2)
            xCurrent = round(xNext);
            yCurrent = round(yNext);
            
            % Check if we are in-bounds
            if xCurrent<=0 || xCurrent>numRows || yCurrent<=0 || yCurrent>numCols
                break;
            end
            
            val = val + inpImg(xCurrent, yCurrent,:);
            count = count+1;
            
            % Move along the curve
            xNext = xCurrent + w(xCurrent, yCurrent, 2);
            yNext = yCurrent + w(xCurrent, yCurrent, 1);
            lengthCovered = lengthCovered + stepSize;
        end
        
        % Backward movement
        lengthCovered = 0;
        xCurrent = x;
        yCurrent = y;
        xNext = x;
        yNext = y;
        while(lengthCovered<lengthLimit(x,y)/2)
            xCurrent = round(xNext);
            yCurrent = round(yNext);
            
            % Check if we are in-bounds
            if xCurrent<=0 || xCurrent>numRows || yCurrent<=0 || yCurrent>numCols
                break;
            end
            
            val = val + inpImg(xCurrent, yCurrent,:);
            count = count+1;
            
            % Move along the curve
            xNext = xCurrent - w(xCurrent, yCurrent, 2);
            yNext = yCurrent - w(xCurrent, yCurrent, 1);
            lengthCovered = lengthCovered + stepSize;
        end
        
        
        outImg(x,y,:) = outImg(x,y,:) + val./count; 
        
    end
end
        


end

