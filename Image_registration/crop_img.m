function [img_cropped,xrange,yrange]=crop_img(img)

img_filt=imboxfilt(double(img),29);
img_scaled=(img_filt-min(img_filt(:)))/max(img_filt(:));

img_bin=img_scaled>0.1;
xpts=find(any(img_bin,1));
ypts=find(any(img_bin,2));

xrange=min(xpts):max(xpts);
yrange=min(ypts):max(ypts);
img_cropped=img(yrange,xrange);