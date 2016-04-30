clear;
close all;
clc;

% mInputImage = im2double(imread('../data/lena512.png'));
mInputImage = zeros(100,100);
mInputImage(40:60,40:60) = 1;

numRows = size(mInputImage, 1);
numCols = size(mInputImage, 2);

[y, specMap] = AddSpeckles(mInputImage);


% Smoothing parameters
smoothingAmplitude  = 60;
sharpnessLevel      = 0.7;
anisotropyLevel     = 0.6;
gradientSmoothness  = 0.6;
tensorSmoothness    = 1.1;
stepSize            = 0.8;

% Running the algorithm
hTimerSatrt = tic();
[ mOutputImage ] = SmoothImage(y, specMap);
runTime = toc(hTimerSatrt);

disp(['FastAnisotropicCurvaturePreservingSmoothing Run Time - ', num2str(runTime), ' [Sec]']);

figure();
imshow(mInputImage, [0, 1]);

figure();
imshow(y, [0, 1]);

figure();
imshow(mOutputImage, [0, 1]);

MSEbefore = sqrt(sumsqr(mInputImage-y))
MSEAfter = sqrt(sumsqr(mInputImage-mOutputImage))
