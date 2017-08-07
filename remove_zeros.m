function [redImgOut,greenImgOut] = remove_zeros(redImg,greenImg)

anyZeros = any(redImg==0,4);
NonZerosPos = find(~anyZeros);
[i,j,k] = ind2sub(size(anyZeros),NonZerosPos);
iRange = min(i):max(i);
jRange =  min(j):max(j);
kRange = min(k):max(k);

redImgOut = redImg(iRange,jRange,kRange,:);
greenImgOut = greenImg(iRange,jRange,kRange,:);






end