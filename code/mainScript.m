clear;
close all;
clc;

%% Load and add speckles
inpImg = im2double(imresize(imread('../data/test4.jpg'),0.25));


numRows = size(inpImg, 1);
numCols = size(inpImg, 2);

[y, specMap] = AddSpeckles(inpImg);


%% Running the algorithm
hTimerSatrt = tic();

maxIters = 7;
rmsThresh = 1e-4;

prevImg = y;
nextImg = zeros(size(y));

rmsdiff = sqrt(sumsqr(prevImg-nextImg)/(numRows*numCols*size(inpImg,3)));

rmsDiffArray = zeros(maxIters,1);

iter=1;
while rmsdiff>rmsThresh && iter<maxIters
    rmsDiffArray(iter) = rmsdiff;
    nextImg = Inpaint(prevImg, specMap);
    rmsdiff = sqrt(sumsqr(prevImg-nextImg)/(numRows*numCols*size(inpImg,3)));
    iter = iter+1;

    prevImg = nextImg;
end
outImg = nextImg;
runTime = toc(hTimerSatrt);

token = num2str(now);
basePath = '../results/';

figure();
plot(rmsDiffArray(1:iter));
saveas(gcf,strcat(basePath,token,'-rms.png'));

imwrite(inpImg,strcat(basePath,token,'-x.png'));
imwrite(y,strcat(basePath,token,'-y.png'));
imwrite(outImg,strcat(basePath,token,'-z.png'));

disp([' Run Time - ', num2str(runTime), ' [Sec]']);

figure();
imshow(inpImg, [0, 1]);

figure();
imshow(y, [0, 1]);

figure();
imshow(outImg, [0, 1]);

