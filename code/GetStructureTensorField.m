function sqrtT = GetStructureTensorField(img,p1,p2)


numChannels = size(img,3);
N = size(img,1)*size(img,2);

% Defining the 1D derivative kernel
derivativeKernel = 0.5*[-1 0 1]; % average for forward and backward gradient

% Matrix of derivatives along x and y channel
mIx = imfilter(img,derivativeKernel,'replicate','same');
mIy = imfilter(img,derivativeKernel','replicate','same');



% Construct structure tensor matrix (sum across channels)
mIxIx = sum(mIx.*mIx,3);
mIxIy = sum(mIx.*mIy,3);
mIyIy = sum(mIy.*mIy,3);

% Smoothing can be done is done individually for each component of the structure
% tensor; also vectorizing spatial coordinates
tensorSmoothingSigma = 1.1;
smoothMIxIx = reshape(imgaussfilt(mIxIx,tensorSmoothingSigma),N,1);
smoothMIxIy = reshape(imgaussfilt(mIxIy,tensorSmoothingSigma),N,1);
smoothMIyIy = reshape(imgaussfilt(mIyIy,tensorSmoothingSigma),N,1);


% Calc smoothing geometry tensor field

% Calculating eigenvalues (adapted from Eig3 files)
P3 = 1;
P2 = -(smoothMIxIx+smoothMIyIy);
P1 = smoothMIxIx.*smoothMIyIy - smoothMIxIy.^2;

% Find the roots of characteristic polynomials
eigenvals = ParabolaRoots(P3, P2, P1);

% Calculating the corresponding eigenvectors
v1_1 = sqrt(1+((eigenvals(:,1) - smoothMIxIx)./smoothMIxIy).^2).^-1;
v1_2 = ((eigenvals(:,1) - smoothMIxIx)./smoothMIxIy).*v1_1;

v2_1 = sqrt(1+((eigenvals(:,2) - smoothMIxIx)./smoothMIxIy).^2).^-1;
v2_2 = ((eigenvals(:,2) - smoothMIxIx)./smoothMIxIy).*v2_1;

coeff1 = (1+eigenvals(:,1)+eigenvals(:,2)).^-(p2/2);
coeff2 = (1+eigenvals(:,1)+eigenvals(:,2)).^-(p1/2);

sqrtT = [coeff1.*(v1_1.^2), coeff1.*v1_1.*v1_2, coeff1.*(v1_2.^2)] + ...
    [coeff2.*(v2_1.^2), coeff2.*v2_1.*v2_2, coeff2.*(v2_2.^2)];

end
