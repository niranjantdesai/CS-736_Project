% Inpainting using Efros non-parametric sampling paper
% pseudocode - http://graphics.cs.cmu.edu/people/efros/research/NPS/alg.html

% Adopted from: Zeeshan Lakhani

function outImg = EfrosInpainting(inImg,specMap)
%EfrosInpainting Spec. removal via Efros's inpainting
% Input arguments
% inImg: input image
% specMap: specularity map (0-speckle)

X = size(inImg,1);
Y = size(inImg,2);


mask = specMap(:,:,1);

% **get unfilled pixels which are on the border**
negMask = ~mask;
se = strel('square',3);
border_mask = negMask - imerode(negMask,se); %obtain dilation and subtract to obtain unfilled neighbors
[rows,cols] = find(border_mask); %get coordinate values

% Pixel list is the list on unfilled pixels
PixelList = [rows, cols];

% ** Defining params**
errThreshold = 0.4; %constant given by pseudo code
maxErrThreshold = 0.5; %constant given by pseudo code
windowSize = 13;
sigma = (windowSize*2 + 1)/6.4; %compute sigma...based on formula in pseudo code

gaussianMask = fspecial('gaussian',windowSize*2 + 1,sigma); %create 2d Gaussian mask
dotMask = zeros(size(gaussianMask));


outImg = inImg;
outImg(~specMap) = 0;

% regenerate patches
tempPatches = mexExtractPatches(outImg,2*windowSize+1,1);

% select only patches not having the specularity
maskPatches = mexExtractPatches(double(negMask),2*windowSize+1,1);

xPatches = tempPatches(:,sum(maskPatches)>0);


while ~isempty(PixelList) %while hole is not filled
    disp('itering');
    
    disp(size(PixelList,1));

    progress = 0;
    % loop for unfilled pixels
    for i=1:size(PixelList,1)
        
        % template for patch
        patch = zeros(2*windowSize+1,2*windowSize+1,size(inImg,3));
        validMask = zeros(size(gaussianMask));
        % get the patch for the current pixelList
        x = PixelList(i,1);
        y = PixelList(i,2);
        
        [ x1,y1,x2,y2,off_x1,off_y1,off_x2,off_y2 ] = GetPatchBounds( ...
            x,y,X,Y,windowSize );
        
        patch(1+off_x1:2*windowSize+1-off_x2,1+off_y1:2*windowSize+1-off_y2,:) = ...
            inImg(x1:x2,y1:y2,:);
        %disp('patch center val');
        %disp(patch(1+windowSize,1+windowSize,:));
        validMask(1+off_x1:2*windowSize+1-off_x2,1+off_y1:2*windowSize+1-off_y2) = ...
            mask(x1:x2,y1:y2,1);
        
%         figure(1);
%         imshow(patch);
%         figure(2);
%         imagesc(validMask)
        dotMask = validMask.*gaussianMask;
        
        [patchIdx,errors] = FindMatches(patch(:),xPatches,dotMask,errThreshold);
        
        % picking best match randomly
        bestMatchIdx = unidrnd(length(patchIdx));
        bestMatchPatch = reshape(xPatches(:,patchIdx(bestMatchIdx)),2*windowSize+1,2*windowSize+1,3);
        
        if errors(bestMatchIdx) < maxErrThreshold
            outImg(x,y,:) = bestMatchPatch(windowSize+1,windowSize+1,:);
            %disp('updated value');
            %disp(outImg(x,y,:));
            inImg(x,y,:) = bestMatchPatch(windowSize+1,windowSize+1,:);
            progress = 1;
            mask(x,y) = 1;
            %fprintf('painted pixel at (%d,%d)\n',x,y);
        end 
    end
    if progress == 0
        maxErrThreshold = maxErrThreshold*1.1;
        disp(' no update');
    else
        % update the mask
        % **get unfilled pixels which are on the border**
        negMask = ~mask;
        se = strel('square',3);
        border_mask = negMask - imerode(negMask,se); %obtain dilation and subtract to obtain unfilled neighbors
        [rows,cols] = find(border_mask); %get coordinate values

        % Pixel list is the list on unfilled pixels
        PixelList = [rows, cols];
        
        % regenerate patches
        % xPatches = mexExtractPatches(outImg,2*windowSize+1,1);
    end
end
