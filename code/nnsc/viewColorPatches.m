function img = viewColorPatches(inpPatches,patchSize)
    % constrast stretching for each patch
    
    numPatches = size(inpPatches,2); 
    
    % convert to perfect square
    temp = ceil(sqrt(numPatches));
    newNum = temp*temp;
    
    patches = zeros(size(inpPatches,1),newNum);
    patches(:,1:numPatches) = inpPatches;
    
    imSize = patchSize*temp;
    
    for i=1:numPatches
        minIntensity = min(min(inpPatches(:,i)));
        maxIntensity = max(max(inpPatches(:,i)));
        
        patches(:,i) = (patches(:,i)-minIntensity)/(maxIntensity-minIntensity);
    end
    
    imgRed = col2im(patches(1:64,:),[patchSize patchSize],[imSize imSize],'distinct');
    imgGreen = col2im(patches(65:128,:),[patchSize patchSize],[imSize imSize],'distinct');
    imgBlue = col2im(patches(129:192,:),[patchSize patchSize],[imSize imSize],'distinct');
    
    img = zeros(size(imgRed,1),size(imgRed,2),3);
    img(:,:,1) = imgRed;
    img(:,:,2) = imgGreen;
    img(:,:,3) = imgBlue;
