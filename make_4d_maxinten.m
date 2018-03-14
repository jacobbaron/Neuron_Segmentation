function [imgMax] = make_4d_maxinten(img4D,pixelSize)
    x2z = pixelSize(3)/pixelSize(2);
    imgSize=size(img4D);
    imgSize(3) = round(imgSize(3)*x2z);
    
    imgMax = zeros(imgSize(1)+imgSize(3),imgSize(2)+imgSize(3),imgSize(4));
    zIdx = linspace(1,imgSize(3),size(img4D,3));
    
    maxImgXY = squeeze(max(img4D,[],3));

    maxImgXY(1,1,:) = maxImgXY(1,2,:);
    maxImgXY(1,end,:) = maxImgXY(1,end-1,:);
    maxImgXY(end,1,:) = maxImgXY(end-1,1,:);
    maxImgXY(end,end,:) = maxImgXY(end-1,end-1,:);

    maxImgXZ = interp1(zIdx,permute(squeeze(max(img4D,[],1)),[2,1,3]),1:imgSize(3));
    maxImgYZ = permute(interp1(zIdx,permute(squeeze(max(img4D,[],2)),[2,1,3]),1:imgSize(3)),[2,1,3]);

%     imgMax=double(max(img4D(:)))*...
%         ones(imgSize(1)+imgSize(3)+1,...
%         imgSize(2)+imgSize(3)+1,imgSize(4));
    imgMax(1:imgSize(1),1:imgSize(2),:) = maxImgXY;
    imgMax(imgSize(1)+1:end, 1:imgSize(2),:) = maxImgXZ;
    imgMax(1:imgSize(1), imgSize(2)+1:end,:) = maxImgYZ;