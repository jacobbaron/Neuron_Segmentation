function [img_cropped]=cropZeros(img_big)
1;
img1=img_big(:,:,:,1);
ind=find(img1);
[i,j,k]=ind2sub(size(img1),ind);
irange=min(i):max(i);
jrange=min(j):max(j);
krange=min(k):max(k);
img_cropped=img_big(irange,jrange,krange,:);