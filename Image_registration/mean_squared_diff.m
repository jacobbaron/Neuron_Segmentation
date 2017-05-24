function [metric,corr] = mean_squared_diff(img)
metric=zeros(size(img,4),1);
corr=ones(size(img,4),1);
%variance=metric;
fixed=img(:,:,:,1);
fixed = fixed(:);
for ii=2:length(metric)
moving=img(:,:,:,ii);
moving=moving(:);
neither_zero = fixed~=0 & moving~=0;
metric(ii)= mean((moving(neither_zero)-fixed(neither_zero)).^2);
movingi=moving(neither_zero);
fixedi=fixed(neither_zero);
corr(ii)=1/(length(movingi)-1)*sum((movingi-mean(movingi))/std(double(movingi)).*...
    (fixedi-mean(fixedi))/std(double(fixedi)));
%variance(ii)=var(
end