function [ outImg, specMap ] = AddSpeckles( inpImg )
    X = size(inpImg,1);
    Y = size(inpImg,2);
    % ** Adding specularities **
    specMap = false(size(inpImg)); % 1 indicates no speculatiry


    % 3*3 speckles
    num = 0;
    centers2_x = randi([2,X-1],num,1);
    centers2_y = randi([2,Y-1],num,1);

    for i=1:num
        specMap(centers2_x(i)-1:centers2_x(i)+1,centers2_y(i)-1:centers2_y(i)+1,:) = 1;
    end

    % 5*5 speckles
    num = 0;
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
    num = 6;
    centers2_x = randi([5,X-4],num,1);
    centers2_y = randi([5,Y-4],num,1);

    for i=1:num
        specMap(centers2_x(i)-4:centers2_x(i)+4,centers2_y(i)-4:centers2_y(i)+4,:) = 1;
    end


    % 15*15 speckles
    num = 3;
    centers2_x = randi([8,X-7],num,1);
    centers2_y = randi([8,Y-7],num,1);

    for i=1:num
        specMap(centers2_x(i)-7:centers2_x(i)+7,centers2_y(i)-7:centers2_y(i)+7,:) = 1;
    end
    
    % 10*50 speckles
    num = 0;
    centers2_x = randi([8,X-7],num,1);
    centers2_y = randi([37,Y-36],num,1);

    for i=1:num
        specMap(centers2_x(i)-5:centers2_x(i)+5,centers2_y(i)-25:centers2_y(i)+25,:) = 1;
    end




    outImg = inpImg;
    outImg(specMap) = zeros;


end

