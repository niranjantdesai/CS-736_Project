%img = imresize(imread('../data/lena512.png'),0.25);

img = zeros(100,100);
img(40:60,40:60) = 1;

p1 = 0.001;
p2 = 100;

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

eigenval1 = mMinLambdaMask .* valA + (1 - mMinLambdaMask) .* valB;
eigenval2 = mMinLambdaMask .* valB + (1 - mMinLambdaMask) .* valA;

v1 = tMinLambdaMask .* vecA + (1 - tMinLambdaMask) .* vecB;
v2 = tMinLambdaMask .* vecB + (1 - tMinLambdaMask) .* vecA;


% Calc smoothing geometry tensor field


w1_x = reshape(v1(:,1),size(img,1),size(img,2));
w1_y = reshape(v1(:,2),size(img,1),size(img,2));

w2_x = reshape(v2(:,1),size(img,1),size(img,2));
w2_y = reshape(v2(:,1),size(img,1),size(img,2));

val_1 = reshape(eigenval1,size(img,1),size(img,2));
val_2 = reshape(eigenval2,size(img,1),size(img,2));

figure(1)
imshow(img)

figure(2)
quiver(w1_x,w1_y);

figure(3)
quiver(w2_x,w2_y);

figure(4);
imagesc(val_1);
colorbar;

figure(5);
imagesc(val_2);
colorbar;


