function [img_max_proj]=gen_max_proj(img3D)

    imgXY=max(img3D,[],3);
    imgXZ=squeeze(max(img3D,[],1))';
    imgYZ=squeeze(max(img3D,[],2));
    img_max_proj=zeros(size(img3D,1)+size(img3D,3),size(img3D,2)+size(img3D,3));
    img_max_proj(1:size(img3D,1),1:size(img3D,2))=imgXY;
    img_max_proj(size(img3D,1)+1:end,1:size(img3D,2))=imgXZ;
    img_max_proj(1:size(img3D,1),size(img3D,2)+1:end)=imgYZ;