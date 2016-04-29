clear;
close all;
clc;

mInputImage = double(imread('../data/lena512.png'));

% Only single channel image are supported, for color image, run on each
% channel.
mInputImage = mInputImage(:, :, 1);

numRows = size(mInputImage, 1);
numCols = size(mInputImage, 2);

% Additive White Gaussian Noise parameters
mAwgnMean   = 0;
mAwgnStd    = 7;

mInputImageNoisy = mInputImage + ((mAwgnMean .* ones(numRows, numCols)) + (mAwgnStd .* randn(numRows, numCols)));

% Smoothing parameters
smoothingAmplitude  = 60;
sharpnessLevel      = 0.7;
anisotropyLevel     = 0.6;
gradientSmoothness  = 0.6;
tensorSmoothness    = 1.1;
stepSize            = 0.8;

% Running the algorithm
hTimerSatrt = tic();
[ mOutputImage ] = SmoothImage(mInputImageNoisy);
runTime = toc(hTimerSatrt);

disp(['FastAnisotropicCurvaturePreservingSmoothing Run Time - ', num2str(runTime), ' [Sec]']);

figure();
imshow(mInputImage, [0, 255]);

figure();
imshow(mInputImageNoisy, [0, 255]);

figure();
imshow(mOutputImage, [0, 255]);

MSEbefore = sqrt(sumsqr(mInputImage-mInputImageNoisy))
MSEAfter = sqrt(sumsqr(mInputImage-mOutputImage))
