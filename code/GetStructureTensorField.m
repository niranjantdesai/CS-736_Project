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
tensorSmoothingSigma = 4;
smoothMIxIx = reshape(imgaussfilt(mIxIx,tensorSmoothingSigma),N,1);
smoothMIxIy = reshape(imgaussfilt(mIxIy,tensorSmoothingSigma),N,1);
smoothMIyIy = reshape(imgaussfilt(mIyIy,tensorSmoothingSigma),N,1);


% Calc smoothing geometry tensor field
Tau = ( smoothMIyIy - smoothMIxIx ) ./ ( 2 * smoothMIxIy );
t   = sign(Tau) ./ ( abs(Tau) + sqrt( 1 + (Tau .* Tau) ) );
c   = 1 ./ sqrt( 1 + (t .* t) );
s   = c .* t;

vecA = cat(3, c, -s); 
vecB = cat(3, s, c);  

valA = smoothMIxIx - ( t .* smoothMIxIy ); 
valB = smoothMIyIy + ( t .*smoothMIxIy ); 

mMinLambdaMask = valA < valB;
tMinLambdaMask = cat(3, mMinLambdaMask, mMinLambdaMask);

% eigenval2 is the bigger eigenvalue
eigenval1 = mMinLambdaMask .* valA + (1 - mMinLambdaMask) .* valB;
eigenval2 = mMinLambdaMask .* valB + (1 - mMinLambdaMask) .* valA;

v1 = tMinLambdaMask .* vecA + (1 - tMinLambdaMask) .* vecB;
v2 = tMinLambdaMask .* vecB + (1 - tMinLambdaMask) .* vecA;

coeff1 = (1+eigenval1+eigenval2).^-(p1/2);
coeff2 = (1+eigenval1+eigenval2).^-(p2/2);

sqrtT = [coeff1.*(v1(:,1).^2), coeff1.*v1(:,1).*v1(:,2), coeff1.*(v1(:,2).^2)] + ...
    [coeff2.*(v2(:,1).^2), coeff2.*v2(:,1).*v2(:,2), coeff2.*(v2(:,2).^2)];

sqrtT(isnan(sqrtT)) = 1;

end
