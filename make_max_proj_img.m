function [img] = make_max_proj_img(img4D,pixelSize)
img3D = mean(img4D,4);

imgSize = size(img3D);
x2z = pixelSize(3)/pixelSize(2);
imgSize(3) = round(imgSize(3)*x2z);

img = zeros(imgSize(1)+imgSize(3),imgSize(2)+imgSize(3));
zIdx = linspace(1,imgSize(3),size(img4D,3));
maxImgXY = squeeze(max(img3D,[],3));

maxImgXY(1,1) = maxImgXY(1,2);
maxImgXY(1,end) = maxImgXY(1,end-1);
maxImgXY(end,1) = maxImgXY(end-1,1);
maxImgXY(end,end) = maxImgXY(end-1,end-1);

maxImgXZ = interp1(zIdx,squeeze(max(img3D,[],1))',1:imgSize(3));
maxImgYZ = interp1(zIdx,squeeze(max(img3D,[],2))',1:imgSize(3))';

img(1:imgSize(1),1:imgSize(2)) = maxImgXY;
img(imgSize(1)+1:end,1:imgSize(2)) = maxImgXZ;
img(1:imgSize(1),imgSize(2)+1:end) = maxImgYZ;
