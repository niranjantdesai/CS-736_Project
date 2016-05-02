function [matchingPatchIndices,matchingDist] = FindMatches( patch, samplePatches, mask, ...
    errorThreshold )
%FindMatches Find matching patches for Efros's algo
% Input arguments
% template - patch to be searched for
% sampleImage - search space
% validMask - 1s where Template is filled, 0s otherwise
% errorThreshold

mask = mask(:);
totalWeight = sum(sum(mask));
% mask for color images
mask = repmat(mask,3,1);



% replicate for calculatation of distance
maskMat = repmat(mask,1,size(samplePatches,2));
patchMat = repmat(patch,1,size(samplePatches,2));

% calculate distance from each patch
dist = (samplePatches-patchMat).^2;

ssd = sum(dist.*maskMat)/totalWeight;


% find patches which are good enough match
matchingPatchIndices = find(ssd <= (min(ssd)+0.0001).*(1 + errorThreshold));
matchingDist = ssd(matchingPatchIndices);


end

