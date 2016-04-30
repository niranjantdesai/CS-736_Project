% Learn nnsc dict using grayscale images

clear;
close all;

prepareEnv;

%% Initializing params

patchSize = 8; % per color component
numDictAtoms = 23*23;
numTrainingPatches = 15e3;

varianceThreshold = 0.1; % threshold for variance of the patch to be 
                        % selected for training


%% Loading/Generating the training set
trainingSet = [];
if exist('../../data/fret/training_set/trainingSet.mat', 'file')==2 
    load('../../data/fret/training_set/trainingSet.mat','trainingSet'); % loads trainingSet
else
    dirData = dir('../../data/fret/raw_images/');
    dirIndex = [dirData.isdir];
    fileNames = {dirData(~dirIndex).name}'; % gets the list of all the files
    
    L = size(fileNames,1);
    
    % looping over the image files
    for i=1:L
        inpImage = im2double(imresize(imread(...
                strcat('../../data/fret/raw_images/',fileNames{i})),0.25));
            
        patchSet = mexExtractPatches(inpImage,patchSize,1);
        
        % select high variance patches
        varianceArray = var(patchSet);

        varianceArray = sqrt(varianceArray);
        
        trainingSet = [trainingSet, patchSet(:,varianceArray>varianceThreshold)];
%         trainingSet = [trainingSet, patchSet];
    end
    patchSet = [];
    
    % normalizing each patch
    norms = sqrt(sum(trainingSet.^2));
    trainingSet = trainingSet./(ones(patchSize^2,1)*norms);
    
    save('../../data/fret/training_set/trainingSet.mat','trainingSet');
end

N = size(trainingSet,2);

% Displaying some training patches
indices = unidrnd(N,1,50*50);
subset = trainingSet(:,indices);
img = viewPatches(subset,patchSize);

imwrite(img,'../../data/fret/training_set/image.png');
figure(1);
imshow(img);
title('Some training Patches');
    

%% Learning dictionary
param = struct();
param.K = numDictAtoms;
param.lambda = 1.2/patchSize;
param.iter = 1.5e3;

[U,V] = nnsc(trainingSet,param);

save('../../data/fret/dictionary/dict.mat');

% Displaying dictionary patches
img = viewPatches(U,patchSize);

imwrite(img,'../../data/fret/dictionary/image.png');
figure(2);
imshow(img);
title('Dictionary atoms');

%% Analysis


reconstruction = U*V;

pixelError = (trainingSet-reconstruction).^2;
patchError = sum(pixelError);

figure(3);
plot(trainingSet(:,1));
hold on;
plot(reconstruction(:,1));
hold off;
title('First patch');
legend('original','reconstructed');

figure(4);
plot(patchError);
title('Patch Error');


nonZeroCoeffs = (V~=0);
numNonZero = sum(nonZeroCoeffs)/size(V,2);
figure(5);
endIndex = min(200,length(numNonZero));
bar(numNonZero(1:endIndex));
title('Ratio of non zero coeffs per patch');

%save(strcat('../data/workspace/',num2str(now),'.mat'));
