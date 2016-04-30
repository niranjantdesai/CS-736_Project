function img = viewPatches(inpPatches,patchSize)
    % constrast stretching for each patch
    
    numPatches = size(inpPatches,2); % must be a perfect square
    
    imSize = patchSize*floor(sqrt(numPatches));
    
    for i=1:numPatches
        minIntensity = min(min(inpPatches(:,i)));
        maxIntensity = max(max(inpPatches(:,i)));
        
        inpPatches(:,i) = (inpPatches(:,i)-minIntensity)/(maxIntensity-minIntensity);
    end
    
    img = col2im(inpPatches,[patchSize patchSize],[imSize imSize],'distinct');

