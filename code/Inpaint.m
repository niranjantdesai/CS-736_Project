function outImg = Inpaint(inpImg, specMap)
%Inpaint implements a single iteration of the process

%% Get smooth structure tensor field

p1 = 0.001;
p2 = 100;
sqrtT = GetStructureTensorField(inpImg,p1,p2);
N = size(sqrtT,1);

%% Computing the vector field for each angle
stepSize = 0.8;
alpha = [0, 30, 60, 90, 120, 150] * pi/180;

M = length(alpha);

gaussianKernelPrecision = 2;

outImg = zeros(size(inpImg));

for i=1:M
    angle = alpha(i);
    % defining a so as to vectorize the process
    a = [cos(angle) 0; sin(angle) cos(angle); 0 sin(angle)];
    w = sqrtT*a;
    
    norms = sqrt(w(:,1).^2 + w(:,2).^2);
    scalingFactor = stepSize./norms;
    w = w.*repmat(scalingFactor,1,2);
    
    %    mFsigma  = norms*16;
    mFsigma  = norms*5;
    mLength = gaussianKernelPrecision * mFsigma;
    
    w = reshape(w,size(inpImg,1),size(inpImg,2),2);
    mLength = reshape(mLength,size(inpImg,1),size(inpImg,2),1);
    
    op = LineIntegralConvolution(inpImg, w, mLength, stepSize);
    
    outImg = outImg + op;
    
end

outImg = outImg/M;
outImg(~specMap) = inpImg(~specMap);
    
