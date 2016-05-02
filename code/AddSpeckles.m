function [ y, specMap ] = AddSpeckles( xTrue )

    X = size(xTrue,1);
    Y = size(xTrue,2);
    % ** Adding specularities **
    specMap = false(size(xTrue)); % 1 indicates no speculatiry


    % 3*3 speckles
    num = 8;
    centers2_x = randi([2,X-1],num,1);
    centers2_y = randi([2,Y-1],num,1);

    for i=1:num
        specMap(centers2_x(i)-1:centers2_x(i)+1,centers2_y(i)-1:centers2_y(i)+1,:) = 1;
    end

    % 5*5 speckles
    num = 7;
    centers2_x = randi([3,X-2],num,1);
    centers2_y = randi([3,Y-2],num,1);

    for i=1:num
        specMap(centers2_x(i)-2:centers2_x(i)+2,centers2_y(i)-2:centers2_y(i)+2,:) = 1;
    end

    % 7*7 speckles
    num = 3;
    centers2_x = randi([4,X-3],num,1);
    centers2_y = randi([4,Y-3],num,1);

    for i=1:num
        specMap(centers2_x(i)-3:centers2_x(i)+3,centers2_y(i)-3:centers2_y(i)+3,:) = 1;
    end

    % 9*9 speckles
    num = 0;
    centers2_x = randi([5,X-4],num,1);
    centers2_y = randi([5,Y-4],num,1);

    for i=1:num
        specMap(centers2_x(i)-4:centers2_x(i)+4,centers2_y(i)-4:centers2_y(i)+4,:) = 1;
    end

    
    % 5*10 speckles
    num = 2;
    centers2_x = randi([3,X-3],num,1);
    centers2_y = randi([6,Y-6],num,1);

    for i=1:num
        specMap(centers2_x(i)-2:centers2_x(i)+3,centers2_y(i)-5:centers2_y(i)+5,:) = 1;
    end


    y = xTrue;
    whiteNoise = 0.5+0.1*randn(size(xTrue));
    whiteNoise(whiteNoise<0) = 0;
    whiteNoise(whiteNoise>1) = 1;
    y(specMap) = whiteNoise(specMap);


end

