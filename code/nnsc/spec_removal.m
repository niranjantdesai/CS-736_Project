clear;
clc;
close all;

prepareEnv;

patchSize = 8;

%% Load data
% Load the saved dictionary
load('../../data/nnsc/dictionary/dict.mat');

% load the input image
xTrue = im2double(imresize(imread('../../data/nnsc/raw_images/test7.jpg'),0.25));

N = size(xTrue,1)*size(xTrue,2);

%% Generating specularities

[y, specMap] = AddSpeckles(xTrue);
mask = ~specMap;

%% Initialize solution
% xEfros = EfrosInpainting(y,specMap);

%% Iterate

x = y;

threshold = 1e-5;
maxIters = 20;

costArray = zeros(maxIters+1,1);

param = struct();
param.mode=2;
param.pos=1;
lambda = 1.2/patchSize;
param.lambda = lambda;


temp=zeros(size(xTrue));

% Step size for gradient descent
stepSize = 0.5;
alpha_ = 0.8;
alpha = alpha_/(patchSize^2);



xPatches = mexExtractPatches(x,patchSize,1);
c = mexLasso(xPatches,U,param); % Using Lasso to get coeffs

dictTerm  = 0.5*sumsqr(xPatches - U*c) + lambda*sum(sum(c));
fidelityTerm = sumsqr(mask.*(y-x));

grad = zeros(size(x));
    
cost = (alpha)*dictTerm+(1-alpha)*fidelityTerm;
iter=1;
while(1)
    
    if (iter>maxIters || stepSize<threshold)
        break
    end
    
    % Minimizing w.r.t to c
    xDict = mexCombinePatches(U*c,temp,patchSize,1,1,1);
    grad = alpha_*(x-xDict)+(1-alpha_)*(x-y).*(mask);
    grad(specMap) = x(specMap)-xDict(specMap);
    
    % Minimizing w.r.t to x
    xNew = x - stepSize*grad;
    
    xPatchesNew = mexExtractPatches(xNew,patchSize,1);
    cNew = mexLasso(xPatchesNew,U,param); % Using Lasso to get coeffs

    % get cost
    dictTerm  = 0.5*sumsqr(xPatchesNew - U*cNew) + lambda*sum(sum(cNew));
    
    fidelityTerm = sumsqr(mask.*(y-xNew));
    newCost = (alpha)*dictTerm+(1-alpha)*fidelityTerm;
    
%     figure()
%     subplot(131) ;
%     imshow(xTrue);
%     title('xTrue');
%     subplot(132);
%     imshow(xNew);
%     title('xNew');
%     subplot(133);
%     imshow(xDict);
%     title('xDict');
    
    if newCost<cost
        x = xNew;
        stepSize = stepSize*1.2;
        costArray(iter)=cost;
        cost = newCost;
        xPatches = xPatchesNew;
        c = cNew;
        iter = iter+1;
    else
        stepSize = stepSize*0.5; 
    end
end
costArray(iter)=cost;

z = x;

%% Plot and save

token = num2str(now);

figure(1);
plot(costArray(1:iter));
title('cost');
saveas(1,strcat('../../data/nnsc/spec_removal/',token,'-cost.png'),'png');

imwrite(xTrue,strcat('../../data/nnsc/spec_removal/',token,'-x.png'));
imwrite(y,strcat('../../data/nnsc/spec_removal/',token,'-y.png'));
imwrite(z,strcat('../../data/nnsc/spec_removal/',token,'-z.png'));

